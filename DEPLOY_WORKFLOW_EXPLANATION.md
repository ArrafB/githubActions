# Deep Dive: The Staging/Production Deployment Workflow

This document provides a technical breakdown of the `salesforce-deploy.yml` GitHub Action workflow. It is designed to be used as a reference when explaining the deployment pipeline architecture to the team.

---

## 1. Trigger Mechanism (The "When")

```yaml
on:
  push:
    branches: ["main", "master"]
```

**Explanation for the team:**
Unlike the PR Validation workflow (which runs when a PR is opened), this workflow _only_ triggers when code is merged into the `main` or `master` branch. This enforces a strict policy: no code can be deployed to production or staging unless it has gone through the Pull Request review process and been officially merged.

---

## 2. Setting Up the Environment (The "Where")

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
```

**Explanation for the team:**
GitHub spins up an isolated, temporary Ubuntu Linux server for every deployment. The `actions/checkout` step pulls our Salesforce codebase onto that server. The `fetch-depth: 0` argument is critical here—it downloads the entire Git commit history, which we need later to compare versions for our Delta deployment.

---

## 3. Installing Dependencies (The "Tools")

```yaml
- name: Install Salesforce CLI
  run: npm install -g @salesforce/cli

- name: Install SFDX Git Delta
  run: echo y | sf plugins install sfdx-git-delta
```

**Explanation for the team:**
The Ubuntu server starts blank. In these steps, we install the official **Salesforce CLI** (which acts as our pipeline's brain) and the **SFDX Git Delta** plugin, which is an enterprise standard for optimizing Salesforce deployments.

---

## 4. The Delta Generation (The "What")

```yaml
- name: Generate Delta (Changed Files Only)
  run: |
    mkdir changed-sources
    sf sgd:source:delta --to "HEAD" --from "HEAD^" --output changed-sources/ --generate-delta
```

**Explanation for the team:**
This is the most critical optimization in the pipeline. Instead of deploying the entire repository (which could take hours in a large org), this step compares the newly merged commit (`HEAD`) with the commit right before it (`HEAD^`). It figures out exactly which specific files were modified or added, and creates a customized `package.xml` manifest containing _only_ those files. This turns hour-long deployments into 30-second deployments.

---

## 5. Secure Authentication (The "Keys")

```yaml
- name: Authenticate to Salesforce Org
  run: |
    echo "${{ secrets.SFDX_AUTH_URL }}" > sfdx_auth.txt
    sf org login sfdx-url --sfdx-url-file sfdx_auth.txt --set-default --alias my-dev-org
    rm sfdx_auth.txt
```

**Explanation for the team:**
We cannot use standard usernames and passwords in an automated pipeline. Instead, we use an **SFDX Auth URL**, which is securely stored as an encrypted Secret in GitHub. This step writes that secret to a temporary file, logs into Salesforce via the CLI, and then immediately deletes the file so it is never exposed in the logs.

---

## 6. The Atomic Deployment (The "Action")

```yaml
- name: Deploy Code and Run Tests
  run: |
    sf project deploy start \
      --manifest changed-sources/package/package.xml \
      --target-org my-dev-org \
      --test-level RunSpecifiedTests \
      --tests HelloWorldTest \
      --wait 10
```

**Explanation for the team:**
This is the final execution step.

1. It uses the `changed-sources/package/package.xml` we generated earlier to deploy _only_ the delta.
2. It performs an **Atomic Transaction**. We pass the testing flags (`--test-level`) directly into the `deploy` command. This tells Salesforce to run the tests _during_ the deployment process. If the Apex tests fail in the target org, Salesforce automatically rolls back the entire deployment.
3. The `--wait 10` flag ensures the action won't time out if Salesforce is experiencing temporary lag.
