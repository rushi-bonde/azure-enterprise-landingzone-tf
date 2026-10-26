# 📖 Operations Runbook: Azure Enterprise Landing Zone

**Target Environment:** Production (`prod`)  
**SLA Target:** 99.99% Availability | RTO < 30m | RPO < 15m

---

## 1. Routine Operational Workflows

### 1.1 Local Plan & Dry Run
```bash
cd environments/prod
terraform init -backend-config="backend.tf"
terraform plan -var-file="terraform.tfvars" -out=tfplan.binary
```

### 1.2 Automated Drift Reconciliation
Nightly CI/CD pipelines run scheduled plan comparisons:
```bash
terraform plan -detailed-exitcode
# Exit code 0 = No drift
# Exit code 2 = Drift detected (Triggers PagerDuty / SRE alert)
```

---

## 2. Emergency Incident Playbooks

### 2.1 State Lock Resolution (Error 409: Blob Already Leased)
If a pipeline crashes mid-apply and leaves an Azure Blob lease locked:
1. Verify no concurrent CI job is active.
2. Break the blob lease using Azure CLI:
   ```bash
   az storage blob lease break \
     --blob-name "landingzone.prod.terraform.tfstate" \
     --container-name "tfstate" \
     --account-name "sttfstateprod01"
   ```
3. Re-run `terraform refresh` to synchronize state with live cloud reality.

### 2.2 Rollback Procedure (Emergency Revert)
1. Identify last stable Git commit SHA: `git log --oneline -n 5`.
2. Checkout commit: `git checkout <STABLE_SHA>`.
3. Plan against live state: `terraform plan -out=emergency-rollback.tfplan`.
4. Peer approval from minimum 2 senior architects.
5. Apply: `terraform apply emergency-rollback.tfplan`.