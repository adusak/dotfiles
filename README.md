# dotfiles

Personal [Nix](https://nixos.org/) configuration managing macOS
([nix-darwin](https://github.com/LnL7/nix-darwin)) and Windows/WSL
([NixOS-WSL](https://github.com/nix-community/NixOS-WSL)) machines, with
user-level dotfiles handled by
[home-manager](https://github.com/nix-community/home-manager). Everything is a
single flake, so the same module set produces a consistent shell, editor, and
tooling setup across every host.

## Hosts

The flake defines one configuration per machine:

| Host       | Platform               | User          | Build target                                       |
| ---------- | ---------------------- | ------------- | -------------------------------------------------- |
| `workmac`  | macOS (aarch64-darwin) | `Adam.Melkus` | `darwinConfigurations.workmac`                     |
| `homemac`  | macOS (aarch64-darwin) | `adik`        | `darwinConfigurations.homemac`                     |
| `worklaptop` | NixOS-WSL (x86_64)   | `adik`        | `nixosConfigurations.worklaptop`                   |

Pick the entry that matches the machine you are setting up — its name is the
`#host` flake selector used in every command below.

## What's in here

- `flake.nix` — entry point: inputs, host definitions, and the shared
  system/home module wiring.
- `darwin.nix`, `nixos-wsl.nix` — platform-specific system configuration.
- `modules/` — home-manager modules (shell, git, editor, terminal, theming,
  etc.). Darwin-only modules such as `aerospace` are gated behind `isDarwin`.
- `.github/workflows/` — CI that evaluates every host config and checks
  `nixfmt` formatting.

## First-time setup

> The flake is expected to live at `~/.config/nix-darwin` on **all** platforms
> (macOS and WSL alike) — the built-in `nixreload` helper resolves that path.
> If you clone it elsewhere, pass the full path to `--flake` yourself.

### 1. Install Nix (with flakes)

If Nix is not already installed, use the Determinate Systems installer (the same
one CI uses), which enables flakes out of the box:

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Open a new shell afterwards so `nix` is on your `PATH`.

### 2. Clone this repo

```sh
git clone https://github.com/adusak/dotfiles.git ~/.config/nix-darwin
cd ~/.config/nix-darwin
```

### 3. Bootstrap the configuration

On the very first run the `darwin-rebuild` / `nixos-rebuild` commands don't exist
yet, so invoke them straight from the flake.

**macOS** (replace `workmac` with your host):

```sh
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake ~/.config/nix-darwin#workmac
```

This installs nix-darwin, Homebrew (via `nix-homebrew`), and the full
home-manager environment. Expect the first build to take a while.

**NixOS-WSL** (`worklaptop`): start from a clean
[NixOS-WSL](https://github.com/nix-community/NixOS-WSL#installation) instance,
then:

```sh
sudo nixos-rebuild switch --flake ~/.config/nix-darwin#worklaptop
```

### 4. Start a new shell

The default shell becomes [fish](https://fishshell.com/). Open a new terminal to
pick up the configured shell, theme, and helpers.

## Everyday usage

After the first bootstrap, use the `nixreload` fish function to apply changes.
It defaults to the current host and rebuilds from `~/.config/nix-darwin`:

```fish
nixreload          # rebuild this machine's configuration
nixreload homemac  # rebuild a specific host (tab-completes known hostnames)
```

Under the hood `nixreload` runs the platform-appropriate command:

```sh
# macOS
sudo darwin-rebuild switch --flake ~/.config/nix-darwin#<host>
# NixOS-WSL
sudo nixos-rebuild  switch --flake ~/.config/nix-darwin#<host>
```

A typical change loop:

1. Edit `flake.nix` or a file under `modules/`.
2. Run `nixreload` (optionally with a host name).
3. Commit and push once you're happy.

### Updating dependencies

Bump the pinned inputs (nixpkgs, home-manager, …) and rebuild:

```sh
nix flake update      # update flake.lock
nixreload             # apply the new versions
```

Dependabot also opens PRs to keep the GitHub Actions and flake inputs current.

### Local, machine-specific overrides

Drop fish snippets that shouldn't be committed into `~/.localrc.fish` — it's
sourced automatically on shell start.

## Validating changes

CI runs these on every PR; run them locally before pushing:

```sh
nix flake check                         # evaluate all configs
nix build --dry-run .#darwinConfigurations.workmac.system   # eval a single host
nixfmt <file>.nix                       # format Nix files (CI checks --check)
```

## Adding a new host

1. Add a `mkDarwinConfig` / `mkNixosWslConfig` entry in `flake.nix` with the new
   `hostname` and `username`.
2. Add the hostname to `allHostnames` so `nixreload` can tab-complete it.
3. Bootstrap it using the first-time setup steps above.
