#!/usr/bin/env bash
set -euo pipefail
terraform destroy -var-file="global.tfvars" -auto-approve
