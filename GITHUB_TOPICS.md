# GitHub Topics and Tags for account_ledger_flutter

This document provides suggested GitHub topics/tags for the `account_ledger_flutter` repository along with various methods to add them.

## Suggested Topics

Based on analysis of the repository, the following topics are recommended:

### Primary Topics (Technology Stack)
| Topic | Description |
|-------|-------------|
| `flutter` | Cross-platform UI framework |
| `dart` | Dart programming language |
| `flutter-app` | Flutter application |
| `flutter-apps` | Flutter applications collection |
| `material-design` | Material Design UI implementation |

### Platform-Specific Topics
| Topic | Description |
|-------|-------------|
| `android` | Android platform support |
| `ios` | iOS platform support |
| `web` | Web platform support |
| `windows` | Windows desktop support |
| `linux` | Linux desktop support |
| `macos` | macOS desktop support |
| `cross-platform` | Multi-platform application |
| `multiplatform` | Same as cross-platform |
| `mobile` | Mobile application |
| `desktop` | Desktop application |

### Application Domain Topics
| Topic | Description |
|-------|-------------|
| `accounting` | Accounting/Financial application |
| `ledger` | Ledger management |
| `finance` | Finance application |
| `finance-app` | Financial application |
| `account-management` | Account management system |

### UI/UX Topics
| Topic | Description |
|-------|-------------|
| `getwidget` | Uses GetWidget UI library |
| `material-ui` | Material Design UI components |

### CI/CD Topics
| Topic | Description |
|-------|-------------|
| `azure-pipelines` | Azure Pipelines CI/CD |
| `azure-devops` | Azure DevOps integration |

## Complete List of Recommended Topics

```
flutter, dart, flutter-app, material-design, android, ios, web, windows, linux, macos, cross-platform, mobile, desktop, accounting, ledger, finance, account-management, getwidget, azure-pipelines
```

**Top 20 Topics (GitHub allows maximum 20 topics):**
1. flutter
2. dart
3. flutter-app
4. material-design
5. android
6. ios
7. web
8. windows
9. linux
10. macos
11. cross-platform
12. mobile
13. desktop
14. accounting
15. ledger
16. finance
17. account-management
18. getwidget
19. azure-pipelines
20. multiplatform

---

## Methods to Add GitHub Topics

### Method 1: GitHub CLI (gh)

The GitHub CLI (`gh`) is the easiest way to add topics from the command line.

#### Installation

```bash
# macOS
brew install gh

# Windows (with Chocolatey)
choco install gh

# Windows (with Scoop)
scoop install gh

# Ubuntu/Debian
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli-stable.list > /dev/null
sudo apt update
sudo apt install gh
```

#### Authenticate with GitHub

```bash
gh auth login
```

#### Add Topics Using GitHub CLI

```bash
# Add all recommended topics
gh repo edit Baneeishaque/account_ledger_flutter --add-topic flutter --add-topic dart --add-topic flutter-app --add-topic material-design --add-topic android --add-topic ios --add-topic web --add-topic windows --add-topic linux --add-topic macos --add-topic cross-platform --add-topic mobile --add-topic desktop --add-topic accounting --add-topic ledger --add-topic finance --add-topic account-management --add-topic getwidget --add-topic azure-pipelines --add-topic multiplatform
```

#### Individual Topic Commands

