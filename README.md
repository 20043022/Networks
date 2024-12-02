# Automated cloud Deployment with Terraform, Ansible, Docker, and GitHub Actions

#Overview
This project demonstrates an automated deployment pipeline for a cloud-based application on an Azure cloud platform utilizing tools like terraform, ansible, docker and github actions, it provides an efficient way for hosting web application, ensuring that each component of the infrastructure and application are running constantly. 

# Step - 1 Terraform

terraform init
terraform plan
terraform apply

after the creation of VM, retrieve the public IP of the Azure VM to update the Ansible inventory file.

# Step - 2 Ansible

ansible-playbook -i inventory.ini docker-setup.yml

This playbook installs docker and configures the VM environment

# Step - 3 Docker

A Dockerfile is used to develop a container image of the sample application, python file is also created for hosting the sample application.

# Step - 4 Set up CI/CD pipeline with GitHub Actions

The GitHub Actions workflow automatically builds and deploys the application upon code push to the main branch. All the application code are compressed. 

# Directory

1. terraform - terraform scripts for provisioning
2. ansible - ansible playbooks and inventory
3. app - application code and dockerfile
4. github - github actions CI/CD pipeline



