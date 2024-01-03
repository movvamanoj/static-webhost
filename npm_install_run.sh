#!/bin/bash

install_common_packages() {
  echo "Installing common packages..."
}

install_wget_if_needed() {
  if ! command -v wget &>/dev/null; then
    echo "Installing wget..."
    # Use the appropriate package manager for your distribution
    if [[ -f /etc/redhat-release ]]; then
      sudo yum install -y wget
    elif [[ -f /etc/lsb-release ]]; then
      sudo apt-get update
      sudo apt-get install -y wget
    # Add more distribution-specific checks as needed
    else
      echo "Unsupported distribution. Please install wget manually."
      exit 1
    fi
  fi
}

# # Specify the desired directory path
#   target_directory="~/"
  
#   # Use wget with -O option to download and save in the specified directory
#   wget https://raw.githubusercontent.com/movvamanoj/static-webhost/main/app.js -O "$target_directory/app.js"


download_appjs() {
  echo "Downloading app.js from GitHub..."
  wget https://raw.githubusercontent.com/movvamanoj/static-webhost/main/app.js -O app.js
}

configure_nodejs_npm_redhat() {
  echo "Configuring Node.js and npm for Red Hat..."
  sudo yum install -y nodejs npm
  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'
  export PATH=~/.npm-global/bin:$PATH
  sudo npm install -g npm@10.2.5
}

configure_nodejs_npm_ubuntu() {
  echo "Configuring Node.js and npm for Ubuntu..."
  sudo apt-get update && sudo apt-get install -y nodejs npm
  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'
  export PATH=~/.npm-global/bin:$PATH
  sudo npm install -g npm@10.2.5
}

configure_nodejs_npm_amazon() {
  echo "Configuring Node.js and npm for Amazon Linux..."
  sudo yum install -y nodejs npm
  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'
  export PATH=~/.npm-global/bin:$PATH
  sudo npm install -g npm@10.2.5
}

configure_nodejs_npm_centos() {
  echo "Configuring Node.js and npm for CentOS..."
  sudo yum install -y epel-release
  sudo yum install -y nodejs npm
  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'
  export PATH=~/.npm-global/bin:$PATH
  sudo npm install -g npm@10.2.5
}

install_nodejs_packages() {
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

start_pm2() {
  echo "Starting app with pm2..."
  pm2 start app.js
}

# Check for wget and install if needed
install_wget_if_needed

# Check the Linux distribution and run commands accordingly
if [[ -f /etc/redhat-release ]]; then
  install_common_packages
  download_appjs
  configure_nodejs_npm_redhat
  install_nodejs_packages
  install_configure_cloudwatch_agent_redhat
elif [[ -f /etc/lsb-release ]]; then
  install_common_packages
  download_appjs
  configure_nodejs_npm_ubuntu
  install_nodejs_packages
  install_configure_cloudwatch_agent_ubuntu
elif [[ -f /etc/system-release && $(cat /etc/system-release) == "Amazon Linux" ]]; then
  configure_nodejs_npm_amazon
  install_nodejs_packages
  install_configure_cloudwatch_agent_amazon
elif [[ -f /etc/centos-release ]]; then
  install_common_packages
  download_appjs
  configure_nodejs_npm_centos
  install_nodejs_packages
  install_configure_cloudwatch_agent_centos
fi

start_pm2





# #!/bin/bash

# install_common_packages() {
#   echo "Installing common packages..."
# }

# configure_nodejs_npm_redhat() {
#   echo "Configuring Node.js and npm for Red Hat..."
#   sudo yum install -y nodejs npm
#   mkdir ~/.npm-global
#   npm config set prefix '~/.npm-global'
#   export PATH=~/.npm-global/bin:$PATH
#   sudo npm install -g npm@10.2.5
# }

# configure_nodejs_npm_ubuntu() {
#   echo "Configuring Node.js and npm for Ubuntu..."
#   sudo apt-get update && sudo apt-get install -y nodejs npm
#   mkdir ~/.npm-global
#   npm config set prefix '~/.npm-global'
#   export PATH=~/.npm-global/bin:$PATH
#   sudo npm install -g npm@10.2.5
# }

# configure_nodejs_npm_amazon() {
#   echo "Configuring Node.js and npm for Amazon Linux..."
#   sudo yum install -y nodejs npm
#   mkdir ~/.npm-global
#   npm config set prefix '~/.npm-global'
#   export PATH=~/.npm-global/bin:$PATH
#   sudo npm install -g npm@10.2.5
# }

# configure_nodejs_npm_centos() {
#   echo "Configuring Node.js and npm for CentOS..."
#   sudo yum install -y epel-release
#   sudo yum install -y nodejs npm
#   mkdir ~/.npm-global
#   npm config set prefix '~/.npm-global'
#   export PATH=~/.npm-global/bin:$PATH
#   sudo npm install -g npm@10.2.5
# }

# install_nodejs_packages() {
#   echo "Installing Node.js packages..."
#   npm install express body-parser aws-sdk
#   npm install -g pm2
#   npm install winston winston-cloudwatch @aws-sdk/client-dynamodb
# }

# install_configure_cloudwatch_agent_redhat() {
#   echo "Installing and configuring Amazon CloudWatch Agent for Red Hat..."
#   sudo yum install -y amazon-cloudwatch-agent
#   sudo systemctl start amazon-cloudwatch-agent
#   sudo systemctl enable amazon-cloudwatch-agent
# }

# install_configure_cloudwatch_agent_ubuntu() {
#   echo "Installing and configuring Amazon CloudWatch Agent for Ubuntu..."
#   sudo apt-get install -y amazon-cloudwatch-agent
#   sudo systemctl start amazon-cloudwatch-agent
#   sudo systemctl enable amazon-cloudwatch-agent
# }

# install_configure_cloudwatch_agent_amazon() {
#   echo "Installing and configuring Amazon CloudWatch Agent for Amazon Linux..."
#   sudo yum install -y amazon-cloudwatch-agent
#   sudo systemctl start amazon-cloudwatch-agent
#   sudo systemctl enable amazon-cloudwatch-agent
# }

# install_configure_cloudwatch_agent_centos() {
#   echo "Installing and configuring Amazon CloudWatch Agent for CentOS..."
#   sudo yum install -y amazon-cloudwatch-agent
#   sudo systemctl start amazon-cloudwatch-agent
#   sudo systemctl enable amazon-cloudwatch-agent
# }

# start_pm2() {
#   echo "Starting app with pm2..."
#   pm2 start app.js
# }

# # Check the Linux distribution and run commands accordingly
# if [[ -f /etc/redhat-release ]]; then
#   install_common_packages
#   configure_nodejs_npm_redhat
#   install_nodejs_packages
#   install_configure_cloudwatch_agent_redhat
# elif [[ -f /etc/lsb-release ]]; then
#   install_common_packages
#   configure_nodejs_npm_ubuntu
#   install_nodejs_packages
#   install_configure_cloudwatch_agent_ubuntu
# elif [[ -f /etc/system-release && $(cat /etc/system-release) == "Amazon Linux" ]]; then
#   configure_nodejs_npm_amazon
#   install_nodejs_packages
#   install_configure_cloudwatch_agent_amazon
# elif [[ -f /etc/centos-release ]]; then
#   install_common_packages
#   configure_nodejs_npm_centos
#   install_nodejs_packages
#   install_configure_cloudwatch_agent_centos
# fi

# start_pm2
