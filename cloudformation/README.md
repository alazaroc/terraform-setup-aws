# CloudFormation Template for Terraform Backend

This folder contains an AWS CloudFormation template to deploy the necessary resources for a Terraform backend state. This approach is useful for bootstrapping your environment, as it allows you to create the backend resources without needing a separate Terraform configuration for them.

## Resources Deployed

The provided template creates two key resources in your AWS account:

* **Amazon S3 Bucket:** A dedicated bucket for storing your Terraform state files (`.tfstate`). It's configured with **versioning enabled** to protect against accidental overwrites and deletions.
* **Amazon DynamoDB Table:** A table to handle state locking. This prevents multiple people or automated jobs from running `terraform apply` at the same time and corrupting your state file.

## How to Use

To use this template, you can deploy it directly from the AWS Management Console or via the AWS Command Line Interface (CLI).

### Prerequisites

* **AWS CLI:** You need the AWS CLI installed and configured with the necessary permissions to create S3 and DynamoDB resources.

### Deployment via AWS CLI

1.  **Save the template:** Ensure the CloudFormation YAML template is saved in this folder (e.g., as `template.yaml`).
2.  **Run the deployment command:** Execute the following command in your terminal, replacing the parameter values with your desired names. The bucket name must be globally unique.

    ```sh
    aws cloudformation create-stack \
      --stack-name YourTerraformBackendStack \
      --template-body file://template.yaml \
      --parameters \
        ParameterKey=BucketName,ParameterValue=your-unique-bucket-name \
        ParameterKey=TableName,ParameterValue=terraform-state-lock-table
    ```

3.  **Monitor the deployment:** You can check the stack's status in the AWS CloudFormation console.

### Template Parameters

The template includes two customizable parameters:

* `BucketName`: The unique name for your S3 bucket.
* `TableName`: The name for the DynamoDB table.

### Template Outputs

Once the stack is deployed, CloudFormation will output the names of the created resources, which you can use to configure your Terraform projects.
