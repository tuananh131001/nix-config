# i3 Window Manager Cheatsheet

> **Note:** `$mod` is set to `Mod4` (Command/Super key on Mac-like keyboards with keyd remapping)

## Core Commands

| Key Binding | Action |
|------------|--------|
| `$mod + Enter` | Open terminal (Ghostty) |
| `$mod + n` | Open terminal (Ghostty) |
| `$mod + Shift + q` | Kill focused window |
| `$mod + d` | Launch dmenu (program launcher) |
| `$mod + Shift + c` | Reload i3 configuration |
| `$mod + Shift + r` | Restart i3 in place |
| `$mod + Shift + e` | Exit i3 (logout) |

## Window Focus

| Key Binding | Action |
|------------|--------|
| `$mod + j` | Focus left |
| `$mod + k` | Focus down |
| `$mod + l` | Focus up |
| `$mod + semicolon` | Focus right |
| `$mod + Left` | Focus left (arrow keys) |
| `$mod + Down` | Focus down (arrow keys) |
| `$mod + Up` | Focus up (arrow keys) |
| `$mod + Right` | Focus right (arrow keys) |
| `$mod + a` | Focus parent container |
| `$mod + space` | Toggle focus between tiling/floating windows |

## Window Movement

| Key Binding | Action |
|------------|--------|
| `$mod + Shift + j` | Move window left |
| `$mod + Shift + k` | Move window down |
| `$mod + Shift + l` | Move window up |
| `$mod + Shift + semicolon` | Move window right |
| `$mod + Shift + Left` | Move window left (arrow keys) |
| `$mod + Shift + Down` | Move window down (arrow keys) |
| `$mod + Shift + Up` | Move window up (arrow keys) |
| `$mod + Shift + Right` | Move window right (arrow keys) |
| `$mod + Mouse` | Drag floating windows |

## Window Layout

| Key Binding | Action |
|------------|--------|
| `$mod + h` | Split horizontally |
| `$mod + v` | Split vertically |
| `$mod + f` | Toggle fullscreen |
| `$mod + s` | Stacking layout |
| `$mod + w` | Tabbed layout |
| `$mod + e` | Toggle split layout |
| `$mod + Shift + space` | Toggle tiling/floating |

## Workspaces

| Key Binding | Action |
|------------|--------|
| `$mod + 1` | Switch to workspace 1 |
| `$mod + 2` | Switch to workspace 2 |
| `$mod + 3` | Switch to workspace 3 |
| `$mod + 4` | Switch to workspace 4 |
| `$mod + 5` | Switch to workspace 5 |
| `$mod + 6` | Switch to workspace 6 |
| `$mod + 7` | Switch to workspace 7 |
| `$mod + 8` | Switch to workspace 8 |
| `$mod + 9` | Switch to workspace 9 |
| `$mod + 0` | Switch to workspace 10 |
| `$mod + Shift + 1-0` | Move container to workspace 1-10 |

## Resize Mode

| Key Binding | Action |
|------------|--------|
| `$mod + r` | Enter resize mode |
| `j` / `Left` | Shrink width (in resize mode) |
| `k` / `Down` | Grow height (in resize mode) |
| `l` / `Up` | Shrink height (in resize mode) |
| `semicolon` / `Right` | Grow width (in resize mode) |
| `Enter` / `Escape` | Exit resize mode |

## Audio Controls

| Key Binding | Action |
|------------|--------|
| `XF86AudioRaiseVolume` | Increase volume |
| `XF86AudioLowerVolume` | Decrease volume |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioMicMute` | Toggle microphone mute |

## keyd Mac-like Remapping

With keyd enabled, the following Mac-like shortcuts work system-wide:

| Key Binding | Action |
|------------|--------|
| `Cmd + c` | Copy (sends Ctrl+Insert) |
| `Cmd + v` | Paste (sends Shift+Insert) |
| `Cmd + x` | Cut (sends Shift+Delete) |
| `Cmd + Left` | Home |
| `Cmd + Right` | End |
| `Cmd + Tab` | Application switcher |
| `Cmd + 1-9` | Switch to tab 1-9 (Alt+1-9) |
| `Cmd + Backtick` | Cycle windows in application group |
| `Cmd + n` | New terminal (i3-specific mapping) |

## Tips

- **Floating modifier:** Hold `$mod` and drag windows with mouse
- **Tiling drag:** Click and drag title bar to move tiling windows
- **Status bar:** i3status displays at the bottom
- **Auto-start:** Applications in `~/.config/autostart` launch automatically
