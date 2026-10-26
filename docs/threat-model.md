# 🛡️ Enterprise Threat Model: Azure Landing Zone

**Document Version:** 2.4.0  
**Framework:** STRIDE (Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege)  
**Target:** Hub-and-Spoke Enterprise Network & Key Vault Perimeter

---

## 1. Scope & System Architecture

This threat model evaluates the Infrastructure as Code (IaC) deployment for mission-critical enterprise workloads spanning:
- Virtual Network topology & Subnet Segmentation (`10.100.0.0/16`)
- Azure Key Vault with Customer-Managed Keys (CMK)
- Linux VM Scale Sets across Multi-Availability Zones
- Network Security Group (NSG) Ingress/Egress Perimeter

---

## 2. Threat Analysis Matrix (STRIDE)

| Threat Category | Asset at Risk | Attack Vector | Mitigating IaC Control | Residual Risk |
| :--- | :--- | :--- | :--- | :--- |
| **Spoofing** | Azure Key Vault Secrets | Malicious service pretending to be backend API | `network_acls` block public access; Private Endpoints + Managed Identity token exchange. | **LOW** |
| **Tampering** | Route Tables (UDR) | Attacker modifies `0.0.0.0/0` next-hop to bypass inspection | Azure Policy audit/deny on Route Table changes; Terraform remote state lease locking. | **LOW** |
| **Repudiation** | Key Vault Access | Unlogged secret read operations | Diagnostic Settings stream logs directly to immutable Log Analytics Workspace. | **LOW** |
| **Information Disclosure** | Data at Rest / In Transit | Unencrypted VM data disks or plain-text state file | Disk encryption with CMK; Terraform state encrypted via Azure Storage Account blob leases. | **VERY LOW** |
| **Denial of Service** | Application Tier VMSS | Volumetric Layer 7 or Layer 4 DDoS attacks | Multi-Zone VMSS distribution (`zones = ["1","2","3"]`) + Azure DDoS Protection Standard. | **LOW** |
| **Elevation of Privilege** | IAM Roles on Compute | Compromised VM escalating to subscription owner | Principle of Least Privilege: VMs use scoped User-Assigned Managed Identity without Owner rights. | **VERY LOW** |

---

## 3. Policy Enforcement & Compliance Verification

- **Checkov Scan:** Enforced in CI/CD pipeline to reject unencrypted storage and overly permissive NSGs.
- **CIS Azure Foundations Benchmark:** Level 2 compliance verified before promotion to production.