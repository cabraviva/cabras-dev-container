FROM debian:stable

RUN apt update
RUN apt upgrade -y

# Basic packages
RUN apt install -y git fastfetch curl wget vim nano bat gnupg2 zip unzip build-essential gnupg ca-certificates apt-transport-https net-tools dnsutils

### Programming languages
# Python
RUN apt install -y python3 python3-pip
RUN curl -LsSf https://astral.sh/uv/install.sh | UV_INSTALL_DIR=/usr/local/bin sh

# JavaScript
RUN curl -fsSL https://bun.sh/install | BUN_INSTALL=/usr/local bash
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

# Rust (via rustup.rs)
ENV RUSTUP_HOME=/usr/local/rustup
ENV CARGO_HOME=/usr/local/cargo
ENV PATH=/usr/local/cargo/bin:$PATH
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
RUN echo 'source "/usr/local/cargo/env"' >> /etc/bash.bashrc
RUN rustc --version && cargo --version

### Dev Tools & IDE
# VS Code
RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/packages.microsoft.gpg
RUN sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
RUN apt update
RUN apt install -y code

# GH CLI
RUN mkdir -p /etc/apt/keyrings \
    && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# GitHub Desktop (via shiftkey / mwt)
RUN wget -qO - https://mirror.mwt.me/shiftkey-desktop/gpgkey | gpg --dearmor | tee /usr/share/keyrings/mwt-desktop.gpg > /dev/null
RUN sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/mwt-desktop.gpg] https://mirror.mwt.me/shiftkey-desktop/deb/ any main" > /etc/apt/sources.list.d/mwt-desktop.list'
RUN apt update && apt install -y github-desktop

### Containers (Docker / Podman)
# Alias for real docker => 'rdocker'
RUN echo 'alias "rdocker=host-spawn pkexec docker"' >> /etc/bash.bashrc
# Alias for host podman
RUN echo 'alias "podman=host-spawn podman"' >> /etc/bash.bashrc
# Install docker + docker compose cli in container via get.docker.com script. Then make it use podman socket from host
RUN curl -fsSL https://get.docker.com | sh
ENV DOCKER_HOST=unix:///run/user/1000/podman/podman.sock
RUN echo 'export DOCKER_HOST=unix:///run/user/1000/podman/podman.sock' >> /etc/bash.bashrc

### Comfortability tools (Shell prompt, zoxide, etc...)
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y
RUN cargo install zoxide --locked
# Extend .bashrc (or similar)
RUN echo 'eval "$(starship init bash)"' >> /etc/bash.bashrc
RUN echo 'eval "$(zoxide init bash)"' >> /etc/bash.bashrc
# Adapt bashrc to support nvm
RUN echo 'export NVM_DIR="$HOME/.nvm"' >> /etc/bash.bashrc
RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /etc/bash.bashrc
RUN echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /etc/bash.bashrc

### Aliases
RUN echo 'alias "ll=ls -la"' >> /etc/bash.bashrc
RUN echo 'alias "c=clear"' >> /etc/bash.bashrc