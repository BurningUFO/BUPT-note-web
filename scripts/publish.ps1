param(
  [string]$Message = "",
  [switch]$SkipBuild,
  [switch]$NoPush,
  [switch]$AllowEmpty
)

$ErrorActionPreference = "Stop"

function Invoke-Step {
  param([string]$Title, [scriptblock]$Action)
  Write-Host "`n==> $Title" -ForegroundColor Cyan
  & $Action
}

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

Invoke-Step "Check Git repository" {
  git rev-parse --is-inside-work-tree | Out-Null
}

$branch = (git branch --show-current).Trim()
if ([string]::IsNullOrWhiteSpace($branch)) {
  throw "Detached HEAD detected. Please switch to main or master first."
}

if (-not $SkipBuild) {
  Invoke-Step "Run local build check (mkdocs build --strict)" {
    mkdocs build --strict
  }
} else {
  Write-Host "`n==> Build check skipped" -ForegroundColor Yellow
}

Invoke-Step "Stage all changes" {
  git add -A
}

$status = git status --porcelain
$hasChanges = -not [string]::IsNullOrWhiteSpace($status)

if ($hasChanges -or $AllowEmpty) {
  if ([string]::IsNullOrWhiteSpace($Message)) {
    $Message = "chore: update notes $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
  }

  Invoke-Step "Create commit" {
    if ($hasChanges) {
      git commit -m $Message
    } else {
      git commit --allow-empty -m $Message
    }
  }
} else {
  Write-Host "`n==> No file changes detected, commit skipped" -ForegroundColor Yellow
}

if (-not $NoPush) {
  Invoke-Step "Push to remote" {
    try {
      git rev-parse --abbrev-ref --symbolic-full-name "@{u}" | Out-Null
      git push
    } catch {
      git push -u origin $branch
    }
  }
} else {
  Write-Host "`n==> NoPush enabled, local actions only" -ForegroundColor Yellow
}

$remoteUrl = ""
try {
  $remoteUrl = (git remote get-url origin).Trim()
} catch {
  $remoteUrl = ""
}

if ($remoteUrl) {
  $pagesHint = ""

  if ($remoteUrl -match '^https://github\.com/([^/]+)/([^/]+?)(\.git)?$') {
    $owner = $Matches[1]
    $repo = $Matches[2]
    $pagesHint = "https://$($owner.ToLower()).github.io/$repo/"
  } elseif ($remoteUrl -match '^git@github\.com:([^/]+)/([^/]+?)(\.git)?$') {
    $owner = $Matches[1]
    $repo = $Matches[2]
    $pagesHint = "https://$($owner.ToLower()).github.io/$repo/"
  }

  if ($pagesHint) {
    Write-Host "`n==> Expected public URL: $pagesHint" -ForegroundColor Green
  }
}

Write-Host "`nDone." -ForegroundColor Green
