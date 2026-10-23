#!/usr/bin/env bash
# Copy DevSecOps templates into an application repo.
# Usage: ./scripts/new-project.sh <java-spring|node|python|dotnet> <target-dir>
set -euo pipefail

usage() {
  echo "Usage: $0 <java-spring|node|python|dotnet> <target-dir>"
  exit 1
}

[ $# -eq 2 ] || usage
STACK="$1"
TARGET="$2"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/templates/$STACK"
COMMON="$ROOT/templates/common"

[ -d "$SRC" ] || { echo "Unknown stack: $STACK"; usage; }

copy_if_missing() {
  local from="$1" to="$2"
  if [ -e "$to" ]; then
    echo "SKIP   $to (already exists)"
  else
    mkdir -p "$(dirname "$to")"
    cp "$from" "$to"
    echo "ADD    $to"
  fi
}

copy_if_missing "$SRC/Jenkinsfile"                       "$TARGET/Jenkinsfile"
copy_if_missing "$SRC/Dockerfile"                        "$TARGET/Dockerfile"
copy_if_missing "$COMMON/.dockerignore"                  "$TARGET/.dockerignore"
copy_if_missing "$COMMON/.pre-commit-config.yaml"        "$TARGET/.pre-commit-config.yaml"
copy_if_missing "$COMMON/.trivyignore"                   "$TARGET/.trivyignore"
copy_if_missing "$COMMON/.semgrepignore"                 "$TARGET/.semgrepignore"
copy_if_missing "$COMMON/github-actions/devsecops.yml"   "$TARGET/.github/workflows/devsecops.yml"
copy_if_missing "$ROOT/kubernetes/deployment.yaml"       "$TARGET/k8s/deployment.yaml"

echo
echo "Done. Now edit the placeholders:"
echo "  - Jenkinsfile:            REGISTRY, IMAGE, STAGING_URL"
echo "  - Dockerfile:             app entrypoint"
echo "  - k8s/deployment.yaml:    image digest"
echo "  - devsecops.yml:          TARGET_URL"
echo "Then run: cd $TARGET && pre-commit install"
