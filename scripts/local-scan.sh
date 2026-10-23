#!/usr/bin/env bash
# Run all DevSecOps scans locally from a project root.
# Usage: ./local-scan.sh [image:tag]
set -uo pipefail

IMAGE="${1:-}"
FAILED=0

run() {
  local name="$1"; shift
  printf '\n=== %s ===\n' "$name"
  if "$@"; then
    echo "PASS: $name"
  else
    echo "FAIL: $name"
    FAILED=1
  fi
}

run "Secrets - Gitleaks" \
  docker run --rm -v "$PWD:/repo" ghcr.io/gitleaks/gitleaks:latest dir /repo

run "SAST - Semgrep" \
  docker run --rm -v "$PWD:/src" -w /src semgrep/semgrep \
  semgrep scan --metrics=off --error --config p/owasp-top-ten

run "Dependencies - Trivy" \
  docker run --rm -v "$PWD:/src" -v trivy-cache:/root/.cache/trivy aquasec/trivy:latest \
  fs --scanners vuln --severity HIGH,CRITICAL --exit-code 1 --ignore-unfixed /src

run "IaC - Checkov" \
  docker run --rm -v "$PWD:/src" bridgecrew/checkov -d /src --compact --quiet

if [ -n "$IMAGE" ]; then
  run "Image - Trivy" \
    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
    -v trivy-cache:/root/.cache/trivy aquasec/trivy:latest \
    image --severity HIGH,CRITICAL --exit-code 1 --ignore-unfixed "$IMAGE"
fi

echo
if [ "$FAILED" -eq 0 ]; then
  echo "All scans passed"
else
  echo "One or more scans failed"
  exit 1
fi
