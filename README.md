# README.md

Designed by Team Terrafourm! This project has been completed by Ayub Ahmed, Rik Deakin, Alex Nichols and Sahr Malik

## Overview
This repository contains the Northcoders final group project. The objective was to deploy a full-stack web application to AWS cloud using the tools and technologies we have learned over the past 13 weeks. We aimed to follow DevOps principles, automate CI/CD pipelines and to create an infrastructure that is secure and scalable. 


* Technologies Used
* AWS
* Terraform (IaC)
* Docker 
* EKS (Elastic Kubernetes Service)
* ECS (Elastic Container Registry)
* Amazon RDS
* CircleCI
* ArgoGD
* Prometheus and Grafana

## Infrastructure
Our team used an IaC tool - Terraform in order to be able to deploy our infrastructure to the AWS cloud. We organized our Terraform code into modules to make it clean and easy to read. Our modules include:
* IAM: to give access to the EKS cluster (This module has been seperated into a different directory from the other modules. This is to prevent having to create new IAM user credentials upon each Terraform destroy/apply)
* Networking: which creates the VPC with public and private subnets
* Security Groups: this allows the EKS cluster to communicate with the RDS instance
* EKS: Kubernetes cluster with adjustable node groups
* Database: which provisions the RDS database which stores the login data of the application’s users

## IAM
In order for the team to have access to one EKS cluster, we created IAM roles, users and a group which contains the necessary permissions to give access to EKS. This allows each team member to work on the CI/CD pipeline from their own respective machines. 

Whenever the infrastructure has been created, a new oidc link for EKS will need to be copied into line 8 of the main.tf file in the IAM module. This will give access to the newly created EKS cluster for all users. 

Once the EKS cluster and IAM user have been created, you will need to modify the kube config file: 
```
kubectl edit -n kube-system configmap/aws-auth
```

Then, add in the users you want to give access: 
```
mapUsers: |
    - userarn: arn:aws:iam::{account-id of the parent account}:user/{IAM username of child account}
      username: {IAM username of child account}
      groups:
        - system:masters
 ```

The user will need to sign in to the CLI using the appropriate access and secret access keys, then change context to the EKS cluster: 
```
aws eks update-kubeconfig --name ce-cluster --region eu-west-2
```

## ECR
Our Docker images are hosted on Amazon’s container registry. One repository for the frontend image, and one for the backend image. 


## EKS
An EKS cluster will be deployed using the Terraform code. Our full-stack web application will be deployed and running on our EKS cluster with a front-end pod and a back-end pod. Our service type is a LoadBalancer, so if you want to increase the number of replicas, the load balancer will spread the traffic evenly. 


## RDS
A database instance will also be deployed by our Terraform code. The database is used to store user credentials upon registration, and will be used for authentication upon login. The database will have a connection with our app on the EKS cluster by allowing connections via a security group (opening port 5432).


## HELM
We refactored the Kubernetes deployment and Service yaml files to be Helm charts. We found this to be more organized approach to customizing the configuration files and to create reusable configurations to use across multiple deployments. 


## CIRCLECI
CircleCI is what we will be using for continuous integration. Whenever we make any changes to this repository, CircleCI will run builds and tests, if everything passes, the updated Docker images will be pushed to ECR.

The working directories in the circleci config.yaml files will need to be changed to match your repository, as well as the ECR repositories and alias. 


## ARGOCD
We too a GitOps approach to application deployment using ArgoCD. Our Kubernetes Helm charts are stored in our Git repository, and ArgoCD ensures that the clusters are in sync with our repo. 
First, you need to ensure that you are in the correct Kubernetes context:
```
aws eks update-kubeconfig --name ce-cluster --region eu-west-2
```
Next, create a seperate namespace for ArgoCD:
```
kubectl create namespace argocd
```
Then apply the YAML files associated with ArgoCD:
```
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
You can check if your ArgoCD pods are deployed by running:
```
kubectl get pods -n argocd
```
You should see something similar to:
```
NAME                                                READY   STATUS    RESTARTS   AGE
argocd-application-controller-0                     1/1     Running   0          78s
argocd-applicationset-controller-55c8466cdf-srbt7   1/1     Running   0          78s
argocd-dex-server-6cd4c7498f-9v8z4                  1/1     Running   0          78s
argocd-notifications-controller-65cddcf9d6-kq574    1/1     Running   0          78s
argocd-redis-74d77964b-x8bh6                        1/1     Running   0          78s
argocd-repo-server-96b577c5-8b6b8                   1/1     Running   0          78s
argocd-server-7c7b5568cc-b85v8                      1/1     Running   0          78s
```

You will need to obtain the password to log in to the ArgoCD user interface:
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```
Now you will use Kubernetes port forwarding to access the user interface:
```
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Now open up your browser and navigate to http://localhost:8080
Enter the username: admin
Enter the password received in the previous step and log in


## Prometheus / Grafana
Insert text here
