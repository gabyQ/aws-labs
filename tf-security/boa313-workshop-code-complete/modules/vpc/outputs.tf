/* Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 SPDX-License-Identifier: MIT-0 */
 
 #--- modules/vpc/outputs.tf ---
 output "subnet_id" {
   value       = aws_subnet.public_subnet.id
   description = "Output of public subnet id created - to place the EC2 instance(s) or VPC endpoints."
 }
 output "forensic_sg_id" {
   value       = aws_security_group.forensic_sg.id
   description = "Output of forensic sg id created - to place the EC2 instance(s)."
 }
 output "target_sg_id" {
   value       = aws_security_group.target_sg.id
   description = "Output of target sg id created - to place the EC2 instance(s)."
 }
 output "vpc_id" {
   value       = aws_vpc.vpc.id
   description = "Output of VPC id created."
 }