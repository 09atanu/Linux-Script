#!/bin/bash

# Proxy Configuration
HTTP_PROXY="http://<Proxy IP:Port>"
HTTPS_PROXY="http://<Proxy IP:Port>"
FTP_PROXY="ftp://<Proxy IP:Port>"
NO_PROXY="localhost,127.0.0.1,::1"

# Update /etc/environment for system-wide proxy
echo "Setting system-wide proxy in /etc/environment..."
sudo tee /etc/environment > /dev/null <<EOL
http_proxy="$HTTP_PROXY"
https_proxy="$HTTPS_PROXY"
ftp_proxy="$FTP_PROXY"
no_proxy="$NO_PROXY"
EOL

# Update APT proxy configuration
echo "Setting proxy for APT in /etc/apt/apt.conf.d/95proxies..."
sudo tee /etc/apt/apt.conf.d/95proxies > /dev/null <<EOL
Acquire::http::Proxy "$HTTP_PROXY";
Acquire::https::Proxy "$HTTPS_PROXY";
Acquire::ftp::Proxy "$FTP_PROXY";
EOL

# Update current session environment variables
echo "Setting proxy for the current session..."
export http_proxy="$HTTP_PROXY"
export https_proxy="$HTTPS_PROXY"
export ftp_proxy="$FTP_PROXY"
export no_proxy="$NO_PROXY"

# Confirmation
echo "Proxy has been set system-wide."
echo "HTTP Proxy: $HTTP_PROXY"
echo "HTTPS Proxy: $HTTPS_PROXY"
echo "FTP Proxy: $FTP_PROXY"
echo "No Proxy: $NO_PROXY"

