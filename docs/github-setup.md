# GitHub Setup

## 1. Create and push the repo

```bash
git init -b main
git add .
git commit -m "Initial DevSecOps toolkit"
gh repo create devsecops-toolkit --private --source=. --push
```

## 2. Protect `main`

Requires branch protection on your plan. On GitHub Free it works only on public repos.
Replace `YOUR_USER_OR_ORG` with your GitHub username or organization.

```bash
gh api -X PUT repos/YOUR_USER_OR_ORG/devsecops-toolkit/branches/main/protection \
  -H "Accept: application/vnd.github+json" \
  --input - <<'EOF'
{
  "required_status_checks": null,
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "require_code_owner_reviews": true
  },
  "restrictions": null
}
EOF
```

## 3. Security settings

Turn on **Settings → Code security → Secret scanning + Push protection**, if your plan offers them.

## 4. Update CODEOWNERS

Replace `@YOUR_ORG/devops` and `@YOUR_ORG/security` in `.github/CODEOWNERS`
with your real teams or usernames.
