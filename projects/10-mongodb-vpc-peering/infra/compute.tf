locals {
  key_name = "key-${local.project_name}"
  key_pair = var.key_pair

  instances = {
    bastion = {
      name                        = "bastion-${local.project_name}"
      type                        = "t2.micro"
      subnet_id                   = module.vpc.public_subnets[0]
      associate_public_ip_address = true
    }
    internal = {
      name                        = "internal-${local.project_name}"
      type                        = "t2.micro"
      subnet_id                   = module.vpc.private_subnets[0]
      associate_public_ip_address = false
    }
  }

  whitelist_cidr_blocks = [
    local.vpc_cidr_block,
    var.my_ip
  ]
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# AWS Key Pair
resource "aws_key_pair" "warike_development_instaces_key_pair" {
  key_name   = local.key_name
  public_key = local.key_pair
}

# AWS Bastion instance
resource "aws_instance" "warike_development_bastion" {
  for_each = local.instances

  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = each.value.type
  subnet_id                   = each.value.subnet_id
  associate_public_ip_address = each.value.associate_public_ip_address
  key_name                    = aws_key_pair.warike_development_instaces_key_pair.key_name

  vpc_security_group_ids = [
    aws_security_group.warike_development_instances_security_group.id,
  ]

  tags = {
    Name         = each.value.name
    InstanceType = each.value.type
  }
}

# AWS Security group
resource "aws_security_group" "warike_development_instances_security_group" {
  name        = "instances-sg-${local.project_name}"
  description = "Security group for ${local.project_name} instances"
  vpc_id      = module.vpc.vpc_id

  ## allow ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = local.whitelist_cidr_blocks
  }
  ## allow icmp
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "ICMP"
    cidr_blocks = local.whitelist_cidr_blocks
  }
  ## allow egress
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = "instances-sg-${local.project_name}"
  }
}

