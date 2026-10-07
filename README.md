# These are my dotfiles.  There may be many like them, but these are mine. 

## Running

```
git clone https://github.com/jonathanpike/dotfiles ~/.dotfiles
cd ~/.dotfiles;
. setup.sh;
```

Setup installs Homebrew and everything in the `Brewfile`, sets Homebrew's bash as the login shell, and symlinks the dotfiles into `~`. It works on both Apple Silicon and Intel Macs.

Setup _should_ be idempotent, but I don't guarantee anything! 

## What's included

- `.bash_profile`, `.bashrc`, `.bash/` -- bash config: aliases, prompt, history, and Homebrew `PATH` setup
- `.inputrc` -- readline settings: case-insensitive completion and prefix history search on the arrow keys
- `.gitconfig` -- shared git config, using `delta` as the pager
- `.config/git/ignore` -- global git ignore
- `.ssh/config` -- shared SSH settings that store keys in the macOS Keychain
- `.config/ghostty/config` -- Ghostty terminal config
- `Brewfile` -- packages installed with `brew bundle`

## Machine-specific config

These files are not tracked and stay on each machine:

- `~/.gitconfig.local` -- git e-mail and other per-machine git settings (setup creates it)
- `~/.ssh/config.local` -- per-host SSH keys (setup moves an existing `~/.ssh/config` here)
- `~/.secrets` -- environment variables that shouldn't be committed

## Credits
- Setup Script and Function Library -- [Adam Eivy](https://github.com/atomantic/dotfiles)
