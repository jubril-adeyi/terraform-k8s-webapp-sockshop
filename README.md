# Deploying nginx web-app and sock-shop app on kubernetes on AWS EKS using Terraform. 
## Prerequisites
* AWS account IAM user with necessary permissions for resource provisioning. 
* AWS CLI 
* Terraform 
* Helm 
* Kubernetes
* Argocd 
* Github
* Docker
* Nginx 
## Deployment of Infrastructure 
### The Kubernetes Infrastucture (EKS Cluster and nodes) and all neccesary dependencies (VPC and network setup)  were created Using Terraform.  
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

## Argocd Application Deployment 
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
 * Now with helm installed; add the argocd helm repo, into the same namespace 
 ```bash
 helm repo add argo-cd https://argoproj.github.io/argo-helm -n <argo-cd-namespace>
 ```
 * Proceed to Installing argocd using helm 
 ``` bash 
  helm install argocd argo-cd/argo-cd -n <argo-cd-namespace>
 ```
 * Use the command below to confirm installation of argocd and the status of the argocd pods using kubectl 
 ``` bash 
  kubectl get pods -n <argo-cd-namespace>
  ```
 * An argocd service; argocd-server is automatically created on installation of the argocd app, this service needs to be exposed as LoadBalancer to be accessible over the internet 
 ``` bash 
  kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}' -n <argo-cd-namespace>
  ```
 * To generate login password for the default argocd user;admin, generated from the argocd kubernetes secret resource 
```bash 
 kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d; echo -n <argo-cd-namespace>
 ```
* To Generate the looadbalancer url Details of the argocd-server service 

```bash 
 kubectl get svc -n <argo-cd-namespace>
 ```
 ** Now the generated loadbalancer url can be dialed in browser and it directs to the argocd login page where we login using usernme: 'admin' and the password generated by the argocd kubernetes secret resource. 
 
 * After logging in, commence with the provisioning of the apps using argo cd  

### Argocd SETUP 
#### Connect Argocd to git repository 
* On the argocd page open the repository management menu and select "repositories" 
* Connect to the git repository using https: copying the link from Github
* click on 'connect' to add the repository 
#### Configure the Argocd root app 
* On the app creation page, click on "new app" 
* Fill the form with the details : 
  *  APP NAME : root
  *  PROJECT : default
  *  SYNC POLICY : automatic 
  *  SYNC OPTIONS : auto create namespace 
  *  CLUSTER : https://kubernetes.default.svc
  *  REPO URL : <git-repo-url> 
  *  PATH : <path-containing-app-yaml> 
  *  REVISION : HEAD
* Click on "Create" 
 
#### Proceed with deployment of apps using Argocd and Helm Charts 
* This Git repository contains the manifests for deploying the apps; web-app, grafana and prometheus in /argocd-apps directory. 
* The manifests file for the sock-shop app is located in the /sock-shop-manifests diorectory 
* Argocd is configured to fetch these manifests and use helm to provision all the resources defined in these manifests.
* In ArgoCD, Syncronize with git repository by clicking on "Sync" and the deployment of the app is effected so that it matches the configuration and the state defined in the manifests in the git repository.
 