```bash
# Add topics individually
gh repo edit Baneeishaque/account_ledger_flutter --add-topic flutter
gh repo edit Baneeishaque/account_ledger_flutter --add-topic dart
gh repo edit Baneeishaque/account_ledger_flutter --add-topic flutter-app
gh repo edit Baneeishaque/account_ledger_flutter --add-topic material-design
gh repo edit Baneeishaque/account_ledger_flutter --add-topic android
gh repo edit Baneeishaque/account_ledger_flutter --add-topic ios
gh repo edit Baneeishaque/account_ledger_flutter --add-topic web
gh repo edit Baneeishaque/account_ledger_flutter --add-topic windows
gh repo edit Baneeishaque/account_ledger_flutter --add-topic linux
gh repo edit Baneeishaque/account_ledger_flutter --add-topic macos
gh repo edit Baneeishaque/account_ledger_flutter --add-topic cross-platform
gh repo edit Baneeishaque/account_ledger_flutter --add-topic mobile
gh repo edit Baneeishaque/account_ledger_flutter --add-topic desktop
gh repo edit Baneeishaque/account_ledger_flutter --add-topic accounting
gh repo edit Baneeishaque/account_ledger_flutter --add-topic ledger
gh repo edit Baneeishaque/account_ledger_flutter --add-topic finance
gh repo edit Baneeishaque/account_ledger_flutter --add-topic account-management
gh repo edit Baneeishaque/account_ledger_flutter --add-topic getwidget
gh repo edit Baneeishaque/account_ledger_flutter --add-topic azure-pipelines
gh repo edit Baneeishaque/account_ledger_flutter --add-topic multiplatform
```

#### Remove a Topic

```bash
gh repo edit Baneeishaque/account_ledger_flutter --remove-topic <topic-name>
```

#### View Current Topics

```bash
gh repo view Baneeishaque/account_ledger_flutter --json repositoryTopics
```

---

### Method 2: GitHub REST API (cURL)

You can use the GitHub REST API to replace all topics at once.

#### Using a Personal Access Token

First, create a Personal Access Token (PAT) with `repo` scope at: https://github.com/settings/tokens

```bash
# Set your token
export GITHUB_TOKEN="your_personal_access_token"

# Replace all topics with the specified list
curl -X PUT \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/Baneeishaque/account_ledger_flutter/topics \
  -d '{"names":["flutter","dart","flutter-app","material-design","android","ios","web","windows","linux","macos","cross-platform","mobile","desktop","accounting","ledger","finance","account-management","getwidget","azure-pipelines","multiplatform"]}'
```

#### Get Current Topics via API

```bash
curl -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/Baneeishaque/account_ledger_flutter/topics
```

---

### Method 3: GitHub GraphQL API

The GraphQL API provides another way to manage repository topics.

```bash
# Using GraphQL mutation to update topics
curl -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  https://api.github.com/graphql \
  -d '{
    "query": "mutation($repositoryId: ID!, $topicNames: [String!]!) { updateTopics(input: {repositoryId: $repositoryId, topicNames: $topicNames}) { repository { repositoryTopics(first: 20) { nodes { topic { name } } } } } }",
    "variables": {
      "repositoryId": "<repository-node-id>",
      "topicNames": ["flutter", "dart", "flutter-app", "material-design", "android", "ios", "web", "windows", "linux", "macos", "cross-platform", "mobile", "desktop", "accounting", "ledger", "finance", "account-management", "getwidget", "azure-pipelines", "multiplatform"]
    }
  }'
```

To get the repository node ID:

```bash
curl -H "Authorization: Bearer $GITHUB_TOKEN" \
  https://api.github.com/graphql \
  -d '{"query": "query { repository(owner: \"Baneeishaque\", name: \"account_ledger_flutter\") { id } }"}'
```

---

### Method 4: GitHub Web Interface (Manual)

1. Navigate to https://github.com/Baneeishaque/account_ledger_flutter
2. Click the ⚙️ gear icon next to "About" on the right sidebar
3. In the "Topics" field, enter topics separated by spaces or commas
4. Click "Save changes"

**Topics to paste:**
```
flutter dart flutter-app material-design android ios web windows linux macos cross-platform mobile desktop accounting ledger finance account-management getwidget azure-pipelines multiplatform
```

---

### Method 5: Using Python with PyGithub

```python
from github import Github

# Create a GitHub instance with your token
g = Github("your_personal_access_token")

# Get the repository
repo = g.get_repo("Baneeishaque/account_ledger_flutter")

# Set topics
topics = [
    "flutter", "dart", "flutter-app", "material-design",
    "android", "ios", "web", "windows", "linux", "macos",
    "cross-platform", "mobile", "desktop", "accounting",
    "ledger", "finance", "account-management", "getwidget",
    "azure-pipelines", "multiplatform"
]

repo.replace_topics(topics)
print("Topics updated successfully!")
```

