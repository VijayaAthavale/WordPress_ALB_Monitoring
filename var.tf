
#Public CIDR
variable "CIDR_BLOCK" {
 default =  "0.0.0.0/0"
}
#VPC CIDR
variable "VPC_CIDR" {
    default =  "10.0.0.0/16"
}
#Public Subnet CIDR
variable "PUBLIC_SUBNET_CIDR" {
    default =  "10.0.1.0/24"
}   
#Private Subnet CIDR
variable "PRIVATE_SUBNET_CIDR" {
    default =  "10.0.2.0/24"
}
#Public Subnet CIDR
variable "PUBLIC_SUBNET_CIDR2" {
    default =  "10.0.3.0/24"
}
#Private Subnet CIDR
variable "PRIVATE_SUBNET_CIDR2" {
    default =  "10.0.4.0/24"
}
#AWS Region
variable "AWS_REGION" {
    default =  "us-west-2"
}
#AWS Profile
variable "AWS_PROFILE" {
    default =  "default"
}

#AWS Avalibitly Zone
variable "AWS_AZ1" {
    default =  "us-west-2a"
}
#AWS Avalibitly Zone 2
variable "AWS_AZ2" {
    default =  "us-west-2b"
}

/* #AMI ID
variable "AMIs" {
  type = map(string)
  description = "Region specific AMI"
  default = {
  #us-west-2 = "ami-052c9ea013e6e3567"

   }
}
variable "AmiId" {
  default = "ami-0895022f3dac85884"
} */

#Instance Type
variable "INSTANCE_TYPE" {
    default =  "t2.micro"
}
#Key Name
variable "KEY_NAME" {
    default =  "vockey"
}

# SNS email id variable
variable "EMAIL_ID" {
  description = "SNS email id"
}
# Role
variable "LabRoleARN" {
  description = "Lab Role"
  default     = "arn:aws:iam::891377082491:role/LabRole"
}

# Variables for RDS DB instance

variable "rds_username" {
  description = "The username for the RDS instance"
}
variable "rds_password" {
  description = "The password for the RDS instance"
  sensitive   = true
}
variable "rds_db_name" {
  description = "The name of the database"
  default     = "wordpressDb"
}








