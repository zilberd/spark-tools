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
sudo apt install nvitop
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
```

This is in addition to the tool-specific wrapper script described in `tools/ddgpy/README.md`.

## Additional notes

- `~/.bashrc` contains environment initialization for local binaries and `sparkrun` tab completion.
- `~/.zshrc` also loads the same local environment file.
- The command history includes `uvx` and `sparkrun` usage, indicating the machine is configured for local AI runtime workflows.
- Any secrets or tokens (for example `HF_TOKEN`) should be managed securely and are not reproduced here.
