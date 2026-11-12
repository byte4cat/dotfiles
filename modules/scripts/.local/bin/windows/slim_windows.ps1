# ==============================================================================
# Slim down a Windows 10 VM that only runs LINE (run it in the guest).
#
# Disables updates, telemetry, search/Cortana, Copilot, ads/suggestions, Xbox,
# OneDrive, preinstalled apps and a few background services, and sets a solid
# dark gray desktop. Windows Defender is deliberately LEFT ON.
#
# Usage (elevated PowerShell in the guest):
#   powershell -ExecutionPolicy Bypass -File .\slim_windows.ps1 -List
#   powershell -ExecutionPolicy Bypass -File .\slim_windows.ps1 -DryRun
#   powershell -ExecutionPolicy Bypass -File .\slim_windows.ps1
#   powershell -ExecutionPolicy Bypass -File .\slim_windows.ps1 -Only updates,telemetry
#   powershell -ExecutionPolicy Bypass -File .\slim_windows.ps1 -Skip apps,onedrive
#   powershell -ExecutionPolicy Bypass -File .\slim_windows.ps1 -Restore
#
#   -List     Show the available steps and exit
#   -DryRun   Print what would change, change nothing
#   -Only     Run only these steps        -Skip   Run all except these steps
#   -Restore  Put back every registry value, service start type and scheduled
#             task changed by this script (from the backup file)
#
# Before the first change the original values are saved to
#   %ProgramData%\slim_windows_backup.json
# Reruns never overwrite saved originals. NOT restorable: removed apps
# (reinstall from the Store) and the OneDrive uninstall.
# Reboot the guest afterwards. Take a VM snapshot first.
# Keep this file ASCII-only: Windows PowerShell 5.1 reads BOM-less files as ANSI.
# ==============================================================================
param(
    [switch]$Restore,
    [switch]$DryRun,
    [switch]$List,
    [string[]]$Only,
    [string[]]$Skip
)

$ErrorActionPreference = 'Stop'

# With "powershell -File", "-Skip a,b" arrives as the single string "a,b".
# Split on commas so both calling styles work.
if ($Only) { $Only = @($Only | ForEach-Object { $_ -split ',' } | Where-Object { $_ }) }
if ($Skip) { $Skip = @($Skip | ForEach-Object { $_ -split ',' } | Where-Object { $_ }) }

$BackupFile = Join-Path $env:ProgramData 'slim_windows_backup.json'
$Backup = [ordered]@{}

# ---------------------------------------------------------------- helpers ----
function Say($msg) { Write-Host $msg }

function Save-Backup {
    if ($DryRun) { return }
    $Backup | ConvertTo-Json -Depth 4 | Set-Content -Path $BackupFile -Encoding UTF8
}

function Remember-Reg($Path, $Name) {
    $key = "reg|$Path|$Name"
    if ($Backup.Contains($key)) { return }
    $existed = $false
    $value = $null
    $kind = $null
    $item = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue
    if ($null -ne $item) {
        $existed = $true
        $value = $item.$Name
        $kind = (Get-Item -Path $Path).GetValueKind($Name).ToString()
    }
    $Backup[$key] = @{ type = 'reg'; path = $Path; name = $Name; existed = $existed; value = $value; kind = $kind }
}

function Set-Reg($Path, $Name, $Value, $Kind = 'DWord') {
    Say "  reg   $Path\$Name = $Value"
    if ($DryRun) { return }
    Remember-Reg $Path $Name
    if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
    New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType $Kind -Force | Out-Null
}

function Disable-Svc($Name) {
    $path = "HKLM:\SYSTEM\CurrentControlSet\Services\$Name"
    if (-not (Test-Path $path)) { return }
    Say "  svc   $Name -> disabled"
    if ($DryRun) { return }
    Remember-Reg $path 'Start'
    try {
        Set-ItemProperty -Path $path -Name 'Start' -Value 4
    } catch {
        Write-Warning ("cannot disable service " + $Name + ": " + $_.Exception.Message)
        return
    }
    try { Stop-Service -Name $Name -Force -ErrorAction Stop } catch { }
}

