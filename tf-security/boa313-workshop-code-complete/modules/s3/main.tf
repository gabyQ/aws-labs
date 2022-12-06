# /* Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0 */
 
 
 # --- modules/s3/main.tf ---
 
 # GET CURRENT AWS ACCOUNT NUMBER
 
 data "aws_caller_identity" "current" {}
 
 # CREATE AN S3 BUCKET
 
 resource "aws_s3_bucket" "bucket" {
   bucket = "guardduty-example-${data.aws_caller_identity.current.account_id}-us-east-1"
   force_destroy = true
 }

 
 
 # VPC FLOW LOGS
 resource "aws_flow_log" "flow_log_example" {
   log_destination      = aws_s3_bucket.bucket.arn
   log_destination_type = "s3"
   traffic_type         = "ALL"
   vpc_id               = var.vpc_id
 }