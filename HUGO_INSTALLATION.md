# Hugo Installation Instructions for Windows

## Method 1: Manual Download (Recommended)

1. **Download Hugo Extended:**
   - Go to: https://github.com/gohugoio/hugo/releases/latest
   - Download: `hugo_extended_X.X.X_windows-amd64.zip` (latest version)

2. **Extract and Setup:**
   - Extract the zip file to a folder (e.g., `C:\Hugo\bin`)
   - Add the folder to your Windows PATH:
     - Open System Properties → Advanced → Environment Variables
     - Add `C:\Hugo\bin` to your PATH variable
     - Restart PowerShell

3. **Verify Installation:**
   ```powershell
   hugo version
   ```

## Method 2: Using Scoop (Alternative)

```powershell
# Install Scoop first (if not installed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# Install Hugo Extended
scoop install hugo-extended
```

## Method 3: Using Chocolatey (Requires Admin)

```powershell
# Run PowerShell as Administrator
choco install hugo-extended -y
```

## Next Steps

Once Hugo is installed, run these commands in your `simple-cms` directory:

```powershell
# Initialize Hugo site
hugo new site . --force

# Initialize Git repository
git init

# Add a theme (we'll do this in the next section)
# git submodule add https://github.com/username/theme-name.git themes/theme-name
```

## Troubleshooting

- If `hugo` command is not recognized, restart PowerShell after adding to PATH
- Make sure you downloaded the "Extended" version for full features
- Check that the Hugo binary is executable
