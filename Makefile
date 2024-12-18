#? node-npm-docker-git-install-makefile

# EC2 Instance Setup Makefile
.PHONY: all update install-git install-docker install-node install-basic-tools

# Default target
all: update install-basic-tools install-git install-docker install-node

# Update package lists
update:
	@echo "Updating package lists..."
	sudo apt-get update

# Install basic tools
install-basic-tools:
	@echo "Installing basic tools..."
	sudo apt-get install -y \
		build-essential \
		curl \
		wget \
		unzip \
		software-properties-common

# Install Git
install-git:
	@echo "Installing Git..."
	sudo apt-get install -y git
	@echo "Git version:"
	git --version

# Install Docker
install-docker:
	@echo "Installing Docker..."
	sudo apt-get remove docker docker-engine docker.io containerd runc || true
	sudo apt-get install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		gnupg \
		lsb-release
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	echo \
		"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
		$$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	sudo apt-get update
	sudo apt-get install -y docker-ce docker-ce-cli containerd.io
	sudo systemctl start docker
	sudo systemctl enable docker
	sudo usermod -aG docker $$USER
	@echo "Docker version:"
	docker --version

# Install Node.js and npm
install-node:
	@echo "Installing Node.js and npm..."
	curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
	sudo apt-get install -y nodejs
	@echo "Node.js version:"
	node --version
	@echo "npm version:"
	npm --version