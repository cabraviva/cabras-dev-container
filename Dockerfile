FROM debian:stable

RUN apt update
RUN apt upgrade -y

# Basic packages
RUN apt install -y git fastfetch curl wget vim nano bat gnupg2

### Programming languages
# Python
RUN apt install -y python3 python3-pip
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# JavaScript
RUN curl -fsSL https://bun.sh/install | bash
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash