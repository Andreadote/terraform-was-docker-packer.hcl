#!/bin/bash

# Variables
PACKER_CONFIG="/aws_docker.pkr.hcl"

# Check if Packer is installed
if ! command -v packer &> /dev/null; then
    echo "Packer is not installed or not in PATH. Please install Packer and try again."
    exit 1
fi

# Initialization configuration
echo "Init Packer configuration..."
packer init .
init_exit_code=$?

if [ $init_exit_code -ne 0 ]; then
    echo "Packer init failed with exit code $init_exit_code."
    exit 1
else
    echo "Packer initialization completed successfully."
fi

# Fmt configuration
echo "Fmt Packer configuration..."
packer fmt .
fmt_exit_code=$?

if [ $fmt_exit_code -ne 0 ]; then
    echo "Packer fmt failed with exit code $fmt_exit_code."
    exit 1
else
    echo "Packer fmt completed successfully."
fi

# Validate configuration
echo "Validating Packer configuration..."
packer validate .
validate_exit_code=$?

if [ $validate_exit_code -ne 0 ]; then
    echo "Packer configuration validation failed with exit code $validate_exit_code."
    exit 1
else
    echo "Packer configuration validation completed successfully."
fi

sleep 5

# Checkov
echo "Running Checkov on Packer configuration..."
checkov -f $PACKER_CONFIG

sleep 5

# Build configuration
echo "Building AMI using Packer..."
packer build $PACKER_CONFIG
build_exit_code=$?

if [ $build_exit_code -ne 0 ]; then
    echo "Packer configuration build failed with exit code $build_exit_code."
    exit 1
else
    echo "Packer configuration build completed successfully."
fi

echo "AMI fully provisioned."
