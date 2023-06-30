#!/bin/bash

# Clear the terminal screen
clear

# Set up the trap to catch the SIGINT signal
trap 'kill $PID; exit 1' INT

# Notify the user that the virtual environment is being created
echo "Creating virtual environment. Please wait..."

# Create a Python virtual environment with Python 3.7 in the background
/c/python38/python.exe -m venv dashboard_venv &
PID=$!

# Wait for the virtual environment to be created
wait $PID

# Add the hidden attribute to the dashboard_venv directory
if [[ "$OSTYPE" == "darwin"* ]]; then
    SetFile -a V dashboard_venv
else
    attrib +h dashboard_venv
fi

# Wait for the user to press any key before continuing
read -p "Virtual environment created. Press Enter to activate and install dependencies..."

# Activate the Python virtual environment
source dashboard_venv/Scripts/activate

# Upgrade pip
/c/python38/python.exe -m pip install --upgrade pip

# Install wheel
pip install wheel

# Install the Python package dependencies specified in requirements.txt
pip install -r requirements.txt

# Ask user if they want to run main.py
read -p "Do you want to run main.py? (yes/no) " run_main

# Execute the main.py Python script if the user answered "yes"
if [[ "$run_main" == "yes" ]]; then
    /c/python38/python.exe ../src/main.py
fi

# Pause the script and wait for the user to press Enter
read -p "Hit Enter to close..."
