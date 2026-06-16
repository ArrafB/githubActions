# Real-World Salesforce CI/CD Demo Script

**Presenter Note:** _This demo takes about 5-7 minutes. Have your browser open with three tabs ready:_

1. _Your GitHub Repository Code tab (`https://github.com/ArrafB/githubActions`)_
2. _Your GitHub Actions tab (`https://github.com/ArrafB/githubActions/actions`)_
3. _Your Salesforce Dev Org (logged in, on the Setup -> Apex Classes page)_

---

## Part 1: The Goal - Real-World Workflow (1 min)

**You:**
"Hey team, today I want to show you how we can use GitHub Actions to automate our Salesforce deployments using a real-world, enterprise-grade pipeline.

In our project, we work on **feature branches**, open **Pull Requests (PRs)** for code review, and then merge into `main` to deploy.

Today I'm going to demonstrate our two new automated pipelines:

1. **The PR Validator:** When someone opens a Pull Request, GitHub will check code formatting, run the **Salesforce Code Analyzer** for vulnerabilities, generate a **Delta** (so it only deploys what changed), and run a 'dry run' deployment to check **Code Coverage**.
2. **The Auto-Deployer:** When we approve and merge that PR, GitHub will automatically perform the real deployment of that delta to our Salesforce environment."

---

## Part 2: The Setup & Feature Branch (1 min)

**You:**
"I've already created a feature branch called `feature/update-greeting` where I updated our `HelloWorld` Apex class to say: _'Hello Team! This is a PR from our feature branch!'_. I pushed this branch to GitHub."

---

## Part 3: The PR Validation Demo (3 mins)

**You:**
"Let's act as the developer. I'm going to open a Pull Request to merge my feature branch into `main`."

_(Go to your GitHub repo homepage and open the Pull Request.)_

**You:**
"Now that the PR is open, GitHub Actions automatically kicks off **Salesforce CI - Validate PR**."

_(Click on "Details" next to the running action to show the team the logs)_

**You:**
"Let's look at what this pipeline is actually doing in the background to protect our code quality:

1. **Linting:** It runs Prettier to ensure the code is formatted correctly.
2. **Salesforce Scanner:** It scans our Apex for vulnerabilities like SOQL injections.
3. **Delta Generation:** Instead of taking an hour to deploy our whole Org, it figures out that I only changed the `HelloWorld` class, and isolates _just_ that file.
4. **Dry Run & Coverage:** It does a Dry Run deployment to Salesforce, runs our tests, and spits out our Code Coverage metrics to make sure we hit our 75% requirement."

_(Wait for the action to turn green and pass)_

**You:**
"Great, the validation passed. As a reviewer, I don't even have to look at this code until this turns green. I know it's formatted, secure, deployable, and tested."

---

## Part 4: The Merge & Auto-Deployment (2 mins)

**You:**
"Now, as the Tech Lead or Reviewer, I will approve this PR and merge it."

_(Go back to the PR page and click the green "Merge pull request" button, then "Confirm merge".)_

**You:**
"The code is now in our `main` branch. Let's go to our Actions tab."

_(Go to the GitHub Actions tab)_

**You:**
"You'll see a new workflow automatically started called **Salesforce CI - Deploy to Staging/Production**. Because code was merged into `main`, GitHub is now doing the _actual_ deployment to our Salesforce environment."

_(Click into the action and watch it complete)_

**You:**
"It's deploying the metadata... running the Apex tests one last time... and it's done! Let's verify it in Salesforce."

_(Switch to your Salesforce browser tab -> Setup -> Apex Classes)_

**You:**
"If I refresh my Apex Classes page here in Salesforce, and open the `HelloWorld` class... you can see the code has successfully been updated!"

---

## Part 5: The Value to the Team (1 min)

**You:**
"By adopting this workflow:

1. **Quality Gates:** The SF Scanner and Linter act as automated reviewers, catching bugs and bad formatting instantly.
2. **Speed:** By using SFDX-Git-Delta, we only deploy the files we touched, changing hour-long deployments into 30-second deployments.
3. **Zero manual deployments:** Developers never have to use Change Sets again. Merging the PR handles the delta deployment automatically.

Any questions on how we can start integrating this into our daily work?"
