# KERN

A terminal-first Linux distribution based on arch Linux.

> **Status: early development.** KERN is a minimalistic distro concept focusing on pure TTY environments,
> declarative configuration, and command-line management. Expect the API and tooling to evolve
> rapidly as the project matures.

> Want to know the philosophy behind it? See the [Goals](#goals) and [Philosophy](#philosophy) sections.

> Small note from me: This project is entirely hand-crafted — no AI-generated code, just pure
> shell scripts and Lua configuration.

---

## Big update:

Finally, after so much commits, KERN now has a working `kctl` CLI
tool for native command-line management, and the `config/source.py` declarative config system is
functional. So basically, it is kind of, barely *usable*(Not really). A pure TTY environment is
running, it is not even a distro, it is currently only the `kctl` CLI

## Goals

- **Pure TTY environment.** No fancy graphical session setup — just you and the terminal.
- **Declarative system configuration via decman.** All configuration described declaratively,
  version-controlled, and automatically applied.
- **Native command-line management through kctl.** Every aspect of the system is manageable
  from the command line without leaving the TTY.
- **VECTc configuration language.** A future phase where configuration is written in a
  config-file version of VECTx (short for VECTconfig), making it more edit-friendly.

## Philosophy

KERN is built around the idea that a Linux distribution should get out of your way. Instead
of hiding the system behind graphical installers and configurators, KERN puts the power back
in your hands — but in a polished, automated way.

- **Transparency.** Every setting is a file you can read and edit.
- **Automation.** Repetitive tasks are handled by scripts, not manual configuration.
- **Modularity.** Components like the window manager, desktop environment, and services
  are interchangeable via configuration.
- **TTY-first.** The console is the primary interface; X11/Wayland are optional addons.

## Current Features

- **Pure TTY boot.** KERN can boot directly into a clean TTY without a display manager.
- **`kctl` CLI tool.** A native command-line tool for system management (see [kctl](#kctl)).
- **Declarative config via `config/source.py`.** All system configuration is described in a
  single declarative source file.
- **`decman` integration.** Dependency and package management via decman for reproducible
  setups.
- **VECTc config language support** (planned phase — see [Roadmap](#roadmap)).
- **Shell-based installation.** Package management via decman for setup.

## kctl reference

KERN comes with `kctl`, a terminal-based CLI for managing the system. The actual commands
are defined in `src/kctl.lua`. Currently supported commands:

| Command       | Action                                                     |
| ------------- | ---------------------------------------------------------- |
| `kctl help`   | Show this help message                                     |
| `kctl status` | Show current system status (kernel, architecture, components) |
| `kctl source` | Show/source the configuration file (`config/source.py`)    |
| `kctl forge`  | Apply configuration changes from `config/source.py`         |

### `kctl status`

Shows system status information:

- Kernel type and architecture
- Whether Lua and decman are installed
- Configuration file status (found/missing)

```sh
kctl status
```

### `kctl help`

Shows available commands and their options:

```sh
kctl help
```

### `kctl source`

Shows the configuration file status and options:

- Without options: shows if source file exists
- `--check`: Checks the source file for errors using `decman --dry-run`
- `--debug`: Checks the source file with debug output
- `--edit`: Opens the configuration file in your editor (`$EDITOR` or `$VISUAL`, default: `vim`)

```sh
kctl source
kctl source --check
kctl source --debug
kctl source --edit
```

### `kctl forge`

Applies configuration changes from `config/source.py`:

- Without options: shows help
- `--dry-run`: Preview changes without applying (runs `decman --dry-run`)
- `--apply`: Apply the new configuration changes
- `--help`: Show `kctl forge` help

```sh
kctl forge
kctl forge --dry-run
kctl forge --apply
```

Keybindings are not hardcoded in the kctl tool itself — since KERN operates in a pure TTY
environment, session switching and terminal launch would be handled by your system's
standard TTY keybindings or display manager configuration.

## Known Limitations

Deliberately minimal for a first cut, but worth knowing:

- **`kctl` is still prototype.** Commands are functional but the UI is minimal — just CLI input.
- **`decman` integration is basic.** It handles declared packages but not full dependency
  resolution yet.
- **No VECTc language features yet.** The prototype exists but the full language implementation
  is a future phase.

## Requirements

- A Linux system ( Arch-based or compatible).
- Python 3 (for `config/source.py` parsing — though the file currently uses `import decman`).
- `decman` installed for declarative configuration.
- `kctl` — included with the distribution (Lua script at `src/kctl.lua`).
- Optional: X11 or Wayland server if you want graphical sessions.

The runtime dependencies are minimal: Lua, `decman`, and the shell environment.

## Building / Installing

`kctl` is not installed via `cargo build` or `makepkg` in the traditional sense — it's a
distribution concept. However, if you want to run the `kctl` tool and `config/source.py`
system on an existing system:

With a standard Linux setup:

```sh
# Clone the repo
git clone https://github.com/germanex3000dev/kern.git
cd kern

# Run the config parser (Lua)
lua src/kctl.lua source

# Check config for errors
lua src/kctl.lua source --check

# Apply configuration changes
lua src/kctl.lua forge --apply
```

## Running

KERN is meant to be run as a full distribution, but you can experiment with the tools:

```sh
# From the kern directory
cd kern
lua src/kctl.lua status
lua src/kctl.lua help
lua src/kctl.lua source
lua src/kctl.lua forge --dry-run
```

To try the pure TTY experience, you can boot a minimal Arch ISO and configure KERN-style
settings, or run the tools on an existing system to see how the declarative system works.

**!IMPORTANT!**

Don't expect a polished graphical installer yet. KERN is early development — the tools work,
but the full distribution experience is not ready. I wouldn't recommend using this as your
daily driver distribution yet. I mean, it's not even an installable distro. We're not even at an unstable release; we're still sketching
out the foundations.

## Architecture

KERN follows a layered architecture philosophy:

1. **Base system.** Linux kernel + essential utilities (managed by `decman`).
2. **Configuration layer.** `config/source.py` describes all system state declaratively.
3. **Application layer.** `kctl` and shell scripts interact with the system.
4. **User layer.** The TTY user interacting via keybindings and `kctl` commands.

This is a sketch of where KERN is heading — most of the automation below doesn't exist
in fully polished form yet. The source files in `src/` and `config/` are the editable
origin for all of it.

## Roadmap

Completely not in order — this is a wish list, not a commitment:

- [ ] Full `kctl` UI with menu system (probably not)
- [ ] VECTc configuration language implementation
- [ ] Decman full dependency resolution
- [ ] Module system for interchangeable components ( services)

## Contributing

This is a personal project and contributions are not being solicited right now.
Patches, ideas and bug reports are still welcome once the codebase stabilises
a little — see the [issue tracker](https://github.com/germanex3000dev/kern/issues).

## License

Released under the [MIT License](LICENSE). Copyright (c) 2026 Germanex3000.