function Disable-Tasks($TaskPath, $NameFilter = '*') {
    $tasks = @(Get-ScheduledTask -TaskPath $TaskPath -ErrorAction SilentlyContinue |
        Where-Object { $_.TaskName -like $NameFilter -and $_.State -ne 'Disabled' })
    foreach ($t in $tasks) {
        $label = "  task  " + $t.TaskPath + $t.TaskName
        if ($DryRun) { Say ($label + " -> would disable"); continue }
        $key = "task|$($t.TaskPath)|$($t.TaskName)"
        if (-not $Backup.Contains($key)) {
            $Backup[$key] = @{ type = 'task'; path = $t.TaskPath; name = $t.TaskName }
        }
        try {
            Disable-ScheduledTask -TaskPath $t.TaskPath -TaskName $t.TaskName -ErrorAction Stop | Out-Null
            Say ($label + " -> disabled")
        } catch {
            Say ($label + " -> FAILED (protected by Windows, harmless once its service is disabled)")
        }
    }
}

# ------------------------------------------------------------------ steps ----
$Steps = [ordered]@{}

$Steps['updates'] = @{
    desc = 'Windows Update, Delivery Optimization, Store auto-update'
    run  = {
        foreach ($s in 'wuauserv', 'UsoSvc', 'WaaSMedicSvc', 'DoSvc') { Disable-Svc $s }
        Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' 'NoAutoUpdate' 1
        Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' 'AUOptions' 1
        Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore' 'AutoDownload' 2
        Disable-Tasks '\Microsoft\Windows\WindowsUpdate\'
        Disable-Tasks '\Microsoft\Windows\UpdateOrchestrator\'
        Disable-Tasks '\Microsoft\Windows\WaaSMedic\'
    }
}

$Steps['telemetry'] = @{
    desc = 'Telemetry, error reporting, feedback, compatibility appraiser'
    run  = {
        foreach ($s in 'DiagTrack', 'dmwappushservice', 'WerSvc') { Disable-Svc $s }
        Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' 'AllowTelemetry' 0
        Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' 'DoNotShowFeedbackNotifications' 1
        Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting' 'Disabled' 1
        Disable-Tasks '\Microsoft\Windows\Customer Experience Improvement Program\'
        Disable-Tasks '\Microsoft\Windows\Application Experience\'
        Disable-Tasks '\Microsoft\Windows\Feedback\Siuf\'
    }
}

$Steps['search'] = @{
    desc = 'Search indexer, Cortana, web results in Start search'
    run  = {
        Disable-Svc 'WSearch'
        $p = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
        Set-Reg $p 'AllowCortana' 0
        Set-Reg $p 'DisableWebSearch' 1
        Set-Reg $p 'ConnectedSearchUseWeb' 0
        Set-Reg $p 'AllowSearchToUseLocation' 0
        Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' 'BingSearchEnabled' 0
        Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' 'CortanaConsent' 0
    }
}

$Steps['copilot'] = @{
    desc = 'Copilot (policy + taskbar button)'
    run  = {
        Set-Reg 'HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot' 'TurnOffWindowsCopilot' 1
        Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot' 'TurnOffWindowsCopilot' 1
        Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' 'ShowCopilotButton' 0
    }
}

$Steps['consumer'] = @{
    desc = 'Ads, suggestions, consumer features, advertising ID'
    run  = {
        Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' 'DisableWindowsConsumerFeatures' 1
        Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' 'DisableWindowsSpotlightFeatures' 1
        Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo' 'DisabledByGroupPolicy' 1
        Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' 'Enabled' 0
        $cdm = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
        foreach ($n in 'SilentInstalledAppsEnabled', 'SystemPaneSuggestionsEnabled', 'SoftLandingEnabled',
            'SubscribedContent-310093Enabled', 'SubscribedContent-338387Enabled', 'SubscribedContent-338388Enabled',
            'SubscribedContent-338389Enabled', 'SubscribedContent-338393Enabled', 'SubscribedContent-353694Enabled',
            'SubscribedContent-353696Enabled') {
            Set-Reg $cdm $n 0
        }
    }
}

