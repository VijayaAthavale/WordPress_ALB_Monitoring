locals {
  # The name of the EC2 instance
  name = "awsrestartproject"
  owner = "ds"
}

### Select the newest AMI

data "aws_ami" "latest_linux_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*x86_64"]
    
  }
}
# Create EC2
resource "aws_instance" "instance" {
  #ami = var.AmiId[var.AWS_REGION]
  #ami = "ami-052c9ea013e6e3567"
  ami = data.aws_ami.latest_linux_ami.id
  instance_type = "t2.micro"
  availability_zone = "us-west-2a"
  key_name = "vockey"
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.dev_sg.id]
  subnet_id = aws_subnet.dev_subnet.id
  count = 1

  tags = {
    Name = "ec2Wordpress"
  
  }

 

#user data
user_data = "${base64encode(data.template_file.ec2userdatatemplate.rendered)}"
provisioner "local-exec" {
  command = "echo Instance Type = ${self.instance_type}, Instance ID = ${self.id}, Public IP = ${self.public_ip}, AMI ID = ${self.ami} >> metadata"
 }
}
data "template_file" "ec2userdatatemplate"{
  template = "${file("userdata.tpl")}"

  vars = {
    rds_endpoint = replace("${aws_db_instance.db-instance.endpoint}",":3306","")
    rds_user = "${aws_db_instance.db-instance.username}"
    rds_password = "${aws_db_instance.db-instance.password}"
    rds_dbname = "${aws_db_instance.db-instance.db_name}"

  }

  
}
output "ec2rendered" {
  value = "${data.template_file.ec2userdatatemplate.rendered}"
}

output "public_ip" {
  value = aws_instance.instance[0].public_ip
}

 



