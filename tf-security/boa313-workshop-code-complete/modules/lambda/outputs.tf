# /* Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0 */

# --- modules/lambda/outputs.tf ---

output "GuardDuty-Example-Remediation-EC2MaliciousIPCaller" {
  description = "GuardDuty-Example-Remediation-EC2MaliciousIPCaller lambda function."

  value = aws_lambda_function.GuardDuty-Example-Remediation-EC2MaliciousIPCaller.function_name
}

output "lambda_remediation_function_arn" {
  value = aws_lambda_function.GuardDuty-Example-Remediation-EC2MaliciousIPCaller.arn
}