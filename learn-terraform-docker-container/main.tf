terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  required_version = ">= 0.12"
}

provider "aws" {
  region = "ap-northeast-2"  
}

# 네임노드 EC2 인스턴스
resource "aws_instance" "namenode" {
  ami           = "ami-05d2438ca66594916"
  instance_type = "t2.micro"
  key_name      = "mynewkey"

  tags = {
    Name = "namenode"
  }

  user_data = <<-EOF
              #!/bin/bash
              # 네임노드 설치 및 초기화 스크립트
              docker run -d --name namenode --network hadoop_network \
              -v namenode_data:/hadoop/dfs/name \
              -p 9870:9870 -p 9000:9000 bde2020/hadoop-namenode:2.0.0-hadoop3.2.1-java8
              EOF
}

# 데이터노드1 EC2 인스턴스
resource "aws_instance" "datanode1" {
  ami           = "ami-05d2438ca66594916"
  instance_type = "t2.micro"
  key_name      = "mynewkey"

  tags = {
    Name = "datanode1"
  }

  user_data = <<-EOF
              #!/bin/bash
              docker run -d --name datanode1 --network hadoop_network \
              -v datanode1_data:/hadoop/dfs/data \
              -e CORE_CONF_fs_defaultFS=hdfs://52.78.92.14:9000 \
              -e HDFS_CONF_dfs_datanode_address=0.0.0.0:50010 \
              -e HDFS_CONF_dfs_datanode_http_address=0.0.0.0:50075 \
              -e HDFS_CONF_dfs_datanode_ipc_address=0.0.0.0:8010 \
              -p 50010:50010 -p 50075:50075 -p 8010:8010 bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8
              EOF
}

# 데이터노드2 EC2 인스턴스
resource "aws_instance" "datanode2" {
  ami           = "ami-05d2438ca66594916"
  instance_type = "t2.micro"
  key_name      = "mynewkey"

  tags = {
    Name = "datanode2"
  }

  user_data = <<-EOF
              #!/bin/bash
              docker run -d --name datanode2 --network hadoop_network \
              -v datanode2_data:/hadoop/dfs/data \
              -e CORE_CONF_fs_defaultFS=hdfs://52.78.92.14:9000 \
              -e HDFS_CONF_dfs_datanode_address=0.0.0.0:50010 \
              -e HDFS_CONF_dfs_datanode_http_address=0.0.0.0:50075 \
              -e HDFS_CONF_dfs_datanode_ipc_address=0.0.0.0:8010 \
              -p 50010:50010 -p 50075:50075 -p 8010:8010 bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8
              EOF
}

# 데이터노드3 EC2 인스턴스
resource "aws_instance" "datanode3" {
  ami           = "ami-05d2438ca66594916"
  instance_type = "t2.micro"
  key_name      = "mynewkey"

  tags = {
    Name = "datanode3"
  }

  user_data = <<-EOF
              #!/bin/bash
              docker run -d --name datanode3 --network hadoop_network \
              -v datanode3_data:/hadoop/dfs/data \
              -e CORE_CONF_fs_defaultFS=hdfs://52.78.92.14:9000 \
              -e HDFS_CONF_dfs_datanode_address=0.0.0.0:50010 \
              -e HDFS_CONF_dfs_datanode_http_address=0.0.0.0:50075 \
              -e HDFS_CONF_dfs_datanode_ipc_address=0.0.0.0:8010 \
              -p 50010:50010 -p 50075:50075 -p 8010:8010 bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8
              EOF
}

output "namenode_ip" {
  value = aws_instance.namenode.public_ip
}
