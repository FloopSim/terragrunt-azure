# Use an official lightweight Python image.
# https://hub.docker.com/_/python
FROM python:3.7-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Terraform
ENV TERRAFORM_VERSION=0.15.3
RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o /tmp/terraform.zip && \
    unzip /tmp/terraform.zip -d /usr/local/bin && \
    rm /tmp/terraform.zip

# Install Terragrunt
ENV TERRAGRUNT_VERSION=0.58.2
RUN curl -L https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -o /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt

# Set the working directory in the docker image
WORKDIR /terragrunt-azure

# Copy all files from the current directory to the /app in the image
COPY . /terragrunt-azure

# Move the cwd to a more convenient place for development
WORKDIR /terragrunt-azure/azure-subscription-1/staging

# Azure Service Provider Credentials
ARG arm_client_secret
ARG arm_client_id
ENV ARM_CLIENT_ID=$arm_client_id
ENV ARM_CLIENT_SECRET=$arm_client_secret
ENV ARM_TENANT_ID="e4518e05-9865-4dad-a5a9-98a2477ad591"
ENV ARM_SUBSCRIPTION_ID="39687ff1-8d1a-4d13-9b6e-0ad36e03cab3"