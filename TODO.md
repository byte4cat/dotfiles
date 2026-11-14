# TODO

## walker quick menu (`modules/scripts/.local/bin/wayland/byte4work-walker-quick-menu`)

- [x] Toggle Bluetooth (`bluetoothctl power on/off`)
- [x] Mute / Unmute Mic (`wpctl set-mute @DEFAULT_SOURCE@ toggle`)
- [x] Screenshot submenu (grim + slurp: full / region / window)
- [x] Cleanup: remove undefined `$INSTANCE_FLAG` in Reload Config
- [x] Cleanup: reconsider `set -e` (menu exits silently on any failure)
- [x] Refactor: map option name -> function instead of one big `case`
- [ ] Verify by hand: Mic Mute, Screenshot -> Window (focus after walker closes)
- [ ] Bluetooth: this PC currently has no controller ("No default controller available"); test on a machine with one

## Later (optional)

- [ ] Bluetooth device picker (connect paired devices)
- [ ] Wifi network picker (`nmcli dev wifi list`)
- [ ] Night light toggle
- [ ] Restart Vesktop / Waybar
- [ ] DND toggle
- [ ] Monitor mode switch (DP-1 only / HDMI only / both)
