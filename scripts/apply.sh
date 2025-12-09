#!/usr/bin/env bash
set -euo pipefail
terraform apply -var-file="global.tfvars" -auto-approve
