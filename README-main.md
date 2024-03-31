# README.md

Designed by Team Terrafourm! This project has been completed by Ayub Ahmed,Rik Deakin, Alexander Nichols and Sahr Malik

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
* IAM: to give access to the EKS cluster
* Networking: which creates the VPC with public and private subnets
* Security Groups: this allows the EKS cluster to communicate with RDS
* EKS: Kubernetes cluster with adjustable node groups
* Database: which provisions the RDS database which stores the login data of the app’s users

## IAM
In order for the team to have access to one EKS cluster, we created IAM roles, users and a group which contains the necessary permissions to give access to EKS. This allows each team member to work on the CI/CD pipeline from their own respective machines. 

Whenever the infrastructure has been created, a new oidc link for EKS will need to be copied into line 8 of the main.tf file in the IAM module. This will give access to the newly created EKS cluster for all users.

## ECR
Our Docker images are hosted on Amazon’s container registry.


## EKS
Insert text here


## RDS
Insert text here


## HELM
Insert text here


## CIRCLECI
Insert text here


## ARGOCD
Insert text here
