# README.md

Designed by Team Terrafourm! This project has been completed by Ayub Ahmed, Rik Deakin, Alexander Nichols and Sahr Malik

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
An EKS cluster will be deployed using the Terraform code. Our full-stack web application will be deployed and running on our EKS cluster with a front-end node and a back-end node.


## RDS
A database instance will also be deployed by our Terraform code. The database is used to store user credentials upon registration, and will be used for authentication upon login. The database will have a connection with our app on the EKS cluster by allowing connections via a security group (opening port 5432).


## HELM
We refactored the Kubernetes deployment and Service yaml files to be Helm charts. We found this to be more organized approach to customizing the configuration files and to create reusable configurations to use across multiple deployments. 


## CIRCLECI
CircleCI is what we will be using for continuous integration. Whenever we make any changes to this repository, CircleCI will run builds and tests, if everything passes, the updated Docker images will be pushed to ECR.

The working directories in the circleci config.yaml files will need to be changed to match your repository, as well as the ECR repositories and alias. 


## ARGOCD
Insert text here


## Prometheus / Grafana
Insert text here
