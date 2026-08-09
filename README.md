# DevOps CI/CD Pipeline

This project demonstrates a basic CI/CD pipeline for deploying a static website. The main technologies used in this project are Git, AWS, Docker, Jenkins, and Terraform.

[Watch Demo on YouTube](https://youtu.be/5gz7OPxu_SI?si=HDWbQ7UwJoHvlF4m)

- GitHub receives the code changes and triggers the workflow.
- A webhook sends the push event to a local Jenkins instance exposed through Ngrok.
- Jenkins runs a freestyle job to build the application and package it into a Docker image.
    - The image is pushed to Amazon ECR.
    - Terraform creates an EC2 instance and provisions the infrastructure needed for deployment.
    - The EC2 instance pulls the latest image from ECR, runs it in a container, and serves the site publicly.

- Jenkins uses IAM user access keys to perform actions in AWS.
- Terraform stores its state in an S3 backend.
- This repository includes Jenkins pipeline scripts, but this setup uses the freestyle job instead.
