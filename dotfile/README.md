# dotfile

Bootstrap a fresh Ubuntu 24.04 machine with the same `zsh` and `tmux` setup as this server, plus a practical `vim` setup for Python coding and light editing, without copying local secrets.

## Files

- `bootstrap-ubuntu-24.04.sh`: installs packages, Oh My Zsh, plugins, configs, tmux helper scripts, and sets `zsh` as the default shell.
- `zsh/.zshrc`: main shell config.
- `zsh/.zshrc.local.example`: local override file for secrets and machine-specific settings.
- `tmux/.tmux.conf`: tmux config.
- `tmux/scripts/*.sh`: status bar helper scripts.
- `vim/.vimrc`: Python-friendly Vim config with persistent undo and coding defaults.

## Usage

```bash
cd ~/0lab/dotfile
chmod +x bootstrap-ubuntu-24.04.sh
./bootstrap-ubuntu-24.04.sh
```

The installer creates timestamped backups for existing `~/.zshrc`, `~/.tmux.conf`, and tmux helper scripts before replacing them.
