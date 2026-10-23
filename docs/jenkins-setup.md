# Jenkins Setup

## 1. Docker access for the agent

```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

## 2. Required plugins

Pipeline, Docker Pipeline, Git, Credentials Binding, JUnit.
Most come with the default "suggested plugins" install.

## 3. Required credential

Create a credential of type **Username with password** with the ID `registry-creds`
for your container registry.

## 4. Job type

Use a **Multibranch Pipeline**. The `when { branch 'main' }` condition only works
in that job type.

## 5. Placeholders to change in each Jenkinsfile

| Variable | Example |
|---|---|
| `REGISTRY` | `registry.example.com` |
| `IMAGE` | `registry.example.com/my-app` |
| `STAGING_URL` | `https://staging.example.com` |

Also change the entrypoint in the Dockerfile (`server.js`, `app.py`, `MyApp.dll`).

## 6. Notes

- Single quotes in `sh '''...'''` are deliberate: the shell expands variables, not Groovy,
  so secrets never leak into build logs.
- The DAST stage assumes the app is already deployed to staging. Add your deploy step before it.
