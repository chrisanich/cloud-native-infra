#!/usr/bin/env bash
set -euo pipefail

# Resolve to project root (one directory above this script)
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "→ Cleaning Terraform/OpenTofu local caches in $PROJECT_ROOT..."

# Safety prompt
read -r -p "⚠️  This will delete all .terraform/ and tfplan files. State files will be preserved. Continue? [y/N] " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
  echo "✖ Cancelled."
  exit 1
fi

# Remove all .terraform directories recursively
find "$PROJECT_ROOT/tofu" -type d -name ".terraform" -prune -exec rm -rf {} +

# Remove all tfplan files
find "$PROJECT_ROOT/tofu" -type f -name "tfplan" -exec rm -f {} +

echo "✔ Clean complete. State files (.tfstate) and lockfiles (.lock.hcl) preserved."
