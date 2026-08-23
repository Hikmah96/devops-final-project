# DevOps Modern End-to-End Deployment

## Project Overview

This project demonstrates an end-to-end DevOps workflow using AWS, Terraform, Ansible, Docker, Docker Compose, GitHub Actions, Git, Java, and Apache Tomcat.

## Architecture

Developer -> GitHub -> GitHub Actions -> Terraform -> AWS EC2 -> Ansible -> Docker Compose -> Portfolio App + Java App

## Infrastructure

Terraform provisions the VPC, public subnet, Internet Gateway, route table, security group, and EC2 instance.

## Applications

Portfolio application: http://EC2_PUBLIC_IP:8080

Java application: http://EC2_PUBLIC_IP:8081/sampleapp/

## Ansible

Ansible installs Docker, Java, Git and Docker Compose, clones the project, builds the Docker images, starts the containers, and verifies their status.

## CI/CD

GitHub Actions automatically runs Terraform, builds Docker images, tests the Ansible connection, and deploys the applications with Ansible whenever changes are pushed to the main branch.

## Project Structure

- .github/workflows/deploy.yml
- ansible/inventory
- ansible/playbook.yml
- portfolio/
- java-app/
- compose.yaml
- main.tf
- README.md

## Result

The project provides an automated end-to-end DevOps deployment using Infrastructure as Code, Configuration Management, Containerization, and CI/CD.
