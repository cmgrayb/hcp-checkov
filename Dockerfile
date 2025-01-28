# Use the latest Ubuntu image
FROM ubuntu:latest

# Install root dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    bash \
    python3 \
    python3-pip \
    pipx \
    ca-certificates \
    unzip \
    gpg \
    lsb-release \
    && apt-get clean

# Install Hashicorp repository
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list

# Install HashiCorp CLI
RUN apt-get update && apt-get install -y \
    coreutils \
    hcp \
    && apt-get clean

# Install pipx
RUN pipx ensurepath

# Install Checkov CLI using pipx
RUN pipx install checkov

# Add pipx binary path to PATH
ENV PATH=/root/.local/bin:$PATH

# Verify installations
RUN hcp version && checkov --version

# Set the entrypoint to bash
ENTRYPOINT ["/bin/bash"]
