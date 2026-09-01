# 🚀 AWS Multi-Tier Web Architecture

![AWS](https://img.shields.io/badge/AWS-EC2%20%7C%20VPC%20%7C%20ALB-orange?logo=amazon-aws&logoColor=white)
![Status](https://img.shields.io/badge/status-completed-brightgreen)
![High Availability](https://img.shields.io/badge/high--availability-2%20AZs-blue)

> A highly available, fault-tolerant, auto-scaling web architecture deployed on AWS — built as a hands-on capstone project.

📅 **Completed:** September 2026

---

## 📌 Overview

This repository documents the design and deployment of a highly available, fault-tolerant web architecture on **Amazon Web Services (AWS)**. The infrastructure automatically scales compute capacity based on traffic demand while ensuring seamless load distribution across multiple Availability Zones (AZs).

This project was built to demonstrate practical, real-world AWS skills — covering custom VPC design, NAT routing, secure access with IAM/SSM, load balancing, and Auto Scaling.

---

## 🏗️ Architecture Diagram

<img width="1195" height="681" alt="Screenshot 2026-09-01 123740" src="https://github.com/user-attachments/assets/11c87419-afdd-4480-8635-03385465da64" />


The architecture spans **two Availability Zones**, each containing one public subnet and one private subnet. Public subnets host NAT Gateways and receive traffic from an Internet Gateway. Private subnets host the application servers, which are only reachable through the Application Load Balancer.

---

## ⚙️ Technologies & Services Used

| Service | Role in this project |
|---|---|
| **Amazon VPC** | Custom network (`10.0.0.0/16`) with public and private subnets across two AZs |
| **Internet Gateway** | Provides internet access to public subnet resources |
| **NAT Gateways (x2)** | Let private-subnet instances reach the internet without being exposed |
| **Amazon EC2** | EBS-backed instances (Amazon Linux 2023) running the web/app tier |
| **IAM Role (`ec2tossm`)** | Grants SSM access — no SSH keys required |
| **Application Load Balancer** | `WebALB` — distributes HTTP traffic across all instances |
| **Target Group** | `WebTG` — performs health checks, routes only to healthy targets |
| **Auto Scaling Group** | `ASG` — maintains availability (min: 2, desired: 4, max: 6) |
| **Security Groups** | `WebSG` (HTTP from ALB only), `ALBSG` (HTTP from anywhere) |

---

## 🎯 Key Features

- ✅ High availability across 2 Availability Zones
- ✅ Auto Scaling with health-check-based instance replacement
- ✅ Least-privilege security groups (`WebSG` only accepts traffic from `ALBSG`)
- ✅ Private subnets for backend servers — outbound-only internet access via NAT
- ✅ No SSH keys required — access handled securely through SSM
- ✅ Fault-tolerant web tier with zero single point of failure

---

## 🛠️ Bootstrapping Script (User Data)

Each instance is configured automatically on launch, installing and starting an Apache web server:

\`\`\`bash
#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "This is an app server in AWS Region US-EAST-1" > /var/www/html/index.html
\`\`\`

---

## 🧪 How It Was Tested

**1. Verified Apache was active on each instance** (via SSM Session Manager, no SSH key needed):
\`\`\`bash
sudo systemctl status httpd
\`\`\`

**2. Verified each instance served content locally:**
\`\`\`bash
curl http://<instance-private-ip>
\`\`\`

**3. Confirmed all targets in `WebTG` were Healthy:**

<img width="2128" height="1080" alt="Screenshot 2026-09-01 124516" src="https://github.com/user-attachments/assets/d415b4bc-c656-4677-98ac-db0fc399ce89" />


**4. Hit the ALB's DNS name repeatedly and confirmed traffic was load-balanced:**

| Request 1 — routed to server 2 | Request 2 (refreshed) — routed to server 1 |
|:---:|:---:|
| <img width="751" height="135" alt="Screenshot 2026-09-01 130209" src="https://github.com/user-attachments/assets/cf81c338-ddce-4bbe-bf8e-16acbcae34ef" />
 | <img width="753" height="133" alt="Screenshot 2026-09-01 130236" src="https://github.com/user-attachments/assets/9cf5e126-c686-4746-ac49-1965b4ebabae" />
 |

Refreshing the page repeatedly shows requests landing on different instances — confirming the Application Load Balancer is distributing traffic correctly.

**5. Verified Auto Scaling replaced instances correctly** after terminating the originals, and new instances registered as healthy targets automatically:

<img width="1281" height="256" alt="Screenshot 2026-09-01 130922 - Copy (2)" src="https://github.com/user-attachments/assets/629f47ef-abbd-4083-b190-1cc62bf44e14" />


---

## 🔒 Security Considerations

- `WebSG` allows inbound HTTP (80) **only from `ALBSG`** — instances are never reachable directly from the internet.
- `ALBSG` allows inbound HTTP (80) from any source, since the ALB is the intended public entry point.
- EC2 instances launch **without SSH key pairs** — all admin access goes through IAM-authenticated SSM sessions.
- Private subnets have no direct route to the Internet Gateway — all outbound traffic passes through NAT Gateways.

---

## 👤 Author

**Hamza Al-Akhter**
Software Engineering Student — Taibah University

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin)](https://www.linkedin.com/in/hamza-alkthery-389614356/)
