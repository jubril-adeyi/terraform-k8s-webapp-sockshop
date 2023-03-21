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
* A script for creation of VPC, Subnets, route table and Internet gateways for the EKS cluster and nodes in /terrraform/vpc.tf and the security Groups in /terrraform/sg.tf
* Terraform script to define data sources provide neccesary privileges for the creation of the infrastructure located in /terraform/data.tf. 
* The creation of EKS cluster and Node group is executed using the /terraform/eks-cluster.tf file 
* And all neccesary variables used in the terraform scripts are in the terraform/variable.tf file and that concludes provisioning of infrastructure using terraform 
* Initialize Terraform 
``` bash 
terraform init
```
* Cd into /terraform and run terraform apply
``` bash 
terraform apply
```
* "terraform apply" creates the infrastructure 

### Argocd Application Deployment 
#### Argocd will be provisioned into the cluster that was created 

* The EKS cluster needs to added to the kubeconfig: open cloudshell on AWS console and run the following command 
```bash 
aws eks --region <aws-region> update-kubeconfig --name <eks-cluster-name>
```
* Kubectl comamands can now be used to interact with the cluster
* Create a Namespace for the Argocd application 
``` bash 
 kubectl create namespace argocd
 ```
 * Install Helm with the following commands: 
 ```bash 
 curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 > get_helm.sh
 chmod 700
 ./get_helm.sh
 ```
 ** run the following if Openssl errors are returned when trying to install Helm and try Installation again
 ```bash 
 sudo yum install openssl
 export VERIFY_CHECKSUM=falset./get_helm.sh
 ```
 
