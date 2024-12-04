# 🛡️ **OpenVPN Web UI User Creation Script** 🛡️

## 🚀 **Overview**

This script allows administrators to **easily create OpenVPN Web UI users** on a Linux system. The script creates a new system user that can authenticate via OpenVPN, and optionally grants them **sudo privileges** for managing administrative tasks.

Perfect for managing your OpenVPN Web UI users with minimal hassle!

---

## ✨ **Features**

- **Create OpenVPN Users**: Prompt for **username** and **password**.
- **Option to Grant Sudo Privileges**: Decide whether to add the user to the `sudo` group.
- **Root Privileges Check**: Ensures the script is executed with necessary permissions.
- **Interactive Prompts**: User-friendly prompts for a smooth experience.

---

## 🛠️ **Prerequisites**

- **Root Privileges**: Required to create users and modify system configurations.
- **OpenVPN Web UI**: Ensure OpenVPN Web UI is already installed and configured on the system.
- **Sudo**: Available for adding users to the `sudo` group, if needed.

---

## 🚨 **Usage Instructions**

### 1. **Save the Script**

Save the script as `create_openvpn_user.sh` on your server.

### 2. **Make the Script Executable**

Change the permissions of the script to make it executable:

```bash
chmod +x create_openvpn_user.sh
```

### 3. **Run the Script**

Execute the script with **root** privileges by running:

```bash
sudo ./create_openvpn_user.sh
```

### 4. **Follow the Prompts**

You’ll be asked to provide:

- **Username**: The name for the new OpenVPN user.
- **Password**: The password for the new user (entered securely, hidden by default).
- **Sudo Privileges**: Whether the user should have **sudo** privileges (optional).

Example:

```bash
Enter the new username: john
Enter the password for john: [input password here]
Should john have sudo privileges? (y/n): y
```

### 5. **Completion**

Once the script runs successfully, the new user will be:

- Created with the provided username and password.
- Optionally added to the **sudo** group (if you answered "yes").
- Ready to authenticate via OpenVPN Web UI.

---

## 🧑‍💻 **Script Explanation**

### **User Creation**
- The script uses the `useradd` command to create the user.
- The `chpasswd` command is used to assign the password.

### **Optional Sudo Privileges**
- If you choose **yes** for sudo privileges, the user is added to the **sudo** group using `usermod -aG sudo`.

### **Root Privileges Check**
- The script checks if it’s being executed with root privileges (`$EUID -ne 0`). If not, it exits with an error message.

### **Security Considerations**
- The password is entered securely (input is hidden).
- Strong passwords are highly recommended.
- The script doesn’t validate the strength of the password, so it’s important to follow good security practices.

---

## 💡 **Example Usage**

```bash
$ sudo ./create_openvpn_user.sh
Enter the new username: alice
Enter the password for alice: [input password here]
Should alice have sudo privileges? (y/n): n
User alice has been created.
User alice does not have sudo privileges.
```

### Additional Notes:

- **OpenVPN Configuration**: Ensure the OpenVPN server is set to authenticate using system users (or a backend like LDAP).
- **Sudo Access**: Users with sudo privileges will be able to perform administrative tasks on the system. Grant sudo access carefully.

---

## 📝 **License**

This script is provided free of charge. Feel free to modify, use, and distribute it as per your preferred license.

---

## 📌 **Quick Recap:**

- **Easy User Creation**: Add OpenVPN Web UI users quickly.
- **Optional Sudo Privileges**: Decide if users need admin rights.
- **Root-Only Execution**: Ensures secure user creation.
- **Interactive & Secure**: Simple prompts and password handling.

---

### Thank you for using the **OpenVPN Web UI User Creation Script**! 🙌
