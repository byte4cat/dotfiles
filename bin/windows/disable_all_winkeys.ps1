# ==============================================================================
# Disable BOTH Windows keys (left and right) inside the Windows VM (run it in
# the guest).
#
# Why: pressing Super on the Linux host to switch workspaces also reaches the
# VM, and Windows opens the Start menu when the Win key is released.
# To disable only the left Win key, use disable_left_winkey.ps1 instead.
#
# Usage (elevated PowerShell in the guest):
#   powershell -ExecutionPolicy Bypass -File .\disable_all_winkeys.ps1
#   powershell -ExecutionPolicy Bypass -File .\disable_all_winkeys.ps1 -Restore
#
# Writes HKLM\SYSTEM\CurrentControlSet\Control\Keyboard Layout\Scancode Map
# (maps left Win E0 5B and right Win E0 5C to nothing). Reboot the guest to apply.
# NOTE: this overwrites an existing Scancode Map, and Win+<key> shortcuts
# (Win+E, Win+D, ...) stop working in the guest.
# Keep this file ASCII-only: Windows PowerShell 5.1 reads BOM-less files as ANSI.
# ==============================================================================
param(
    [switch]$Restore
)

$ErrorActionPreference = 'Stop'

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error 'Run this script from an elevated (Administrator) PowerShell.'
}

$path = 'HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout'
$name = 'Scancode Map'
$existing = (Get-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue).$name

if ($Restore) {
    if ($null -eq $existing) {
        Write-Host 'Scancode Map not set, nothing to restore.'
    } else {
        Remove-ItemProperty -Path $path -Name $name
        Write-Host 'Scancode Map removed. Reboot the guest to apply.'
    }
    exit 0
}

# header(8 bytes) + entry count (3 = 2 mappings + null terminator)
# + mapping (new=0000, old=E05B left Win) + mapping (new=0000, old=E05C right Win)
# + null terminator
$value = [byte[]](0,0,0,0, 0,0,0,0, 3,0,0,0, 0,0,0x5B,0xE0, 0,0,0x5C,0xE0, 0,0,0,0)

if ($null -ne $existing -and -not (@($existing) -join ',' -eq ($value -join ','))) {
    Write-Warning ('An existing Scancode Map will be overwritten: ' + (($existing | ForEach-Object { '{0:X2}' -f $_ }) -join ' '))
}

New-ItemProperty -Path $path -Name $name -PropertyType Binary -Value $value -Force | Out-Null
Write-Host 'Both Win keys disabled. Reboot the guest to apply.'
