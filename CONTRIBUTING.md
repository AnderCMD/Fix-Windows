# Contributing to Fix-Windows

Thanks for your interest in contributing! This project is a small Windows batch script, so contributions are meant to stay simple and easy to review.

## How to contribute

1. Fork the repository.
2. Create a new branch for your change:
   ```
   git checkout -b feature/my-improvement
   ```
3. Make your changes.
4. Test your changes on a Windows machine (Command Prompt or PowerShell) to make sure the script still runs correctly.
5. Commit your changes with a clear, descriptive message.
6. Push your branch and open a pull request against `dev`.

## Branches and releases

- `dev` is the integration branch; open pull requests against it.
- `main` is protected: it only accepts pull requests from `dev` (checked by the "Enforce source branch" workflow) and requires CI to pass.
- `main` is stable. Every push to `main` runs the Release workflow, which reads `VERSION` from `FixWindows.bat` and publishes a GitHub Release `vX.Y.Z` with generated notes. Bump `VERSION` and update `CHANGELOG.md` before merging into `main`; if the tag already exists, no release is created.

## Reporting bugs

If you find a bug, please open an [issue](https://github.com/AnderCMD/Fix-Windows/issues) and include:

- A clear description of the problem.
- Steps to reproduce it.
- The Windows version you're using.
- Any relevant error messages or output.

## Suggesting enhancements

Feature and improvement suggestions are welcome. Please open an issue describing the enhancement and why it would be useful.

## Code style

- Keep the script compatible with standard Windows Command Prompt (`cmd.exe`). PowerShell may only be used optionally, with a non-PowerShell fallback.
- Keep `FixWindows.bat` in ASCII with CRLF line endings (enforced by `.gitattributes` and CI).
- Avoid `!` and unbalanced parentheses in text echoed inside `( )` blocks; delayed expansion is enabled.
- New actions: add an `:a_name` label, a menu entry, a CLI flag, and update the README and CHANGELOG.
- Do not hardcode drive letters or user paths; use environment variables.
- Write comments and output messages in English.
- Keep changes minimal and focused on a single purpose per pull request.

## Code of Conduct

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md).
