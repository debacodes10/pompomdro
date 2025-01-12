#!/bin/bash

# Define colors for output
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}This script must be run as root. Use sudo.${RESET}"
    exit 1
fi

# Copy lib folder to /usr/local/lib/pomodoro
LIB_DIR="/usr/local/lib/pomodoro"
echo -e "${GREEN}Copying lib directory to $LIB_DIR...${RESET}"
mkdir -p $LIB_DIR
cp -r ../lib/* $LIB_DIR

# Copy the main script to /usr/local/bin
BIN_DIR="/usr/local/bin"
echo -e "${GREEN}Copying pomodoro script to $BIN_DIR...${RESET}"
cp ../bin/pomodoro.sh $BIN_DIR/pomodoro
chmod +x $BIN_DIR/pomodoro

# Update and install dependencies
echo -e "${GREEN}Checking and installing dependencies...${RESET}"
DEPS=("bash" "notify-send")

for DEP in "${DEPS[@]}"; do
    if ! command -v $DEP &>/dev/null; then
        echo -e "${GREEN}Installing $DEP...${RESET}"
        if [[ -x "$(command -v apt-get)" ]]; then
            apt-get install -y $DEP
        elif [[ -x "$(command -v yum)" ]]; then
            yum install -y $DEP
        else
            echo -e "${RED}Error: Package manager not found. Install $DEP manually.${RESET}"
            exit 1
        fi
    else
        echo -e "${GREEN}$DEP is already installed.${RESET}"
    fi
done

# Create necessary directories
TMP_DIR="/tmp/pom"
if [[ ! -d $TMP_DIR ]]; then
    echo -e "${GREEN}Creating temporary directory for Pomodoro...${RESET}"
    mkdir -p $TMP_DIR
    sudo chmod 1777 $TMP_DIR
    
else
    echo -e "${GREEN}Temporary directory already exists.${RESET}"
    sudo chmod 1777 $TMP_DIR
fi

# Set execute permission for the main script
SCRIPT="../bin/pomodoro.sh"
if [[ -f $SCRIPT ]]; then
    echo -e "${GREEN}Setting execute permission for $SCRIPT...${RESET}"
    chmod +x $SCRIPT
else
    echo -e "${RED}Error: $SCRIPT not found. Make sure it's in the current directory.${RESET}"
    exit 1
fi

# Optionally add the script to the user's PATH
BIN_DIR="/usr/local/bin"
echo -e "${GREEN}Copying $SCRIPT to $BIN_DIR for global access...${RESET}"
cp $SCRIPT $BIN_DIR/pomodoro

# Finished
echo -e "${GREEN}Installation complete! Run 'pomodoro' to start the timer.${RESET}"
