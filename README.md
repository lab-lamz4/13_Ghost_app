# Ghost app

Application solution requires high available and secure setup on AWS using DataBase, Filesystem and Compute services.

## vars

set up the follow variables

```
TF_VAR_dbpassword="somepassword"

```

edit if it needed terraform.tfvars


## Usage

terraform apply -target aws_ecr_repository.ecr_repository

```
docker pull ghost:4-alpine

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 899745080525.dkr.ecr.us-east-1.amazonaws.com/ecr-ghost

docker tag ghost:4-alpine 899745080525.dkr.ecr.us-east-1.amazonaws.com/ecr-ghost:4-alpine

docker push 899745080525.dkr.ecr.us-east-1.amazonaws.com/ecr-ghost:4-alpine

terraform apply
terraform destroy

```

