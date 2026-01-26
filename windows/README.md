# Windows bootstrap

1. Install Git (provides Git Bash). Example:
```powershell
winget install --id Git.Git
```
2. Clone this repo 
```bash
git clone git@github.com:nudabagana/machine-bootstrap.git
```
3. Open Git Bash and go into the Windows folder
```bash
cd machine-bootstrap/windows
```
4. Run setup script
```bash
./setup.sh
```

## winget_shims
If an installed app does not add its command to PATH, `winget_shims` provides `.cmd` shims to make those commands available. After adding the shim directory to PATH, fully close and reopen all terminals (including VS Code) to refresh environment variables.
