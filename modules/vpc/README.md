# AWS VPC Module

This Terraform module creates a complete VPC infrastructure in AWS with public, private, database, and protected subnets across multiple availability zones. The module is designed to be flexible and reusable across different environments while following AWS best practices.

## Features

- Creates a VPC with a specified CIDR block
- Creates subnets with different sizes for different purposes:
  - Private subnets (/18) for application servers
  - Public subnets (/21) for public-facing resources
  - Database subnets (/21) for RDS and other databases
  - Protected subnets (/24) for sensitive resources
- Configures NAT Gateways for private subnet internet access
- Sets up Internet Gateway for public subnets
- Creates route tables for all subnet types
- Configures security groups
- Supports CloudWAN integration
- Implements proper tagging strategy

## CIDR Block Structure

Using a base VPC CIDR of `10.0.0.0/16`, the module creates the following subnet structure:

### Private Subnets (/18)

- `10.0.0.0/18` (16,384 IPs) - AZ 1
- `10.0.64.0/18` (16,384 IPs) - AZ 2
- `10.0.128.0/18` (16,384 IPs) - AZ 3

### Public Subnets (/21)

- `10.0.192.0/21` (2,048 IPs) - AZ 1
- `10.0.200.0/21` (2,048 IPs) - AZ 2
- `10.0.208.0/21` (2,048 IPs) - AZ 3

### Database Subnets (/21)

- `10.0.216.0/21` (2,048 IPs) - AZ 1
- `10.0.224.0/21` (2,048 IPs) - AZ 2
- `10.0.232.0/21` (2,048 IPs) - AZ 3

### Protected Subnets (/24)

- `10.0.240.0/24` (256 IPs) - AZ 1
- `10.0.241.0/24` (256 IPs) - AZ 2
- `10.0.242.0/24` (256 IPs) - AZ 3

## Usage

### Basic Usage

```hcl
module "vpc" {
  source = "path/to/modules/vpc"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.0.0/18", "10.0.64.0/18", "10.0.128.0/18"]
  public_subnets  = ["10.0.0.0/21", "10.0.8.0/21", "10.0.16.0/21"]
  database_subnets = ["10.0.24.0/21", "10.0.32.0/21", "10.0.40.0/21"]
  protected_subnets = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### Advanced Usage with CloudWAN

```hcl
module "vpc" {
  source = "path/to/modules/vpc"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  # CloudWAN Configuration
  cloudwan_core_network_id = "cn-1234567890"
  cloudwan_segment_name    = "prod-segment"

  # Enable VPC Flow Logs
  enable_flow_log = true
  flow_log_destination_type = "cloud-watch-logs"
  flow_log_cloudwatch_log_group_retention_in_days = 30

  # Additional Security
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name to be used on all the resources as identifier | `string` | `null` | no |
| cidr | The CIDR block for the VPC | `string` | n/a | yes |
| azs | A list of availability zones in the region | `list(string)` | `[]` | no |
| private_subnets | A list of private subnets inside the VPC | `list(string)` | `[]` | no |
| public_subnets | A list of public subnets inside the VPC | `list(string)` | `[]` | no |
| database_subnets | A list of database subnets inside the VPC | `list(string)` | `[]` | no |
| protected_subnets | A list of protected subnets inside the VPC | `list(string)` | `[]` | no |
| enable_nat_gateway | Should be true if you want to provision NAT Gateways for each of your private networks | `bool` | `false` | no |
| single_nat_gateway | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | `bool` | `false` | no |
| enable_flow_log | Whether or not to enable VPC Flow Logs | `bool` | `false` | no |
| cloudwan_core_network_id | The ID of the CloudWAN core network | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| private_subnets | List of IDs of private subnets |
| public_subnets | List of IDs of public subnets |
| database_subnets | List of IDs of database subnets |
| protected_subnets | List of IDs of protected subnets |
| nat_gateway_ids | List of NAT Gateway IDs |
| nat_public_ips | List of Elastic IPs created for NAT Gateways |
| vpc_cidr_block | The CIDR block of the VPC |

## Notes

- The module automatically calculates subnet CIDR blocks if not explicitly provided
- NAT Gateways are created in the first availability zone by default
- Each subnet type has its own route table
- Security groups are created with basic rules and can be customized
- The module supports CloudWAN integration for global networking

## Best Practices

1. Always use meaningful names for your VPC and resources
2. Consider using a single NAT Gateway for cost optimization in non-production environments
3. Enable VPC Flow Logs for security monitoring
4. Use appropriate tags for resource management
5. Consider using CloudWAN for multi-region deployments
6. Review and adjust security group rules according to your needs

## License

This module is released under the same license as the main project.
