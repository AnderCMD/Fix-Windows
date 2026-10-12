# Fix-Windows

![CI](https://github.com/AnderCMD/Fix-Windows/actions/workflows/ci.yml/badge.svg)
![License](https://img.shields.io/badge/license-MIT-blue)
![Platform](https://img.shields.io/badge/platform-Windows%2010%20%7C%2011-0078D6)

A single-file Windows repair and maintenance toolkit. It runs on plain `cmd.exe` with **no dependencies**; PowerShell is used only as an optional helper and every feature has a fallback.

## Features

| Area | Option |
|------|--------|
| Repair | Quick repair (SFC + DISM CheckHealth), full repair (DISM Check/Scan/Restore + SFC), SFC, DISM RestoreHealth, online CHKDSK with optional scheduled fix |
| Cleanup | Temporary files, crash dumps, thumbnail and INet caches, Recycle Bin, Windows Update cache, component store, Disk Cleanup |
| Tools | Network reset (DNS, Winsock, TCP/IP), icon cache rebuild, restore point, disk health, system info, SFC details export |
| Safety | Confirmation prompts, administrator checks, logging, restore point option |

## Quick start

1. Download or clone the repository:
   ```
   git clone https://github.com/AnderCMD/Fix-Windows.git
   ```
2. Right-click `FixWindows.bat` and choose **Run as administrator**, or run it normally and press `R` in the menu to elevate.
3. Pick an option from the menu.

## Command line

```
FixWindows.bat [/yes] [action]
```

| Action | Description |
|--------|-------------|
| *(none)* | Interactive menu |
| `/quick` | SFC scan + DISM CheckHealth |
| `/full` | DISM Check, Scan, Restore + SFC |
| `/sfc` | System File Checker only |
| `/dism` | DISM RestoreHealth only |
| `/chkdsk` | Online disk scan |
| `/temp` | Delete temporary files |
| `/wu` | Reset Windows Update cache |
| `/net` | Reset the network stack |
| `/cleanup` | Component store cleanup |
| `/icons` | Rebuild icon cache |
| `/restore` | Create a restore point |
| `/disk` | Disk health |
| `/info` | System information |
| `/yes` | Skip confirmation prompts |

The exit code is the result of the last command, so the script is usable from automation.

## Logs

Actions and exit codes are appended to `logs\FixWindows.log` next to the script, or to `%TEMP%\FixWindows.log` if that folder is read-only.

## Safety notes

- Most repair actions require administrator rights; without them the script runs only user-level cleanup and diagnostics.
- Review what an option does before using `/yes`.
- Consider creating a restore point (option `C`) before large repairs.
- The script never downloads or runs external code.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Report vulnerabilities as described in [SECURITY.md](SECURITY.md). Release notes live in [CHANGELOG.md](CHANGELOG.md).

## Author

**Ander González** - [AnderCMD](https://github.com/AnderCMD)

## License

MIT - see [LICENSE](LICENSE).
