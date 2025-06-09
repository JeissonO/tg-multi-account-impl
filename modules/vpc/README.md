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

  enable_nat_gateway = true
  create_igw        = true

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

### Adding VPC Flow Logs

```hcl
module "vpc" {
  source = "path/to/modules/vpc"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  enable_nat_gateway = true
  create_igw        = true

  # Enable VPC Flow Logs
  enable_flow_log = true
  flow_log_destination_type = "cloud-watch-logs"
  flow_log_cloudwatch_log_group_retention_in_days = 30
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role = true

  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the VPC. If not provided, will use 'jo-vpc-{region}' | `string` | `null` | no |
| cidr | Base CIDR block for the VPC. Must be a /16 CIDR block | `string` | n/a | yes |
| create_igw | Controls if an Internet Gateway is created for public subnets | `bool` | `false` | no |
| enable_nat_gateway | Should be true if you want to provision NAT Gateways for each of your private networks | `bool` | `false` | no |
| enable_flow_log | Whether or not to enable VPC Flow Logs | `bool` | `false` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
| vpc_tags | Additional tags for the VPC | `map(string)` | `{}` | no |
| public_subnet_tags | Additional tags for the public subnets | `map(string)` | `{}` | no |
| private_subnet_tags | Additional tags for the private subnets | `map(string)` | `{}` | no |
| database_subnet_tags | Additional tags for the database subnets | `map(string)` | `{}` | no |
| intra_subnet_tags | Additional tags for the intra subnets | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_arn | The ARN of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| default_security_group_id | The ID of the security group created by default on VPC creation |
| default_network_acl_id | The ID of the default network ACL |
| default_route_table_id | The ID of the default route table |
| vpc_enable_dns_support | Whether or not the VPC has DNS support |
| vpc_main_route_table_id | The ID of the main route table associated with this VPC |
| public_subnets | List of IDs of public subnets |
| public_subnet_arns | List of ARNs of public subnets |
| public_subnets_cidr_blocks | List of cidr_blocks of public subnets |
| public_route_table_ids | List of IDs of public route tables |
| private_subnets | List of IDs of private subnets |
| private_subnet_arns | List of ARNs of private subnets |
| private_subnets_cidr_blocks | List of cidr_blocks of private subnets |
| private_route_table_ids | List of IDs of private route tables |
| database_subnets | List of IDs of database subnets |
| database_subnet_arns | List of ARNs of database subnets |
| database_subnets_cidr_blocks | List of cidr_blocks of database subnets |
| database_route_table_ids | List of IDs of database route tables |
| protected_subnets | List of IDs of protected subnets |
| protected_subnet_arns | List of ARNs of protected subnets |
| protected_subnets_cidr_blocks | List of CIDRs of protected subnets |
| protected_route_table_ids | List of IDs of protected route tables |

## Notes

- The module automatically calculates subnet CIDR blocks
- NAT Gateways are created in the first availability zone by default
- Each subnet type has its own route table
- Security groups are created with basic rules and can be customized

## Best Practices

1. Always use meaningful names for your VPC and resources
2. Consider using a single NAT Gateway for cost optimization in non-production environments
3. Enable VPC Flow Logs for security monitoring
4. Use appropriate tags for resource management
5. Review and adjust security group rules according to your needs

## License

This module is released under the same license as the main project.
