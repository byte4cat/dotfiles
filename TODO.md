# TODO

## walker quick menu (`modules/scripts/.local/bin/wayland/byte4work-walker-quick-menu`)

- [ ] Toggle Bluetooth (`bluetoothctl power on/off`)
- [ ] Mute / Unmute Mic (`wpctl set-mute @DEFAULT_SOURCE@ toggle`)
- [ ] Screenshot submenu (grim + slurp: full / region / window)
- [ ] Cleanup: remove undefined `$INSTANCE_FLAG` in Reload Config
- [ ] Cleanup: reconsider `set -e` (menu exits silently on any failure)
- [ ] Refactor: map option name -> function instead of one big `case`

## Later (optional)

- [ ] Wifi network picker (`nmcli dev wifi list`)
- [ ] Night light toggle
- [ ] Restart Vesktop / Waybar
- [ ] DND toggle
- [ ] Monitor mode switch (DP-1 only / HDMI only / both)
