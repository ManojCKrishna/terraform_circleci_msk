provider "aws" {
  region     = var.region
  profile = var.profile
}
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc
  tags = {
    Name = "dev-observation-vpc"
  }
}
resource "aws_subnet" "subnet1" {
  availability_zone = "us-east-2a"
  cidr_block        = var.subnet1
  tags = {
    Name = "dev-observation-msk-subnet-1"
  }
vpc_id            = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet2" {
  availability_zone = "us-east-2b"
  cidr_block        = var.subnet2
  tags = {
    Name = "dev-observation-msk-subnet-2"
  }
  vpc_id            = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet3" {
  availability_zone = "us-east-2c"
  cidr_block        = var.subnet3
  tags = {
    Name = "dev-observation-msk-subnet-3"
  }
  vpc_id            = aws_vpc.vpc.id
}
resource "aws_security_group" "securitygroup" {
  tags = {
    Name = var.securitygroup
  }
  vpc_id = aws_vpc.vpc.id
}
resource "aws_msk_cluster" "dev-observation-msk-cluster" {
    cluster_name = var.cluster_name
    kafka_version = var.kafka_version
    number_of_broker_nodes = 3
    broker_node_group_info {
        instance_type = var.instance_type
        ebs_volume_size = var.ebs_volume_size
        client_subnets = [
            aws_subnet.subnet1.id,
            aws_subnet.subnet2.id,
            aws_subnet.subnet3.id,
        ]
    security_groups = [aws_security_group.securitygroup.id]
   }
}