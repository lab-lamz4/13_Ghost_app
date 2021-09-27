vpc_cidr_block          = "10.10.0.0/16"
azs                     = ["us-east-1a", "us-east-1b", "us-east-1c"]
private_subnet_cidrs    = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"]
privatedb_subnet_cidrs  = ["10.10.20.0/24", "10.10.21.0/24", "10.10.22.0/24"]
public_subnet_cidrs     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]

dbpassword              = "somepasswd"

tags            = {
  "Environment"   = "learning",
  "stack"         =  "cloudx"
  "Owner"         = "Andrei Leodorov",
  "Orchestration" = "Terraform"
}

region     = "us-east-1"


availability_zones = {
    us-east-1      = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
    us-east-2      = ["us-east-2a", "eu-east-2b", "eu-east-2c"]
    us-west-1      = ["us-west-1a", "us-west-1c"]
    us-west-2      = ["us-west-2a", "us-west-2b", "us-west-2c"]
    ca-central-1   = ["ca-central-1a", "ca-central-1b"]
    eu-west-1      = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    eu-west-2      = ["eu-west-2a", "eu-west-2b"]
    eu-central-1   = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
    ap-south-1     = ["ap-south-1a", "ap-south-1b"]
    sa-east-1      = ["sa-east-1a", "sa-east-1c"]
    ap-northeast-1 = ["ap-northeast-1a", "ap-northeast-1c"]
    ap-southeast-1 = ["ap-southeast-1a", "ap-southeast-1b"]
    ap-southeast-2 = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
    ap-northeast-1 = ["ap-northeast-1a", "ap-northeast-1c"]
    ap-northeast-2 = ["ap-northeast-2a", "ap-northeast-2c"]
  }
