# Changelog

All notable changes to this project are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/) and the project uses [Semantic Versioning](https://semver.org/).

## [2.0.0]

### Added
- Interactive menu with repair, cleanup and diagnostic tools.
- Non-interactive mode with flags such as `/quick`, `/full`, `/temp` and `/yes`.
- Temporary file cleanup, Windows Update cache reset, component store cleanup, network reset, icon cache rebuild, restore point creation, disk health and system info.
- Logging to `logs\FixWindows.log`.
- Self-elevation with or without PowerShell.
- GitHub Actions smoke tests and `.gitattributes` enforcing CRLF.

### Changed
- PowerShell is now optional; the script runs on plain `cmd.exe`.
- Admin detection no longer relies on `openfiles`.

## [1.0.0]
- Initial SFC and DISM repair script.
