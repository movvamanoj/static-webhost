#!/bin/bash
# Download app.js from GitHub to the home path
curl -O https://raw.githubusercontent.com/movvamanoj/static-webhost/main/app.js

# Display the path where app.js is downloaded
downloaded_file_path=$(pwd)/app.js
echo "app.js is downloaded to: $downloaded_file_path"

# Function to check npm version
check_npm_version() {
  if ! command -v npm &> /dev/null; then
    echo "npm is not installed. Installing npm..."
    install_npm_based_on_os
  fi
  echo "npm version: $(npm --version)"
}

install_npm_based_on_os() {
  # Check the Linux distribution and run commands accordingly
  if [[ -f /etc/redhat-release ]]; then
    configure_nodejs_npm_redhat
  elif [[ -f /etc/lsb-release ]]; then
    configure_nodejs_npm_ubuntu
  elif [[ -f /etc/system-release-cpe ]]; then
    configure_nodejs_npm_amazon
  elif [[ -f /etc/centos-release ]]; then
    configure_nodejs_npm_centos
  else
    echo "Unsupported operating system. Please install npm manually."
    exit 1
  fi
}

install_common_packages() {
  echo "Installing common packages..."
  # Add commands for installing common packages if needed
}

configure_nodejs_npm_redhat() {
  echo "Configuring Node.js and npm for Red Hat..."
  sudo yum install -y nodejs npm
  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'
  export PATH=~/.npm-global/bin:$PATH
  sudo npm install -g npm@10.3.0
}

configure_nodejs_npm_ubuntu() {
  echo "Configuring Node.js and npm for Ubuntu..."
  sudo apt-get update && sudo apt-get install -y nodejs npm
  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'
  export PATH=~/.npm-global/bin:$PATH
  sudo npm install -g npm@10.3.0
}

configure_nodejs_npm_amazon() {
  echo "Configuring Node.js and npm for Amazon Linux..."
  sudo yum install -y nodejs npm
  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'
  export PATH=~/.npm-global/bin:$PATH
  sudo npm install -g npm@10.3.0
}

configure_nodejs_npm_centos() {
  echo "Configuring Node.js and npm for CentOS..."
  sudo yum install -y epel-release
  sudo yum install -y nodejs npm
  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'
  export PATH=~/.npm-global/bin:$PATH
  sudo npm install -g npm@10.3.0
}

install_nodejs_packages() {
  check_npm_version
  echo "Installing Node.js packages..."
  npm install express body-parser aws-sdk
  npm install -g pm2
  npm install winston winston-cloudwatch @aws-sdk/client-dynamodb
}

install_configure_cloudwatch_agent_redhat() {
  echo "Installing and configuring Amazon CloudWatch Agent for Red Hat..."
  sudo yum install -y amazon-cloudwatch-agent
  sudo systemctl start amazon-cloudwatch-agent
  sudo systemctl enable amazon-cloudwatch-agent
}

install_configure_cloudwatch_agent_ubuntu() {
  echo "Installing and configuring Amazon CloudWatch Agent for Ubuntu..."
  sudo apt-get install -y amazon-cloudwatch-agent
  sudo systemctl start amazon-cloudwatch-agent
  sudo systemctl enable amazon-cloudwatch-agent
}

install_configure_cloudwatch_agent_amazon() {
  echo "Installing and configuring Amazon CloudWatch Agent for Amazon Linux..."
  sudo yum install -y amazon-cloudwatch-agent
  sudo systemctl start amazon-cloudwatch-agent
  sudo systemctl enable amazon-cloudwatch-agent
}

install_configure_cloudwatch_agent_centos() {
  echo "Installing and configuring Amazon CloudWatch Agent for CentOS..."
  sudo yum install -y amazon-cloudwatch-agent
  sudo systemctl start amazon-cloudwatch-agent
  sudo systemctl enable amazon-cloudwatch-agent
}

# Check npm version before proceeding
check_npm_version

install_common_packages
echo " Export PATH for pm2 to be available in the script's environment"
echo "Exporting PATH: ~/.npm-global/bin:$PATH"
export PATH=~/.npm-global/bin:$PATH

# Check the Linux distribution and run commands accordingly
if [[ -f /etc/redhat-release ]]; then
  configure_nodejs_npm_redhat
  install_nodejs_packages
  install_configure_cloudwatch_agent_redhat
elif [[ -f /etc/lsb-release ]]; then
  configure_nodejs_npm_ubuntu
  install_nodejs_packages
  install_configure_cloudwatch_agent_ubuntu
elif [[ -f /etc/system-release-cpe ]]; then
  configure_nodejs_npm_amazon
  install_nodejs_packages
  install_configure_cloudwatch_agent_amazon
elif [[ -f /etc/centos-release ]]; then
  configure_nodejs_npm_centos
  install_nodejs_packages
  install_configure_cloudwatch_agent_centos
fi


# Start the application using pm2, checking for package installation
if command -v pm2 >/dev/null && [[ -f node_modules ]]; then 
  # echo " Export PATH for pm2 to be available in the script's environment"
  # export PATH=~/.npm-global/bin:$PATH
  echo "Starting app.js using pm2..."
  pm2 start app.js
else
  echo "Installing Node.js packages and pm2..."
  install_nodejs_packages  # Install the packages (including pm2)
  pm2 start app.js
fi
