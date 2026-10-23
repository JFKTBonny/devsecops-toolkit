#!/usr/bin/env bash
# Sign and verify a container image with Cosign (keyless, GitHub OIDC).
# Usage: ./cosign-sign-verify.sh registry.example.com/myapp@sha256:<digest> YOUR_ORG
set -euo pipefail

[ $# -eq 2 ] || { echo "Usage: $0 <image@sha256:digest> <github-org>"; exit 1; }
IMAGE_REF="$1"
ORG="$2"

cosign sign --yes "$IMAGE_REF"

cosign verify "$IMAGE_REF" \
  --certificate-identity-regexp "https://github.com/${ORG}/.*" \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
