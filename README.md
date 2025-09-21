# Terraform Backend on AWS

This project provides the `necessary infrastructure on AWS to configure a robust backend for Terraform`. The repository includes templates and code to create the Terraform state storage resources securely and reliably.

## Resources Created

* **Amazon S3 Bucket:** Used for remote and secure storage of Terraform state files. The bucket is configured with versioning to protect against accidental deletions and maintain a history of states.
* **Amazon DynamoDB Table:** This database table is used for state locking. This is crucial to prevent multiple users or processes from modifying the same Terraform state concurrently, thereby preventing state corruption.

---

## Deployment Options

You can deploy the required AWS resources using one of the following infrastructure as code (IaC) tools:

* **Terraform:** The `terraform` folder contains HashiCorp Terraform code to provision the S3 bucket and DynamoDB table.
* **CloudFormation:** The `cloudformation` folder contains an AWS CloudFormation template to create the same AWS resources declaratively.

---

## How to Use

1. **Choose your deployment tool:**
    * If you prefer **Terraform**, navigate to the `terraform` folder and follow the instructions in its `README.md`.
    * If you prefer **CloudFormation**, navigate to the `cloudformation` folder and use the provided template.

2. **Configure your Terraform backend:**
    * Once the S3 bucket and DynamoDB table are created, update your Terraform backend configuration in your other projects to point to these new resources.

---

## Prerequisites

* **AWS CLI:** Ensure you have the AWS Command Line Interface installed and configured with appropriate credentials.
* **Terraform:** If you plan to use Terraform, you will need to have it installed.
* **CloudFormation:** If you plan to use CloudFormation, no additional local installation is required, as it is an integrated AWS service.
