# Fix-Windows

_This project contains an automated batch script that checks the integrity of Windows system files and repairs them if necessary. It uses built-in Windows tools to detect and fix corrupted or missing system files._

## Getting Started 🚀

_These instructions will get you a copy of the project up and running on your local machine for development and testing purposes._

### Prerequisites 📋

To run this project on your machine, you need a Windows operating system and access to PowerShell or Command Prompt.

### Installation 🔧

1. Clone the repository
    ```
    git clone https://github.com/AnderCMD/Fix-Windows.git
    ```

2. Navigate to the project directory
    ```
    cd Fix-Windows
    ```

3. Run the script
    ```
    FixWindows.bat
    ```

The script will run and check the integrity of the Windows system files. If issues are found, it will automatically attempt to repair them.

## Running the script ⚙️

The script performs the following steps:

1. Runs the `sfc /scannow` tool to check the integrity of system files.
2. If issues are found, it attempts to repair them automatically.
3. If `sfc` cannot fix the issues, the script runs `DISM` to perform a deeper repair.

## Deployment 📦

This project does not require deployment, as the script is designed to run locally on a Windows machine.

## Built With 🛠️

* [Batch](https://ss64.com/nt/) - Scripting language used to automate the process

## Contributing 🖇️

Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## Authors ✒️

* **Ander González** - *Software Engineer* - [AnderCMD](https://github.com/AnderCMD)

See also the list of [contributors](https://github.com/AnderCMD/Fix-Windows/contributors) who participated in this project.

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
⌨️ with ❤️ by [AnderCMD](https://github.com/AnderCMD) 😊