$Steps['wallpaper'] = @{
    desc = 'Solid dark gray desktop (#1E1E1E), no slideshow, no Spotlight lock screen'
    run  = {
        # BackgroundType: 0 = picture, 1 = solid color, 2 = slideshow
        Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers' 'BackgroundType' 1
        Set-Reg 'HKCU:\Control Panel\Desktop' 'Wallpaper' '' 'String'
        Set-Reg 'HKCU:\Control Panel\Colors' 'Background' '30 30 30' 'String'
        $cdm = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
        Set-Reg $cdm 'RotatingLockScreenEnabled' 0
        Set-Reg $cdm 'RotatingLockScreenOverlayEnabled' 0
        if (-not $DryRun) {
            # Apply now, without waiting for the next sign-in
            try {
                Add-Type -Namespace SlimWin -Name Native -MemberDefinition @'
[DllImport("user32.dll", CharSet = CharSet.Unicode)]
public static extern bool SystemParametersInfo(int action, int param, string value, int flags);
[DllImport("user32.dll")]
public static extern bool SetSysColors(int count, int[] elements, int[] colors);
'@
                [SlimWin.Native]::SystemParametersInfo(0x14, 0, '', 3) | Out-Null
                # COLOR_BACKGROUND = 1, color is 0x00BBGGRR
                [SlimWin.Native]::SetSysColors(1, [int[]]@(1), [int[]]@(0x1E1E1E)) | Out-Null
            } catch {
                Write-Warning ("could not apply the wallpaper live (sign out and in): " + $_.Exception.Message)
            }
        }
    }
}

$Steps['xbox'] = @{
    desc = 'Xbox services and Game Bar / Game DVR'
    run  = {
        foreach ($s in 'XblAuthManager', 'XblGameSave', 'XboxGipSvc', 'XboxNetApiSvc') { Disable-Svc $s }
        Set-Reg 'HKCU:\System\GameConfigStore' 'GameDVR_Enabled' 0
        Set-Reg 'HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR' 'AppCaptureEnabled' 0
        Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR' 'AllowGameDVR' 0
    }
}

$Steps['onedrive'] = @{
    desc = 'OneDrive (policy + uninstall; the uninstall is NOT restorable)'
    run  = {
        Set-Reg 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive' 'DisableFileSyncNGSC' 1
        $setup = Join-Path $env:SystemRoot 'System32\OneDriveSetup.exe'
        if (-not (Test-Path $setup)) { $setup = Join-Path $env:SystemRoot 'SysWOW64\OneDriveSetup.exe' }
        if (Test-Path $setup) {
            Say "  app   OneDrive -> uninstall"
            if (-not $DryRun) {
                Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue
                Start-Process -FilePath $setup -ArgumentList '/uninstall' -Wait
            }
        }
    }
}

$Steps['apps'] = @{
    desc = 'Remove preinstalled apps (NOT restorable; Store, Calculator, Photos are kept)'
    run  = {
        $apps = @(
            'Microsoft.XboxApp', 'Microsoft.XboxGameOverlay', 'Microsoft.XboxGamingOverlay',
            'Microsoft.XboxIdentityProvider', 'Microsoft.XboxSpeechToTextOverlay', 'Microsoft.GamingApp',
            'Microsoft.ZuneMusic', 'Microsoft.ZuneVideo', 'Microsoft.BingNews', 'Microsoft.BingWeather',
            'Microsoft.MicrosoftSolitaireCollection', 'Microsoft.GetHelp', 'Microsoft.Getstarted',
            'Microsoft.WindowsFeedbackHub', 'Microsoft.People', 'Microsoft.SkypeApp', 'Microsoft.YourPhone',
            'Microsoft.MixedReality.Portal', 'Microsoft.Microsoft3DViewer', 'Microsoft.MSPaint',
            'Microsoft.MicrosoftOfficeHub', 'Microsoft.Todos', 'Microsoft.PowerAutomateDesktop',
            'Microsoft.WindowsMaps', 'Microsoft.Office.OneNote', 'microsoft.windowscommunicationsapps',
            'MicrosoftTeams', 'Clipchamp.Clipchamp', 'Microsoft.549981C3F5F10'
        )
        # Removal order: current user first (works where -AllUsers fails with
        # 0x80070002), then -AllUsers, then the provisioned copy so it does not
        # come back for new users.
        foreach ($a in $apps) {
            $pkgs = @(Get-AppxPackage -Name $a -AllUsers -ErrorAction SilentlyContinue)
            foreach ($p in $pkgs) {
                $label = "  app   " + $p.Name
                if ($DryRun) { Say ($label + " -> would remove"); continue }
                $removed = $false
                try {
                    Remove-AppxPackage -Package $p.PackageFullName -ErrorAction Stop
                    $removed = $true
                } catch { }
                if (-not $removed) {
                    try {
                        Remove-AppxPackage -Package $p.PackageFullName -AllUsers -ErrorAction Stop
                        $removed = $true
                    } catch { }
                }
                if ($removed) { Say ($label + " -> removed") } else { Say ($label + " -> FAILED (left as is, harmless)") }
            }
            if (-not $DryRun) {
                $prov = @(Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue |
                    Where-Object { $_.DisplayName -eq $a })
                foreach ($pp in $prov) {
                    try {
                        Remove-AppxProvisionedPackage -Online -PackageName $pp.PackageName -ErrorAction Stop | Out-Null
                        Say ("  app   " + $a + " (provisioned) -> removed")
                    } catch { }
                }
            }
        }
    }
}

