# Computer Setup Guide

This document records the machine-level setup actions that were performed outside the `tools/ddgpy` install itself.

> The tool-specific install details are already covered in `tools/ddgpy/README.md`.

## What this file covers

- passwordless sudo configuration for user `gx10`
- shell environment setup and startup configuration
- package installations observed in history
- additional runtime installers and tool commands used during setup

## Reproduce the system setup

### 1. Enable passwordless sudo for `gx10`

The user added a sudoers file so `gx10` can run all commands without a password prompt.

```bash
sudo sh -c "echo 'gx10  ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/gx10"
sudo sh -c "echo 'pgx  ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/pgx"

sudo useradd -m -s /bin/bash sparkrun
sudo passwd sparkrun  # Set the password interactively
sudo usermod -aG sudo sparkrun
sudo sh -c "echo 'sparkrun  ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/sparkrun"
```

This is a machine-level configuration that does not appear in the tool README.

### 2. Set or change the root password

The shell history shows `sudo passwd` was run. If you want to reproduce that step, run:

```bash
sudo passwd
```

### 3. Install the UV/UVX environment

The following command installs the `uv` runtime and environment manager used by your local tools:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Then ensure the environment loader is sourced in your shell startup.

### 4. Configure shell startup for local binaries

The device sources `~/.local/bin/env` from both `~/.bashrc` and `~/.zshrc`.

Add to `~/.bashrc`:

```bash
. "$HOME/.local/bin/env"
```

Add to `~/.zshrc`:

```bash
. "$HOME/.local/bin/env"
```

The `~/.local/bin/env` loader should contain:

```sh
#!/bin/sh
# add binaries to PATH if they aren't added yet
# affix colons on either side of $PATH to simplify matching
case ":${PATH}:" in
    *:"$HOME/.local/bin":*)
        ;;
    *)
        export PATH="$HOME/.local/bin:$PATH"
        ;;
esac
```

### 5. Install system packages used on the device

The following packages were installed via `apt`:

```bash
sudo apt install nvtop
```

The first attempt included a typo (`nvitop`) and the second command installed the correct package `nvtop`.

### 6. Install DGXTop helper script

A system helper script was installed from GitHub using:

```bash
curl -fsSL https://raw.githubusercontent.com/DennySORA/dgxtop/main/install.sh | bash
```

### 7. Install and use Sparkrun and model runtimes

The shell history shows setup commands for `sparkrun`, not a standard package-manager installation command.

Reproduce the Sparkrun install/setup from history with:

```bash
uvx sparkrun setup
sparkrun setup wizard
sparkrun setup ssh
```

Then use the runtime commands shown in history for model execution:

```bash
sparkrun run @official/qwen3-coder-next-int4-autoround-vllm
sparkrun run qwen3-coder-next-fp8-sglang --solo --tp 1
```

### 8. Add the shell alias for the `ddg` tool

The user also added a convenience alias in `~/.bashrc`:

```bash
alias ddg="cd /home/gx10/tools/ddgpy && uv run ddg_search.py"
alias ddg="cd /home/pgx/tools/ddgpy && uv run ddg_search.py"
```

This is in addition to the tool-specific wrapper script described in `tools/ddgpy/README.md`.

### 9. Configure Git for GitHub

The user configured Git with a global identity for commits and GitHub access:

```bash
git config --global user.name "zilberd"
git config --global user.email "zilberd@gmail.com"
```

Replace `your-email@example.com` with your actual GitHub account email address.

### 10. Generate an ED25519 SSH key

For the local host identity `pgx@pgx-1b13`:

```bash
ssh-keygen -t ed25519 -C "pgx@pgx-1b13" -f ~/.ssh/id_ed25519
sudo su gx10
ssh-keygen -t ed25519 -C "gx10@pgx-1b13" -f ~/.ssh/id_ed25519
sudo su sparkrun
ssh-keygen -t ed25519 -C "sparkrun@pgx-1b13" -f ~/.ssh/id_ed25519


ssh-keygen -t ed25519 -C "gx10@gx10-7fec" -f ~/.ssh/id_ed25519
sudo su pgx
ssh-keygen -t ed25519 -C "pgx@gx10-7fec" -f ~/.ssh/id_ed25519
sudo su sparkrun
ssh-keygen -t ed25519 -C "sparkrun@gx10-7fec" -f ~/.ssh/id_ed25519
```

### 11. Add local host name mappings

Add the following lines to `/etc/hosts` on Linux, or to `C:\Windows\System32\drivers\etc\hosts` on Windows:

```text
192.168.178.11 gx10-7fec gx10-7fec.local gx10 gx10.local
192.168.178.13 pgx-1b13 pgx pgx-1b13.local pgx.local
```

### 12. Prepare ssh

create the file `nano ~/.ssh/config`

copy the keys to the other server 
````bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub gx10@192.168.178.13
ssh-copy-id -i ~/.ssh/id_ed25519.pub gx10@192.168.178.11

ssh-copy-id -i ~/.ssh/id_ed25519.pub pgx@192.168.178.13
ssh-copy-id -i ~/.ssh/id_ed25519.pub pgx@192.168.178.11

ssh-copy-id -i ~/.ssh/id_ed25519.pub sparkrun@192.168.178.13
ssh-copy-id -i ~/.ssh/id_ed25519.pub sparkrun@192.168.178.11

````

### 13 cluster
`sparkrun cluster create 2nodes --hosts 192.168.178.11,192.168.178.13 --default`

On Linux, you can use the helper script included in this setup folder:

```bash
chmod +x /home/pgx/spark-tools/setup/update-hosts.sh
sudo /home/pgx/spark-tools/setup/update-hosts.sh
```

This script backs up the existing `/etc/hosts` file before replacing any existing `gx10*` or `pgx*` entries.

### 14 windows

````powershell
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
# Start the SSH server
Start-Service sshd

# Set it to start automatically at boot
Set-Service -Name sshd -StartupType 'Automatic'

#firewall
Get-NetFirewallRule -Name *ssh*
New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

#default as powershell
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

#default as wsl
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\wsl.exe" -PropertyType String -Force

# Example: Defaulting to Ubuntu
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\wsl.exe -d Ubuntu" -PropertyType String -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\wsl.exe --distribution-id {e420c704-7315-4cf4-9d5c-72a5508c5f3a}" -PropertyType String -Force

````


## Additional notes

- `~/.bashrc` contains environment initialization for local binaries and `sparkrun` tab completion.
- `~/.zshrc` also loads the same local environment file.
- The command history includes `uvx` and `sparkrun` usage, indicating the machine is configured for local AI runtime workflows.
- Any secrets or tokens (for example `HF_TOKEN`) should be managed securely and are not reproduced here.
