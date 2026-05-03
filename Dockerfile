FROM debian:stable

RUN apt update
RUN apt upgrade -y

# Basic packages
RUN apt install -y git fastfetch curl wget vim nano bat gnupg2 zip unzip build-essential gnupg ca-certificates

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
RUN rustc --version && cargo --version

### Dev Tools & IDE
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

### Comfortability tools (Shell prompt, zoxide, etc...)
RUN apt install -y starship zoxide
# Extend .bashrc (or similar)
RUN echo 'eval "$(starship init bash)"' >> /etc/bash.bashrc
RUN echo 'eval "$(zoxide init bash)"' >> /etc/bash.bashrc