FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV USERNAME=cristian
ENV HOME=/home/cristian
ENV DOTFILES_DIR=/home/cristian/dotfiles

# Pre-configure tzdata so it never prompts
RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo UTC > /etc/timezone

# Minimal prerequisites that install.sh would normally pull in via apt
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    curl \
    wget \
    git \
    ca-certificates \
    bash \
    tzdata \
  && rm -rf /var/lib/apt/lists/*

# Create non-root user with passwordless sudo (mirrors typical Ubuntu desktop setup)
RUN useradd -m -s /bin/bash "$USERNAME" \
  && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER cristian
WORKDIR /home/cristian/dotfiles

# dotfiles repo is mounted at runtime — nothing to COPY
CMD ["bash"]
