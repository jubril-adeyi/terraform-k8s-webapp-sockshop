# Deployment of a nginx web-app and the sock-shop app with neccesary dependencies using kubernetes as microservice orchestration tool, and Terraform as IAC tool for the creation of kubernetes (Amazon EKS) Infrastructure and the required resources. Helm chart was also used in creation of resources.
# Using ArgoCD and Github for Continous delivery of the Kubernetes resources and Prometheus and Grafana for monitoring and Visualization of Metrics. 
## Prerequisites
* AWS account
* AWS CLI (configured) 
* Terraform 
* Helm 
* Kubernetes
* Argocd 
* Github
* Docker (Dockerizing nginx web-app) 
* Nginx 
## Deployment of Infrastructure 
### The Kubernetes infrastucture (EKS Cluster and nodes) and all neccesary dependencies (VPC and network setup)  were created Using Terraform.  
#### STEPS
* Create A directory and clone an already created github repository that will be used for entire Deployment process
* Create an IAM user in AWS account with neccesary priviledges
* Install and configure AWS CLI, Inputing credentials for IAM user  
``` bash 
aws configure
````
$ AWS Access Key ID [None]: <YOUR_AWS_ACCESS_KEY_ID>

$ AWS Secret Access Key [None]: <YOUR_AWS_SECRET_ACCESS_KEY>

$ Default region name [None]: <YOUR_AWS_REGION>

$ Default Output Format [None]: <YOUR_DESIRED_OUTPUT_FORMAT>

#### Terraform Configuration 

* The terraform scripts located in the /terraform directory contains terraform scripts that Imports the required Providers (/terraform/providers.tf).
* A script for creation of VPC and Subnets for the EKS cluster and nodes in /terrraform/vpc.tf and the security Groups in /terrraform/sg.tf
* Terraform script to provide neccesary privileges for the creation of the infrastructure located in /terraform/data.tf. 
* Initialize Terraform 
``` bash 
terraform init
```
* Apply terraform script located in /terraform
``` bash 
terraform apply
```
* 
