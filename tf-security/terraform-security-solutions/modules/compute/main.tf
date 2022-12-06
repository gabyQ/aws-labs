# /* Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0 */

# --- modules/compute/main.tf ---

# CREATE Compromised EC2 Instance
resource "aws_instance" "compromised_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.initial_sg_id]
  user_data              = <<-EOF
  #!/bin/bash -ex
  exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
  sleep 5m
  echo BEGIN
  echo "* * * * * ping -c 6 -i 10 ${aws_eip.malicious_ip.public_ip}" | tee -a /var/spool/cron/ec2-user
  
  EOF

  tags = {
    Name = "GuardDuty-Example: Compromised Instance"
  }
}

# CREATE Malicious EC2 Instance
resource "aws_instance" "malicious_instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.initial_sg_id]
  user_data              = <<-EOF
  #!/bin/bash -ex

  # Start SSM Agent
  sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

  # Create Creds and Config files
  mkdir /home/ec2-user/.aws
  touch /home/ec2-user/.aws/credentials
  touch /home/ec2-user/.aws/config

  cat <<EOT >> /home/ec2-user/.aws/credentials
  [default]
  aws_access_key_id = var.access_key
  aws_secret_access_key = var.secret_key
  EOT

  # Modify Permissions and Ownership
  chmod 746 /home/ec2-user/.aws/credentials
  chown ec2-user /home/ec2-user/.aws/credentials
  chmod 746 /home/ec2-user/.aws/config
  chown ec2-user /home/ec2-user/.aws/config

  cat <<EOT >> /home/ec2-user/gd-findings.sh
  #!/bin/bash
  aws configure set default.region "us-east-1"
  aws iam get-user
  aws iam create-user --user-name Sarah
  aws dynamodb list-tables
  aws s3api list-buckets
  aws ssm describe-parameters
  aws ssm get-parameters --names "gd_prod_dbpwd_sample"
  sleep 10m
  aws s3api list-objects --bucket var.bucket
  EOT

  chmod 744 /home/ec2-user/gd-findings.sh
  chown ec2-user /home/ec2-user/gd-findings.sh

  echo "* * * * * /home/ec2-user/gd-findings.sh > /home/ec2-user/gd-findings.log 2>&1" | tee -a /var/spool/cron/ec2-user
  
  EOF

  tags = {
    Name = "GuardDuty-Example: Malicious Instance"
  }
}

# CREATE ELASTIC IP
resource "aws_eip" "malicious_ip" {
  instance = aws_instance.malicious_instance.id
  vpc      = true
}
