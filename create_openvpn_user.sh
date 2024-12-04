#!/bin/bash

# Function to trim leading/trailing spaces and check for spaces
trim_and_check_spaces() {
    local input="$1"
    # Remove leading and trailing spaces
    input=$(echo "$input" | xargs)
    # Check if the input contains spaces
    if [[ "$input" =~ \  ]]; then
        echo "Password should not contain spaces."
        return 1
    fi
    echo "$input"
    return 0
}

# Function to check if a user already exists
check_user_exists() {
    local username="$1"
    # Assuming `sacli --user <username> UserPropGet` or a similar command lists user properties
    # You can replace this with the actual command to check for existing users
    sacli --user "$username" UserPropGet >/dev/null 2>&1
    return $?
}

create_openvpn_user() {
    echo -n "Enter Username: "
    read username

    # Check if the user already exists
    check_user_exists "$username"
    if [ $? -eq 0 ]; then
        echo "Warning: A user with the username '$username' already exists."
        echo "Do you want to continue and overwrite the user (yes/no)?"
        read overwrite
        if [ "$overwrite" != "yes" ]; then
            echo "User creation aborted."
            exit 1
        fi
    fi

    # Loop until a valid password without spaces is entered
    while true; do
        echo -n "Enter Password (no spaces allowed): "
        read -s password_raw  # Hidden input for password
        echo  # For newline after password input
        password=$(trim_and_check_spaces "$password_raw")
        if [[ $? -ne 0 ]]; then
            continue
        fi

        echo -n "Confirm Password: "
        read -s confirm_password_raw  # Hidden input for password confirmation
        echo  # For newline after confirmation input
        confirm_password=$(trim_and_check_spaces "$confirm_password_raw")
        if [[ $? -ne 0 ]]; then
            continue
        fi

        if [ "$password" != "$confirm_password" ]; then
            echo "Passwords do not match. Please try again."
        else
            break
        fi
    done

    echo -n "Enter Group (leave empty for no group): "
    read group

    echo -n "Require Multi-Factor Authentication (yes/no): "
    read mfa

    echo -n "Use Static IP Address? (yes/no): "
    read static_ip

    if [ "$static_ip" == "yes" ]; then
        echo -n "Enter Static IP Address (must be within VPN range): "
        read static_ip_address
    fi

    echo -n "Use NAT or Routing (nat/routing): "
    read nat_or_routing

    echo -n "Enter Access Control Networks (comma-separated or leave blank): "
    read access_networks

    echo -e "\nPlease verify the entered information:"
    echo "-------------------------------------"
    echo "Username: $username"
    echo "Password: $password"
    echo "Group: ${group:-Default Group}"
    echo "MFA Enabled: $mfa"
    echo "Static IP Address: ${static_ip:-no}"
    if [ "$static_ip" == "yes" ]; then
        echo "Static IP Address: $static_ip_address"
    fi
    echo "NAT or Routing: $nat_or_routing"
    echo "Access Control Networks: ${access_networks:-None}"
    echo "-------------------------------------"

    echo "Is this information correct? (yes/no)"
    read confirmation

    if [ "$confirmation" != "yes" ]; then
        echo "User creation aborted."
        exit 1
    fi

    # Create user and set local password
    echo "Setting password for $username..."
    echo "$password" | sacli --user "$username" SetLocalPassword

    # Check if the password was set successfully (optional debugging)
    if [ $? -ne 0 ]; then
        echo "Error setting password."
        exit 1
    fi

    # Assign group if specified
    if [ -n "$group" ]; then
        sacli --user "$username" --key "conn_group" --value "$group" UserPropPut
        echo "User added to group $group"
    else
        echo "No group specified, user will belong to the default group."
    fi

    # Enable or disable MFA
    if [ "$mfa" == "yes" ]; then
        sacli --user "$username" --key "prop_google_auth_enable" --value "true" UserPropPut
    else
        sacli --user "$username" --key "prop_google_auth_enable" --value "false" UserPropPut
    fi

    # Set IP Addressing
    if [ "$static_ip" == "yes" ]; then
        sacli --user "$username" --key "prop_static_ip" --value "$static_ip_address" UserPropPut
    else
        sacli --user "$username" --key "prop_static_ip" --value "" UserPropPut
    fi

    # Set NAT or Routing
    if [ "$nat_or_routing" == "nat" ]; then
        sacli --user "$username" --key "prop_reroute_dns" --value "false" UserPropPut
    elif [ "$nat_or_routing" == "routing" ]; then
        sacli --user "$username" --key "prop_reroute_dns" --value "true" UserPropPut
    fi

    # Configure Access Networks
    if [ -n "$access_networks" ]; then
        sacli --user "$username" --key "prop_autopush" --value "route ${access_networks//,/ }" UserPropPut
    fi

    echo "User $username created successfully with specified settings."
}

# Execute the function
create_openvpn_user
