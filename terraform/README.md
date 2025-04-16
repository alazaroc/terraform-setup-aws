# Terraform Remote State Setup (S3 + DynamoDB)

This Terraform project sets up an **S3 bucket** for storing Terraform state and a **DynamoDB table** for state locking. These resources can be used in other Terraform projects to enable remote state management.

## Prerequisites

Before running this Terraform project, ensure you have the following installed:

- [Terraform](https://developer.hashicorp.com/terraform/downloads) (>= 1.3.0)
- [AWS CLI](https://aws.amazon.com/cli/) (configured with the required permissions)
- AWS credentials configured via `aws configure` or environment variables.

## Deployment Steps

1. **Clone the repository (or create a new directory and add these files)**

    ```sh
    git clone <repository-url>
    cd <repository-folder>
    ```

2. **Initialize Terraform**

    ```sh
    terraform init
    ```

3. Review the execution plan:

    ```sh
    terraform plan
    ```

4. Apply the configuration to create the S3 bucket and DynamoDB table:

    ```sh
    terraform apply -auto-approve
    ```

5. Verify the created resources:

- Check the S3 bucket in the AWS Console (S3 service).
- Check the DynamoDB table in the AWS Console (DynamoDB service).

## Using This Remote State in Other Terraform Projects

Once the infrastructure is deployed, configure your other Terraform projects to use this remote state.

Add the following backend configuration in your Terraform projects:

```hcl
terraform {
    backend "s3" {
        bucket         = "terraform-state-bucket-xxxxxx"  # Update with your bucket name (you can replace xxxxxx with your account number)
        key            = "path/to/my/terraform.tfstate"   # Change the key to organize states
        region         = "eu-west-1"                      # Update with your region
        dynamodb_table = "terraform-locks"
        encrypt        = true
    }
}
```

Then, initialize the backend in your project:

```sh
terraform init
```

## Destroying the Infrastructure

To delete the resources created by this project, run:

```sh
terraform destroy -auto-approve
```

> Warning: This will permanently delete the S3 bucket and DynamoDB table. Ensure that no other Terraform projects are using this backend before destroying it.

## Troubleshooting

- If the S3 bucket name is already taken, modify the bucket name in main.tf to a globally unique name.
- Ensure that your AWS credentials have permissions to create S3 buckets and DynamoDB tables.
- If terraform init fails in another project, ensure this Terraform backend has already been deployed.
