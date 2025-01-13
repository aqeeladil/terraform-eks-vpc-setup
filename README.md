# Creating an AWS EKS (Elastic Kubernetes Service) cluster with a VPC (Virtual Private Cloud) using Terraform.

#### Workflow

- **VPC Configuration:** Contains details for creating a VPC, subnets, gateways, security configurations and other network components.

- **EKS Cluster Configuration:** Contains details for setting up the EKS cluster within the VPC, including autoscaling configurations for worker nodes.

- **Configure Security Groups:** Control traffic into and out of the EKS cluster.

- **Deploy Using Terraform:** Automate the entire setup and verify it.

- **Grant Permissions:** Access the cluster securely.

## Step 1: Set Up the EC2 Instance

- Use an Ubuntu (latest LTS) Instance.
- Select an instance type (e.g., t2.micro for cost-effectiveness).
- Ensure the instance has IAM Role with the necessary permissions.
- Allow ports `22` (SSH), `80` (HTTP).
- Connect to the EC2 Instance:
    `ssh -i <your-key.pem> ubuntu@<ec2-ip>`

## Step 2: Install Required Tools

```bash
# Update Packages
sudo apt update && sudo apt upgrade -y

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

# Configure awscli (Obtain ```Access-Key-ID``` and ```Secret-Access-Key``` from the AWS Management Console).
aws configure

# Install Terraform
sudo apt install -y software-properties-common gnupg curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
terraform version

# Install kubectl
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.25.6/2023-04-26/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --client
```

## Step 3: Directory Layout

```
terraform-eks/
├── versions.tf        # Required versions for Terraform code
├── variables.tf       # Input variables
├── outputs.tf         # Outputs from the infrastructure
├── vpc.tf             # VPC module configuration
├── eks-cluster.tf     # EKS module configuration
├── security-groups.tf # Security groups for the cluster
```

## Step 4: Execution

```bash
terraform init
terraform plan
terraform apply
```

## Step 5: Accessing the EKS Cluster

```bash
# Grant Access: Add permissions in the AWS Console under the cluster's Access tab.

# Update Kubeconfig: Connect your local kubectl to the cluster:
# aws eks update-kubeconfig --name <cluster-name> --region <region>
aws eks update-kubeconfig --name my-eks-0123HT --region us-west-1

# Verify Nodes:
kubectl get nodes

# To avoid unnecessary charges, destroy the resources after testing:
terraform destroy
```

## Step 6: Debugging Tips

- **Terraform Issues:**

    - Check `.tfstate` file for resource status.
    - Ensure the IAM role has sufficient permissions.

- **AWS CLI or kubectl Errors:**

    - Verify AWS credentials using `aws sts get-caller-identity`.
    - Confirm kubectl connectivity using `kubectl cluster-info`.

- **Infrastructure Not Found:**

    - Check the AWS Management Console for created resources under the specified region.