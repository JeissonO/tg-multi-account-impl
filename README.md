# Multi-Account AWS Infrastructure with Terraform

This repository contains the Terraform infrastructure code for managing resources across multiple AWS accounts using a centralized state management approach. The infrastructure is designed to be modular, reusable, and follows AWS best practices for multi-account architecture.

## Project Structure

```sh
tg-multi-account-impl/
├── deployments/             # Deployments folder
│   ├── dev/                 # Development account configuration
│   ├── prod/                # Production account configuration
│   └── shared/              # Shared services account configuration
│       ├── account.hcl              # Account file to manage account/environment specific configurations
│       └── <aws-region>             # Region Folder / identifies the aws home region where deployments will be executed
│           ├── region.hcl           # The region configuration file / identifies the aws home region where deployments will be executed
│           └── deployment/          # Deployment specific folder 
│               └── terragrunt.hcl   # Terragrunt file to configure module calls and implementations
├── modules/                 # Reusable Terraform modules
│   ├── vpc/                 # VPC module with networking components
│   └── ...                  # Other infrastructure modules
├── root.hcl                 # Root Terragrunt configuration
├── makefile                 # Build and deployment automation
└── .pre-commit-config.yaml  # Pre-commit hooks configuration
```

## Prerequisites

- Terraform >= 1.0.0
- Terragrunt >= 0.35.0
- AWS CLI configured with appropriate credentials
- Make (for using the provided Makefile)

## Getting Started

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd tg-multi-account-impl
   ```

2. Configure AWS credentials for the target account:

   ```bash
   aws configure --profile <account-profile>
   ```

## Infrastructure Components

### VPC example Module

The VPC module (`modules/vpc/`) creates a complete networking infrastructure with:

- VPC with CIDR block /16
- Subnets with different sizes:
  - Private subnets: /18 (16,384 IPs each)
  - Public subnets: /21 (2,048 IPs each)
  - Database subnets: /21 (2,048 IPs each)
  - Protected subnets: /24 (256 IPs each)
- NAT Gateways
- Internet Gateways
- Route tables
- Security groups

### Account Structure

- `accounts/dev/`: Development environment configuration
- `accounts/prod/`: Production environment configuration
- `accounts/shared/`: Shared services configuration

## Usage

1. **Adding a New Account**
   - Create a new directory under `accounts/`
   - Copy and modify the configuration from an existing account
   - Update the account-specific variables

2. **Modifying Infrastructure**
   - Make changes in the appropriate module under `modules/`
   - Update the account configuration if needed
   - In the target Deployment folder Run `tg init && tg plan` to verify changes

        ```bash
        tg init
        tg plan
        ```

   - Apply changes with `tg apply`

        ```bash
        tg apply
        ```

3. **Destroying Infrastructure**

   ```bash
   tg destroy
   ```

## Best Practices

- Always run `tg plan` before applying changes
- Follow the naming convention for resources
- Keep sensitive information in AWS Secrets Manager or Parameter Store
- Use pre-commit hooks to maintain code quality

## Contributing

1. Create a new branch for your changes
2. Make your modifications
3. Run pre-commit hooks: `pre-commit run -a`
4. Submit a pull request

## License

This project is licensed under the terms of the license included in the repository.