$Steps['defrag'] = @{
    desc = 'Scheduled disk defrag (Windows sees the virtual disk as HDD; defrag only bloats the qcow2 image)'
    run  = {
        Disable-Tasks '\Microsoft\Windows\Defrag\' 'ScheduledDefrag'
    }
}

$Steps['perf'] = @{
    desc = 'SysMain (Superfetch), hibernation (frees hiberfil.sys)'
    run  = {
        Disable-Svc 'SysMain'
        Say "  power hibernate off"
        if (-not $DryRun) {
            Remember-Reg 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' 'HibernateEnabled'
            powercfg -h off
        }
    }
}

# --------------------------------------------------------------- dispatch ----
if ($List) {
    foreach ($n in $Steps.Keys) { Write-Host ('{0,-10} {1}' -f $n, $Steps[$n].desc) }
    exit 0
}

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error 'Run this script from an elevated (Administrator) PowerShell.'
}

if (Test-Path $BackupFile) {
    $saved = Get-Content -Path $BackupFile -Raw | ConvertFrom-Json
    foreach ($p in $saved.PSObject.Properties) { $Backup[$p.Name] = $p.Value }
}

if ($Restore) {
    if ($Backup.Count -eq 0) {
        Write-Host 'No backup found, nothing to restore.'
        exit 0
    }
    $wantHibernate = $false
    foreach ($e in $Backup.Values) {
        if ($e.type -eq 'reg') {
            Say ("  restore reg " + $e.path + "\" + $e.name)
            if ($DryRun) { continue }
            if ($e.existed) {
                if (-not (Test-Path $e.path)) { New-Item -Path $e.path -Force | Out-Null }
                $val = $e.value
                if ($e.kind -eq 'DWord') { $val = [int]$e.value }
                New-ItemProperty -Path $e.path -Name $e.name -Value $val -PropertyType $e.kind -Force | Out-Null
            } else {
                Remove-ItemProperty -Path $e.path -Name $e.name -ErrorAction SilentlyContinue
            }
            if ($e.name -eq 'HibernateEnabled' -and $e.existed -and [int]$e.value -eq 1) { $wantHibernate = $true }
        } elseif ($e.type -eq 'task') {
            Say ("  restore task " + $e.path + $e.name)
            if ($DryRun) { continue }
            try { Enable-ScheduledTask -TaskPath $e.path -TaskName $e.name | Out-Null } catch { }
        }
    }
    if (-not $DryRun) {
        if ($wantHibernate) { powercfg -h on }
        Remove-Item -Path $BackupFile -Force
        Write-Host 'Restored. Reboot the guest to apply. (Removed apps / OneDrive are not reinstalled.)'
    }
    exit 0
}

$names = @($Steps.Keys)
if ($Only) { $names = @($names | Where-Object { $Only -contains $_ }) }
if ($Skip) { $names = @($names | Where-Object { $Skip -notcontains $_ }) }
foreach ($n in @($Only) + @($Skip)) {
    if ($n -and -not $Steps.Contains($n)) { Write-Error ("Unknown step: " + $n + " (use -List)") }
}
if ($names.Count -eq 0) { Write-Error 'No steps selected.' }

foreach ($n in $names) {
    Write-Host ("[" + $n + "] " + $Steps[$n].desc)
    & $Steps[$n].run
    Save-Backup
}

if ($DryRun) {
    Write-Host 'Dry run: nothing was changed.'
} else {
    Write-Host ('Done. Originals saved to ' + $BackupFile + '. Reboot the guest to apply.')
}
