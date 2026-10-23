# DevSecOps Guide

**DevSecOps** means building security into every stage of the DevOps pipeline,
automatically, so security checks run as code on every commit instead of as a
manual review at the end.

## 1. Core principles

- **Shift left:** catch issues early (in the IDE, on commit, in the PR), where fixes are cheapest.
- **Automate everything:** security checks run in CI/CD, not in spreadsheets.
- **Fail fast:** block builds on HIGH or CRITICAL findings, and only warn on the rest.
- **Least privilege:** apply it to pipelines, containers, cloud roles, and tokens.
- **Everything as code:** infrastructure, policies, and pipelines are all versioned and reviewed.
- **Shared ownership:** developers own the fixes, and security provides tools and guardrails.

## 2. Pipeline stages and tools

| Stage | Check | What it finds | Common tools |
|---|---|---|---|
| Pre-commit | Secret scanning | Leaked keys and passwords | Gitleaks, TruffleHog |
| Build | SAST | Insecure code patterns | Semgrep, SonarQube, CodeQL |
| Build | SCA | Vulnerable dependencies | Trivy, Snyk, OWASP Dependency-Check |
| Build | IaC scan | Cloud and Kubernetes misconfigurations | Checkov, tfsec, KICS |
| Package | Container scan | Image CVEs | Trivy, Grype |
| Package | SBOM and signing | Supply-chain integrity | Syft, Cosign |
| Test | DAST | Runtime vulnerabilities | OWASP ZAP, Burp |
| Deploy | Policy as code | Non-compliant deployments | OPA/Gatekeeper, Kyverno |
| Runtime | Monitoring | Attacks and anomalies | Falco, SIEM |

## 3. Pre-commit hooks

```bash
pip install pre-commit
pre-commit install
pre-commit autoupdate
pre-commit run --all-files
```

## 4. Local scanning commands

```bash
# Secrets
docker run --rm -v "$PWD:/repo" ghcr.io/gitleaks/gitleaks:latest dir /repo -v

# SAST
docker run --rm -v "$PWD:/src" -w /src semgrep/semgrep semgrep scan --config auto

# Dependencies, secrets, misconfigurations
docker run --rm -v "$PWD:/src" aquasec/trivy:latest fs --scanners vuln,secret,misconfig /src

# Container image
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest image myapp:latest

# Terraform / Kubernetes / CloudFormation
docker run --rm -v "$PWD:/tf" bridgecrew/checkov -d /tf

# DAST
docker run --rm -t ghcr.io/zaproxy/zaproxy:stable zap-baseline.py -t https://example.com
```

Or run them all at once with `scripts/local-scan.sh`.

## 5. Handling findings

- **Checkov fails on any finding by default.** While tuning, add `--soft-fail`, then remove it once the baseline is clean.
- **Allowing a known finding:** add the CVE to `.trivyignore`, a `# nosemgrep` comment on the specific line, or `# nosec` for Bandit. Always give a reason.
- **Production hardening:** replace `:latest` scanner tags with fixed versions so builds stay reproducible.

## 6. Best-practice checklist

- Store secrets in a vault (HashiCorp Vault, AWS Secrets Manager), never in code or environment files.
- Use OIDC instead of long-lived cloud keys in CI.
- Pin GitHub Actions and base images to a SHA or digest, not `latest`, in production pipelines.
- Set `permissions: contents: read` by default in workflows.
- Protect `main` with required reviews and required status checks.
- Enable Dependabot or Renovate for automatic dependency updates.
- Generate an SBOM and sign every release image.
- Track findings centrally (DefectDojo, GitHub Security tab) with remediation SLAs, for example: Critical within 7 days, High within 30.
- Measure progress: mean time to remediate, open critical count, and the percentage of builds scanned.
