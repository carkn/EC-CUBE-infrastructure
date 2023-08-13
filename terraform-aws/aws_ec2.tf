############################################################
# EC2
############################################################
resource "null_resource" "ssh-keygen" {
  provisioner "local-exec" {
    command = <<EOF
      ssh-keygen -t rsa -f ../ssh/ec2 -N ''; exit 0
    EOF
  }
}

data "local_file" "ssh-keygen" {
  filename   = "../ssh/ec2.pub"
  depends_on = [null_resource.ssh-keygen]
}

resource "aws_instance" "web_server" {
  ami           = "${var.ec2_ami}"
  instance_type = "${var.ec2_instance_type}"
  subnet_id     = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  root_block_device {
    volume_type = "${var.ebs_root_volume_type}"
    volume_size = "${var.ebs_root_volume_size}"
    delete_on_termination = "${var.ebs_root_delete_on_termination}"
  }

  tags = {
    Name = "Web"
  }

  user_data = <<EOF
#! /bin/bash
sudo groupadd -g 500 administrator
sudo useradd -g 500 -u 5000 administrator -d /home/administrator -s /bin/bash
sudo usermod -aG adm administrator
sudo mkdir -p /home/administrator/.ssh
sudo echo "${data.local_file.ssh-keygen.content}" >> /home/administrator/.ssh/authorized_keys
sudo chown -R administrator: /home/administrator
sudo echo "administrator ALL=(ALL) ALL" > /etc/sudoers.d/91-administrator
sudo echo "administrator:${var.administrator_password}" | chpasswd
sudo apt update -y
EOF
}

resource "local_file" "public_ip" {
  content = aws_instance.web_server.public_ip
  filename = "../ansible/inventories/webserver.ini"
  file_permission = "0644"
}