#!/usr/bin/env bash

START_DIR=$(pwd)

source _update/node_packages.sh && cd "$START_DIR"
source _update/phpactor.sh && cd "$START_DIR"
source _update/sonarlint.sh && cd "$START_DIR"
source _update/lazygit.sh && cd "$START_DIR"
