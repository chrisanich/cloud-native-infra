#!/usr/bin/env bash
set -euo pipefail
trap 'echo "Error on line $LINENO"; exit 1' ERR

ENV="${1:-dev}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../tofu/environments/hetzner/${ENV}" && pwd)"
cd "$ROOT"

echo "→ Decrypting secrets..."
HETZNER_TOKEN="$(SOPS_AGE_KEY_FILE="$HOME/.secrets/age.key" \
  sops --decrypt --extract '["hcloud_token"]' hetzner.enc.yaml)"
export HCLOUD_TOKEN="$HETZNER_TOKEN"

echo "HCLOUD_TOKEN is set: ${HCLOUD_TOKEN:0:4}…"

echo "→ Initializing OpenTofu..."
tofu init -input=false

echo "→ Running plan..."
tofu plan -out=tfplan

if [[ "${APPLY:-false}" == "true" ]]; then
  echo "→ Applying..."
  tofu apply -auto-approve tfplan
else
  echo "→ Plan created: tfplan. Use APPLY=true to apply."
fi
