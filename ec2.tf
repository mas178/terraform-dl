variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "ssh_key_file" {}
variable "github_password" {}
variable "aws_region" {
  default = "ap-northeast-1"
}
variable "aws_zone" {
  default = "ap-northeast-1"
}
variable "key_name" {
  default = "dl"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}

resource "aws_instance" "dl" {
  ami = "ami-ff995499"
  # "p2.xlarge" / "t2.nano"
  instance_type = "t2.nano"
  key_name = "${var.key_name}"
  security_groups = [
    "${aws_security_group.default.name}"]
  monitoring = true
  tags {
    Name = "dl"
  }
}

resource "aws_ebs_volume" "dl" {
  availability_zone = "ap-northeast-1a"
  size = 50
  tags {
    Name = "dl"
  }
}

resource "aws_volume_attachment" "dl" {
  device_name = "/dev/sdh"
  volume_id = "${aws_ebs_volume.dl.id}"
  instance_id = "${aws_instance.dl.id}"
  force_detach = true

  provisioner "file" {
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("${var.ssh_key_file}")}"
      host = "${aws_instance.dl.public_ip}"
    }
    source = "provision.sh"
    destination = "/tmp/provision.sh"
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("${var.ssh_key_file}")}"
      host = "${aws_instance.dl.public_ip}"
    }
    inline = [
      "chmod +x /tmp/provision.sh",
      "/tmp/provision.sh ${var.github_password}",
    ]
  }
}

resource "aws_security_group" "default" {
  name = "terraform_example"
  description = "Used in the terraform"

  # SSH access from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # for Jupyter notebook
  ingress {
    from_port = 8888
    to_port = 8888
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # for git clone
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}
