FROM ubuntu:latest
COPY . /app
WORKDIR /app
RUN apt-get update && apt-get install -y \
    zsh \
    curl \
    git \
    nano \
    && apt-get clean

RUN chmod +x install.sh

# Set zsh as the default shell
SHELL ["/bin/zsh", "-c"]