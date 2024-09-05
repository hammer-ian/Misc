#!/bin/bash
# EC2 instance IPs change every the instance is rebooted. I've had mixed success with SSM Session Manager, the terminal formatting isn't great
# This script retrieves the latest public IP address and logs you in
# Remember to update the script with your VPC id, and .pem file details

# Check if the user provided an instance name
if [ -z "$1" ]; then
  echo "Usage: $0 <InstanceName>"
  exit 1
fi

INSTANCE_NAME=$1

# Get the public IP address of the specified instance
INSTANCE_INFO=$(aws ec2 describe-instances \
--filters "Name=vpc-id,Values=vpc-<add VPC id>" \
--query "Reservations[].Instances[?Tags[?Key=='Name']|[0].Value=='$INSTANCE_NAME'].{PublicIpAddress:PublicIpAddress}" \
--output text)

# If instance not found then throw error
if [ -z "$INSTANCE_INFO" ]; then
  echo "Instance with name $INSTANCE_NAME not found."
  exit 1
fi

# Execute the SSH command
ssh -i <add pem file path> ec2-user@"$INSTANCE_INFO"
