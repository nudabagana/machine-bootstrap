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

## WSL
wsl is installed by the script, however you'll need to install distro that you want to use to start it. It can be done with `wsl.exe --install Ubuntu`.
**To setup Ubuntu env inside wsl, refer to [ubuntu](../ubuntu/README.md) bootstrap folder.**

## Windows Defender
To disable windows defender:
gpedit.msc → Computer Configuration → Administrative Templates → Windows Components → Microsoft Defender Antivirus → Turn off Microsoft Defender Antivirus → Enabled

## Get regular right-click menu in File Explorer
1. Press Win + R
2. Type: regedit
3. Go to: `HKEY_CURRENT_USER\Software\Classes\CLSID`
4. Right click → New → Key. Name it exactly: `{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}`
5. Inside that key → Right click → New → Key. Name it: `InprocServer32`
6. Click InprocServer32
7. Double click (Default) on the right
8. Leave value data empty and press OK
9. Restart Explorer - Ctrl + Shift + Esc -> Find “Windows Explorer” -> Restart