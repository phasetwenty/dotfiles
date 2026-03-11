# Dotfiles Project

This is a shell dotfiles project for bash. The files are tracked via a **bare git repository** at `~/.dotfiles-repo`, accessed through the `dotfiles` alias (defined in `~/.bash/applications/dotfiles`).

## Goal

Transform these dotfiles into a conventional bash setup:

- **`.bashrc` and `.bash_profile` should be distinct** and serve their proper roles: `.bash_profile` for login shells (env vars, PATH), `.bashrc` for interactive shells (aliases, prompt, completions).
- **Eliminate the `~/.bash/init` indirection** — the two entry point files should contain their configuration directly, or source a small number of clearly-scoped files, rather than delegating everything to a third file.
- The `~/.bash/` framework and its modules will be retained, reorganized, or collapsed as needed to support the above — the goal is conventional structure, which will also produce fewer files.

## Files In Scope

- `~/.bash_profile` and `~/.bashrc` — both delegate to `~/.bash/init`
- `~/.bash/` — the custom bash initialization framework
- `~/.gitconfig` — git user config, aliases, and settings
- `~/.gitrc/` — git support files (`gitignore_global`, `git-completion`)

## Architecture: 

`~/.bash/` Framework

### Entry points

Both `~/.bash_profile` and `~/.bashrc` source `~/.bash/init`. They are identical.

### `~/.bash/init` — Main orchestrator

Sourced first. Controls load order:

1. Always sourced (login and non-interactive shells):
   - `~/.bash/path`
   - `~/.bash/variables`
2. Interactive shells only:
   - `~/.bash/aliases`
   - `~/.bash/prompt`
   - All files in `~/.bash/applications/*` (globbed in alphabetical order)

### Module files

| File | Purpose |
|------|---------|
| `~/.bash/path` | Rebuilds `$PATH` from an ordered array; only includes directories that exist |
| `~/.bash/variables` | Exports env vars: `EDITOR`, `WORKSPACE`, `REPOS`, `LS_CMD`, `JAVA_HOME`, AWS keys, `DOTFILES_REMOTE`, `BASH_SILENCE_DEPRECATION_WARNING` |
| `~/.bash/aliases` | Defines `ll`, `la`, `lhl`, `s` (sudo) aliases; `ls_with_arg` helper pipes `$LS_CMD` output through `less` |
| `~/.bash/prompt` | Sets `PS1` via `PROMPT_COMMAND=update_prompt`; displays hostname (red), git branch (green), truncated PWD (yellow, max 40 chars) |

### `~/.bash/applications/` — Per-application init scripts

Each file is sourced for interactive shells. Add new application integrations here.

| File | Purpose |
|------|---------|
| `dotfiles` | Defines the `dotfiles` alias for managing the bare repo |
| `git` | Sources `~/.gitrc/git-completion`; defines `cleano` alias and `topic-base` branch helper |
| `grep` | Sets `GREP_OPTIONS` for always-on color |
| `iterm2_shell_integration.bash` | Full iTerm2 shell integration (preexec/precmd hooks, OSC sequences); overrides `PROMPT_COMMAND` |
| `less` | Sets `LESS=-FXR` (quit-if-one-screen, no-clear, raw-control-chars) |
| `ssh` | Adds hostname tab-completion for `ssh` from config/known_hosts files |

## Dotfiles Repo Management

The dotfiles are tracked in a **bare git repo** at `~/.dotfiles-repo` with `$HOME` as the work tree. Use the `dotfiles` alias in place of `git`:

```bash
dotfiles status
dotfiles add ~/.bash/aliases
dotfiles commit -m "update aliases"
dotfiles push
```

Untracked files in `$HOME` are hidden from `dotfiles status` by default (`status.showUntrackedFiles no`).

The remote is stored in `$DOTFILES_REMOTE` (currently `https://github.com/phasetwenty/dotfiles.git`).

## Git Configuration

- `~/.gitconfig` — main config; pull rebases by default, merge uses `diff3` conflict style
- `~/.gitrc/gitignore_global` — global gitignore (referenced by `core.excludesfile`)
- `~/.gitrc/git-completion` — bash completion for git commands (sourced by `~/.bash/applications/git`)

## Key Dependencies

These tools are expected to exist; missing ones produce stderr warnings at shell startup:

- `gls` (GNU coreutils `ls`) — for `LS_CMD` with `--group-directories-first`
- `jq` — for reading `~/.aws_access_keys`
- Java JDK at a specific path (currently jdk1.8.0_45) — for `JAVA_HOME`

## Conventions

- **Load order matters**: `path` before `variables` (variables may reference paths); both before `aliases` and `prompt`.
- **Guard pattern**: Application scripts check for their binary with `type -P` or `[ -x ... ]` and `return` early if not available, rather than erroring out.
- **No `cd` in init files**: All path construction uses absolute paths.
- **`applications/` is for third-party tool integrations** only; shell-native configuration belongs in the named module files.
