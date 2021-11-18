provider "aws" {
    region = "us-east-2"
    profile = "development"
}
data "aws_cloudformation_stack" "cloudformationstack" {
    name = "dev-observations2-cloudformation-stack"    
}

resource "aws_msk_cluster" "dev-observation-msk-cluster" {
  cluster_name           = "dev-observation-msk-cluster"
  kafka_version          = "2.8.0"
  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    ebs_volume_size = 10
    client_subnets = [
      data.aws_cloudformation_stack.cloudformationstack.outputs.Stacksubnet1,
      data.aws_cloudformation_stack.cloudformationstack.outputs.Stacksubnet2,
      data.aws_cloudformation_stack.cloudformationstack.outputs.Stacksubnet3,
    ]
    security_groups = [data.aws_cloudformation_stack.cloudformationstack.outputs.SecurityGroupID]

  }
}
