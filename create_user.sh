#!/bin/bash

# Function to create a new user
create_user() {
    read -p "Enter the new username: " username
    read -s -p "Enter the password for $username: " password
    echo
    
    # Create the user with the provided password
    sudo useradd -m -s /bin/bash "$username"
    echo "$username:$password" | sudo chpasswd
    echo "User $username has been created."

    # Ask if the user should have sudo privileges
    read -p "Should $username have sudo privileges? (y/n): " sudo_response
    if [[ "$sudo_response" == "y" || "$sudo_response" == "Y" ]]; then
        sudo usermod -aG sudo "$username"
        echo "User $username has been added to the sudo group."
    else
        echo "User $username does not have sudo privileges."
    fi
}

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Use sudo ./script_name.sh"
    exit 1
fi

# Execute the user creation function
create_user