**Installation:**
```bash
pip install PyGithub
```

---

### Method 6: Using JavaScript/Node.js with Octokit

```javascript
const { Octokit } = require("@octokit/rest");

const octokit = new Octokit({
  auth: "your_personal_access_token"
});

async function updateTopics() {
  await octokit.rest.repos.replaceAllTopics({
    owner: "Baneeishaque",
    repo: "account_ledger_flutter",
    names: [
      "flutter", "dart", "flutter-app", "material-design",
      "android", "ios", "web", "windows", "linux", "macos",
      "cross-platform", "mobile", "desktop", "accounting",
      "ledger", "finance", "account-management", "getwidget",
      "azure-pipelines", "multiplatform"
    ]
  });
  console.log("Topics updated successfully!");
}

updateTopics();
```

**Installation:**
```bash
npm install @octokit/rest
```

---

### Method 7: Using GitHub Actions

Create a workflow file `.github/workflows/update-topics.yml`:

```yaml
name: Update Repository Topics

on:
  workflow_dispatch:

jobs:
  update-topics:
    runs-on: ubuntu-latest
    steps:
      - name: Update Topics
        uses: actions/github-script@v7
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          script: |
            await github.rest.repos.replaceAllTopics({
              owner: context.repo.owner,
              repo: context.repo.repo,
              names: [
                "flutter", "dart", "flutter-app", "material-design",
                "android", "ios", "web", "windows", "linux", "macos",
                "cross-platform", "mobile", "desktop", "accounting",
                "ledger", "finance", "account-management", "getwidget",
                "azure-pipelines", "multiplatform"
              ]
            });
            console.log("Topics updated successfully!");
```

---

## Topic Rules and Best Practices

1. **Maximum 20 topics** per repository
2. Topics must:
   - Start with a letter or number
   - Contain only lowercase letters, numbers, and hyphens
   - Be 50 characters or less
   - Not start with a hyphen
3. Use specific, descriptive topics that help with discoverability
4. Include technology stack, programming language, and application domain
5. Avoid redundant or overly generic topics

---

## Quick Reference: One-Line Commands

### GitHub CLI (Recommended)
```bash
gh repo edit Baneeishaque/account_ledger_flutter --add-topic flutter --add-topic dart --add-topic flutter-app --add-topic material-design --add-topic android --add-topic ios --add-topic web --add-topic windows --add-topic linux --add-topic macos --add-topic cross-platform --add-topic mobile --add-topic desktop --add-topic accounting --add-topic ledger --add-topic finance --add-topic account-management --add-topic getwidget --add-topic azure-pipelines --add-topic multiplatform
```

### cURL with REST API
```bash
curl -X PUT -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" https://api.github.com/repos/Baneeishaque/account_ledger_flutter/topics -d '{"names":["flutter","dart","flutter-app","material-design","android","ios","web","windows","linux","macos","cross-platform","mobile","desktop","accounting","ledger","finance","account-management","getwidget","azure-pipelines","multiplatform"]}'
```

---

## Note About Git Tags

GitHub Topics are different from Git Tags:
- **GitHub Topics**: Metadata labels for repository discovery and categorization
- **Git Tags**: Version markers in your Git history (e.g., `v1.0.0`, `v2.0.0`)

If you also want to create Git version tags, you can use:

```bash
# Create a tag
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push tag to remote
git push origin v1.0.0

# Or push all tags
git push origin --tags
```

Using GitHub CLI:
```bash
gh release create v1.0.0 --title "Release v1.0.0" --notes "Initial release"
```

---

## Summary

This repository is a **Flutter-based cross-platform accounting/ledger application** that supports:
- **Mobile**: Android, iOS
- **Desktop**: Windows, Linux, macOS  
- **Web**: Browser-based application

The recommended topics reflect the technology stack (Flutter, Dart, Material Design), supported platforms (Android, iOS, Web, Windows, Linux, macOS), application domain (accounting, ledger, finance), and CI/CD integration (Azure Pipelines).
