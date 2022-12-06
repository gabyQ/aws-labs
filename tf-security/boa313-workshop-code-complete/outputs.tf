/* Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
   SPDX-License-Identifier: MIT-0 */

# Outputs that will dsiplay to the terminal window.

# --- root/outputs.tf ---

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "Output of VPC id created."
}

output "bucket_arn" {
  value       = module.s3_bucket.bucket_arn
  description = "Output of s3 bucket arn."
}


output "malicious_ip" {
  value       = module.compute.malicious_ip
  description = "Output of elastic ip created."
}

output "forensic_sg_id" {
  value       = module.vpc.forensic_sg_id
  description = "Output of forensic sg id created."
}

output "target_sg_id" {
  value       = module.vpc.target_sg_id
  description = "Output of target sg id created."
}