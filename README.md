# 🩺 Self-Healing Infrastructure Demo

A Terraform-powered infrastructure demonstration featuring automated remediation using AWS Lambda. This project showcases how to design resilient cloud systems that recover from failure with minimal human intervention.

---

## 🧰 Tech Stack

- **Terraform** for infrastructure-as-code
- **AWS Lambda** for remediation logic
- **CloudWatch** & **SNS** for monitoring and alerting
- **GitHub** for version control & collaboration

---

## 📁 Project Structure

self-healing-infra-demo/ │ ├── infrastructure/ │   ├── main.tf │   ├── provider.tf │   ├── variables.tf │   ├── outputs.tf │ ├── remediation/ │   └── <Terraform modules/scripts for remediation logic> │ ├── lambda/ │   ├── health_check.py │   ├── restart_service.py │   └── ... (other remediation handlers) │ └── README.md


---

## 🚀 Getting Started

### 1. Clone the repo:
```bash
git clone https://github.com/kuurbe/self-healing-infra-demo.git

2. Navigate to the root folder:
cd self-healing-infra-demo

3. Initialize Terraform:
terraform init

4. Review the plan:
terraform plan

5. Deploy:
terraform apply

 Note: Don't commit terraform.tfstate files — consider configuring a remote state backend like S3 for production use.

Self-Healing Strategy
This setup monitors key infrastructure components using CloudWatch alarms and triggers Lambda functions to automatically:
- Restart services
- Replace failed EC2 instances
- Notify admins via SNS
Custom remediation logic lives in the lambda/ folder and can be extended for other use cases.

Security & Best Practices
- Sensitive data is excluded from version control
- Uses least-privilege IAM roles
- Remote state highly recommended


