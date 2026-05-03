# Cabra's Dev Container

This is a setup guide for my dev container image, which works best with apx (Vanilla OS) or distrobox, to simplify development on immutable systems.
Because it's my dev setup, it's highly opinionated.

## Installation

### Step 1 (Optional): Prepare host for real docker

Sometimes we need real docker -- not just podman. In that case my container provides the `rdocker` alias, which requires manual user auth, but is fully docker compatible. In any other case, the installed docker cli will just use the host's podman socket (mostly sufficient).

So, open a terminal and execute:

```bash
abroot pkg add docker.io
abroot pkg apply
host-shell pkexec groupadd docker
reboot
```

### Step 2 (Optional, but recommended): Prepare host for docker via podman

This step only needs to be done once and afterwards enables full docker and docker compose cli support in the dev container, however using the host's rootless podman socket. This ensures simplicity and enforced security on immutable distros.
Even though it will work most of the times, when `network=host` or other complex features are required, only real docker (`rdocker`, as set up in Step 1) can be the solution.

So, again open your vso shell and run:

```bash
host-shell systemctl --user enable --now podman.socket
```

### Step 3 (Required): Actual installation

Run this in your shell to set up your new dev container on VanillaOS:

```bash
apx stacks new
# name: cabras-dev-container
# base: ghcr.io/cabraviva/cabras-dev-container:main
# package manage: apt (2)
# You have not provided any packages to install in the stack. Do you want to add some now?: No (n)

mkdir $HOME/dev-home
apx subsystems new -H $HOME/dev-home
# name: dev
# stack: cabras-dev-container (2)

apx dev enter # Runs first time use setup
```

## Usage

Just type:

```bash
apx dev enter
```

and you are good to go.
If you want, you can use apx to export VS Code and GitHub Desktop.
