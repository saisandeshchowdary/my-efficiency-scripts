# My Efficiency Scripts

**Location:** `C:\Users\ssandesh\my-efficiency-scripts`

This folder contains globally accessible CMD scripts for development workflows. All scripts can be executed from any directory.

---

## Available Scripts

### 🔀 `create-pr.cmd`
**Purpose:** Creates a GitHub Pull Request from the current Git repository

**Usage:** 
```cmd
create-pr.cmd
```

**Features:**
- Detects current Git branch
- Offers to use current branch or specify source branch
- Asks for destination branch (defaults to `dev`)
- Can use latest commit message as PR title
- Authenticates using embedded GitHub token
- Validates PR creation and displays PR URL
- Shows clear success/error indicators

**Prerequisites:**
- Must be in a Git repository
- GitHub CLI (`gh`) must be installed
- GitHub token configured in script

---

### 🌿 `create-branch.cmd`
**Purpose:** Creates and pushes a new Git branch from a specified source branch

**Usage:**
```cmd
create-branch.cmd
```

**Features:**
- Creates branch from `dev` or custom source branch
- Validates branch naming conventions
- Checks if branch already exists (local/remote)
- Automatically pushes new branch to remote
- Switches to the newly created branch
- Shows clear success/error indicators

**Branch Naming Rules:**
- No spaces, `..`, or invalid characters (`~`, `^`, `:`, `?`, `*`, `[`, `\`, `@{`)
- Cannot start with `-` or `.`
- Cannot end with `.`, `/`, or `.lock`

**Prerequisites:**
- Must be in a Git repository

---

### ℹ️ `help.cmd`
**Purpose:** Lists all available scripts in this folder with descriptions

**Usage:**
```cmd
help.cmd
```

---

## How Scripts Work

### Global Access
All scripts in this folder are in the Windows PATH, so they can be executed from any directory:

```cmd
# From ANY directory
C:\some\random\folder> create-pr.cmd
```

### Configuration Management

All secrets and authentication tokens are managed via a `.env` configuration file to prevent hardcoding sensitive data in scripts.

#### .env File
The `.env` file contains all secrets and API credentials:
```ini
# GitHub Configuration
GH_TOKEN_PR=ghp_xxxxxxxxxxxxxxxxxxxx
GH_TOKEN_ISSUE=ghp_xxxxxxxxxxxxxxxxxxxx

# Enterprise Cache Statistics API
EH_BEARER_TOKEN=xxxxxxxxxxxxxxxxxxxx
EH_API_HOST=server
```

**IMPORTANT:** 
- ⚠️ Never commit `.env` to version control
- Add `.env` to `.gitignore`
- Keep this file secure and private
- Regenerate tokens if exposed

#### load-config.cmd
The `load-config.cmd` helper script reads the `.env` file and makes all variables available to other scripts. All scripts automatically call this on startup.

---

## Setting Up GitHub Tokens

### Generate a GitHub Personal Access Token (PAT)

GitHub scripts require a Personal Access Token (PAT) for authentication. Follow these steps:

#### Step 1: Open GitHub Settings
1. Go to **https://github.com** and log in
2. Click your **profile icon** in the top-right corner
3. Select **Settings** from the dropdown menu

#### Step 2: Navigate to Developer Settings
1. In the left sidebar, scroll down and click **Developer settings**
2. In the left sidebar again, click **Personal access tokens**
3. Click the dropdown arrow and select **Tokens (classic)**

#### Step 3: Generate New Token
1. Click the **"Generate new token"** button
2. Select **"Generate new token (classic)"** option

#### Step 4: Configure Token Details
1. **Note (Token Name):** Give it a descriptive name
   - Example: `my-efficiency-scripts` or `issue-reader`

2. **Expiration:** Choose an expiration period
   - Options: 7 days, 30 days, 60 days, 90 days, or **No expiration**
   - Recommended: **90 days** for security

3. **Select Scopes (Permissions):**
   - ✅ **`repo`** — Full control of private and public repositories
   - ✅ **`read:user`** — Read user profile data
   - ✅ **`read:org`** — Read organization membership data
   - (Optional) `write:repo_hook` — If you need to manage webhooks

   For basic usage, just check `repo` and `read:user`.

#### Step 5: Create and Copy Token
1. Click **"Generate token"** button at the bottom
2. ⚠️ **IMPORTANT:** Copy the token immediately
   - You will **NOT** be able to see it again
   - The token looks like: `ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

#### Step 6: Add to .env File
1. Open the `.env` file in this scripts folder
2. Paste the token into the appropriate variables:
   ```ini
   # GitHub Configuration
   GH_TOKEN_PR=ghp_<your_copied_token_here>
   GH_TOKEN_ISSUE=ghp_<your_copied_token_here>
   ```
3. Save the file

### Token Security Best Practices

- 🔐 **Never share your token** — Treat it like a password
- 🔐 **Never commit `.env` to Git** — It's in `.gitignore` for a reason
- 🔐 **Regenerate if exposed** — Go back to GitHub Settings and delete the old token
- 🔐 **Use expiration dates** — Regenerate tokens every 90 days for security
- 🔐 **Scope tokens appropriately** — Only enable the permissions you need

### If Your Token is Exposed
1. Go to https://github.com/settings/tokens
2. Find the exposed token
3. Click **"Delete"** to revoke it immediately
4. Generate a new token following the steps above
5. Update your `.env` file with the new token

### Git Context
Scripts automatically work on the Git repository of your current working directory. No need to specify paths.

### Visual Indicators
All scripts use consistent visual indicators:

| Indicator | Meaning |
|-----------|---------|
| `[OK]` | Success |
| `[XX]` | Error |
| `[!!]` | Warning |
| `[..]` | In progress |
| `[--]` | Cancelled |

---

## Adding New Scripts

1. Place your `.cmd` file in `C:\Users\ssandesh\my-efficiency-scripts`
2. Add this at the top of your script:
   ```bat
   :: ---- Load Configuration ----
   call "%~dp0load-config.cmd"
   if errorlevel 1 (
       echo [XX] ERROR: Failed to load configuration. Check .env file.
       exit /b 1
   )
   ```
3. Use variables from `.env` instead of hardcoding secrets
4. It will automatically be available globally
3. Update this README to document it
4. Run `help.cmd` to verify it appears in the list

---

## Environment Setup

### PATH Configuration
This folder is added to the Windows User PATH variable:
```
C:\Users\ssandesh\my-efficiency-scripts
```

### Refreshing PATH in Current Session
If you add a new script and want to use it in the current terminal without restarting:

**PowerShell:**
```powershell
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
```

**CMD:**
```cmd
refreshenv
```

Or simply **restart your terminal**.

---

## GitHub Copilot Integration

### Using Scripts with Copilot

GitHub Copilot can help you use these scripts. You can ask:

**Examples:**
- "Create a PR from my current branch to dev"
- "Create a new feature branch from dev"
- "Show me my available efficiency scripts"
- "Run create-pr.cmd"

### For Copilot: How to Execute Scripts

Scripts are Windows CMD batch files located in the PATH. Execute them using:

```
run_in_terminal tool with command: create-pr.cmd
run_in_terminal tool with command: create-branch.cmd
run_in_terminal tool with command: help.cmd
```

All scripts work on the current working directory's Git repository.

---

## Troubleshooting

### Script Not Found
**Error:** `The term 'create-pr.cmd' is not recognized`

**Solutions:**
1. Restart your terminal to reload PATH
2. Or manually reload PATH (see "Refreshing PATH" above)
3. Verify the script exists: `dir C:\Users\ssandesh\my-efficiency-scripts`

### Git Authentication Issues
For `create-pr.cmd`, ensure:
1. GitHub token is configured in the script
2. Token has `repo` scope permissions
3. You're in a valid Git repository

---

## Configuration

### GitHub Token (create-pr.cmd)
The GitHub token is embedded in `create-pr.cmd`:
```cmd
set "GH_TOKEN=your_token_here"
```

To update it:
1. Open `C:\Users\ssandesh\my-efficiency-scripts\create-pr.cmd`
2. Replace the token value
3. Save the file

---

Last Updated: February 11, 2026
