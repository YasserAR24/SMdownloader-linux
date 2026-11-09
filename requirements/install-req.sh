#!/bin/bash

echo "Welcome."
echo

sudo apt update
sudo apt install -y python3 python3-venv

python3 --version

# Check if the virtual environment exists
cd ..
if [ -d ".SMdownloadervenv" ]; then
    echo "venv exists."
else
    echo "Creating the venv..."

    python3 -m venv .SMdownloadervenv

    if [ $? -ne 0 ]; then
        echo "Failed to create the virtual environment."
        exit 1
    fi

    echo "----Done----"
fi

echo

# Activate the virtual environment
source .SMdownloadervenv/bin/activate

echo "Installing packages..."

python -m pip install --upgrade pip

python -m pip install flask yt-dlp

if [ $? -ne 0 ]; then
    echo "Package installation failed. Check your internet connection."
    exit 1
fi

echo "----Done----"
echo "Press Enter to exit"
read
