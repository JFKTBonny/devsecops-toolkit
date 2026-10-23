# DevSecOps Toolkit

Reusable security pipelines, Dockerfiles and policies for:
Spring Boot · Node.js · Python · .NET

## Pipeline

Secrets → Build & Test → SAST + SCA + IaC → Image build → Image scan → SBOM → Push → DAST

## Use it in a project

```bash
git clone https://github.com/YOUR_ORG/devsecops-toolkit.git
./devsecops-toolkit/scripts/new-project.sh python ../my-app
```

Supported stacks: `java-spring`, `node`, `python`, `dotnet`.

The script copies the files into your app repo and never overwrites existing files.
Afterwards, edit the placeholders it lists (registry, image name, staging URL, entrypoint).

Use either the `Jenkinsfile` or `.github/workflows/devsecops.yml` in each app,
depending on your CI, and delete the other.

## Scan locally

```bash
cd my-app
../devsecops-toolkit/scripts/local-scan.sh myapp:latest
```

Requires Docker. The image argument is optional.

## Contents

| Folder | Purpose |
|---|---|
| `templates/<stack>/` | Jenkinsfile + Dockerfile per framework |
| `templates/common/` | GitHub Actions workflow, ignore files, pre-commit |
| `kubernetes/` | Hardened Deployment manifest |
| `scripts/` | Project bootstrap, local scans, image signing |
| `docs/` | DevSecOps guide, Jenkins setup and checklist |

## First push

```bash
git init -b main
git add .
git commit -m "Initial DevSecOps toolkit"
gh repo create devsecops-toolkit --private --source=. --push
```

See `docs/github-setup.md` for branch protection and secret scanning.
