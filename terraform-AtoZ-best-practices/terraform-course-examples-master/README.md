# Terraform examples from YouTube course

Based on this [YouTube](https://www.youtube.com/playlist?list=PL8HowI-L-3_9bkocmR3JahQ4Y-Pbqs2Nt) series.

The examples in this repo range from the very basics of creating an ec2 instance in AWS to creating workspaces and modules.

## Important concepts

1. What happens when multiple engineers start deploying infrastructure using the same state file? - **State Locking**
- “state locking": mechanism that prevents operations on a specific state file from being performed by multiple users at the same time. 
- Once the lock from one user is released, any other user who has taken a lock on that state file can operate on it. This aids in the prevention of state file corruption
- It is important to note that not all Terraform Backends support the state locking feature. You should choose the right backend if this feature is a requirement.

2. null resource in Terraform
- A terraform null resource is a configuration that runs like a standard terraform resource block but does not create any resources.
- when: it can be useful in various situations to work around limitations in Terraform.

3. How can you use the same provider in Terraform with different configurations?
- By using alias argument in the provider block.

4. What happens if a resource was created successfully in terraform but failed during provisioning?
- **the resource is marked as tainted** and can be recreated by restarting the terraform run.

## Important quetions 
https://geekflare.com/terraform-interview-questions-and-answers/
