# WordPress_ALB_Monitoring

![Wordpress](/picture/Capstone_Project.jpg)


Transforming WordPress experience with cutting-edge solution, leveraging AWS EC2 instances, ALB, ASG, RDS, CloudWatch, SNS, CloudTrail, and S3. Harness the power of scalability and high availability while optimizing resource management. Crafted with Terraform, python and Git, this solution ensures seamless integration, all managed effortlessly through VS Code. Elevate performance and reliability with resilient architecture, backed by industry-leading technologies.

### The solution would use the following tools:

AWS: Amazon Web Services (AWS) is a cloud computing platform that offers a wide range of services, including compute, storage, networking, databases, analytics, machine learning, and artificial intelligence.

Terraform: Terraform is an open-source infrastructure as code (IaC) tool that can be used to automate the creation, management, and deployment of infrastructure on AWS.

Git: Git is a distributed version control system that is used to track changes to code and other files.

GitHub: GitHub is a hosting service for Git repositories. : Scalable and Fault-tolerant WordPress Website on AWS.

### Project Setup

WordPress is set up with RDS MySQL as the database.
PHP version used is greater than 7.4.

### Tools

Terraform and Python

Install Terraform from Terraform's official website.
Ensure Python 3 is installed on your system.


### Change in Keypair
To change the EC2 instance keypair (keyname), follow these steps:

Update the key_name variable in the terraform.tfvars file with the desired keypair name.
Reapply the Terraform configuration by running terraform apply.

### Change in IAM Role
To change the IAM role used by EC2 instances, follow these steps:

Update the instance_profile variable in the terraform.tfvars file with the ARN of the desired IAM role.
Reapply the Terraform configuration by running terraform apply.

### Notes

For security purposes, ensure that your AWS credentials are securely stored and never committed to version control.
Regularly monitor the resources created by this solution to optimize costs and performance.
Consider implementing backup and disaster recovery mechanisms for the RDS instance to enhance data resilience.