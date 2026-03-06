param(
  [string]$Message = "",
  [switch]$SkipBuild,
  [switch]$NoPush,
  [switch]$AllowEmpty,
  [switch]$NoSync,
  [switch]$SyncOnly,
  [switch]$StrictBuild,
  [string]$ConfigPath = ""
)

$ErrorActionPreference = "Stop"

function Invoke-Step {
  param([string]$Title, [scriptblock]$Action)
  Write-Host "`n==> $Title" -ForegroundColor Cyan
  & $Action
}

function Get-BoolValue {
  param(
    [object]$Value,
    [bool]$DefaultValue
  )

  if ($null -eq $Value) {
    return $DefaultValue
  }

  if ($Value -is [bool]) {
    return $Value
  }

  return [System.Convert]::ToBoolean($Value)
}

function Resolve-ConfigPath {
  param([string]$UserConfigPath, [string]$ScriptRoot)

  if (-not [string]::IsNullOrWhiteSpace($UserConfigPath)) {
    if ([System.IO.Path]::IsPathRooted($UserConfigPath)) {
      return $UserConfigPath
    }
    return (Join-Path $ScriptRoot $UserConfigPath)
  }

  return (Join-Path $ScriptRoot "sync-config.json")
}

function Get-RelativePathCompat {
  param(
    [string]$BasePath,
    [string]$Path
  )

  $baseResolved = (Resolve-Path -LiteralPath $BasePath).Path
  $pathResolved = (Resolve-Path -LiteralPath $Path).Path

  if (-not $baseResolved.EndsWith([System.IO.Path]::DirectorySeparatorChar)) {
    $baseResolved += [System.IO.Path]::DirectorySeparatorChar
  }

  $baseUri = New-Object System.Uri($baseResolved)
  $pathUri = New-Object System.Uri($pathResolved)
  $relativeUri = $baseUri.MakeRelativeUri($pathUri).ToString()
  return [System.Uri]::UnescapeDataString($relativeUri).Replace('/', [System.IO.Path]::DirectorySeparatorChar)
}

function Get-FileHashCompat {
  param([string]$Path)

  if (Get-Command Get-FileHash -ErrorAction SilentlyContinue) {
    return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash
  }

  $stream = [System.IO.File]::OpenRead($Path)
  try {
    $sha = [System.Security.Cryptography.SHA256]::Create()
    try {
      $hashBytes = $sha.ComputeHash($stream)
    } finally {
      $sha.Dispose()
    }
  } finally {
    $stream.Dispose()
  }

  return ([System.BitConverter]::ToString($hashBytes) -replace '-', '')
}

function Quote-YamlScalar {
  param([string]$Value)
  $safe = $Value
  if ($null -eq $safe) {
    $safe = ""
  }
  $safe = $safe -replace "'", "''"
  return "'$safe'"
}

function Update-MkdocsConfig {
  param(
    [string]$RepoRoot,
    [string]$SyncConfigPath
  )

  $config = Get-Content -Raw -LiteralPath $SyncConfigPath | ConvertFrom-Json
  $mappings = @($config.mappings | Where-Object { Get-BoolValue -Value $_.enabled -DefaultValue $true })

  $lines = New-Object System.Collections.Generic.List[string]
  $lines.Add("site_name: `"My Knowledge Base`"")
  $lines.Add("site_description: `"Computer Science Notes and Project Logs`"")
  $lines.Add("site_author: `"BurningUFO`"")
  $lines.Add("")
  $lines.Add("copyright: `"Copyright (c) 2026 BurningUFO`"")
  $lines.Add("")
  $lines.Add("theme:")
  $lines.Add("  name: material")
  $lines.Add("  language: zh")
  $lines.Add("  features:")
  $lines.Add("    - navigation.tabs")
  $lines.Add("    - navigation.sections")
  $lines.Add("    - navigation.expand")
  $lines.Add("    - navigation.top")
  $lines.Add("    - navigation.instant")
  $lines.Add("    - search.suggest")
  $lines.Add("    - search.highlight")
  $lines.Add("    - content.code.copy")
  $lines.Add("  palette:")
  $lines.Add("    - scheme: slate")
  $lines.Add("      primary: black")
  $lines.Add("      accent: cyan")
  $lines.Add("")
  $lines.Add("nav:")
  $lines.Add("  - $(Quote-YamlScalar 'Home'): index.md")

  foreach ($mapping in $mappings) {
    $targetRel = ([string]$mapping.target) -replace '\\', '/'
    if ($targetRel.StartsWith("docs/")) {
      $targetRel = $targetRel.Substring(5)
    }

    $targetAbs = Join-Path $RepoRoot ([string]$mapping.target)
    if (-not (Test-Path -LiteralPath $targetAbs)) {
      continue
    }

    $sectionTitle = [string]$mapping.navTitle
    if ([string]::IsNullOrWhiteSpace($sectionTitle)) {
      $sectionTitle = [string]$mapping.readmeTitle
    }
    if ([string]::IsNullOrWhiteSpace($sectionTitle)) {
      $sectionTitle = [string]$mapping.name
    }

    $indexCandidate = Join-Path $targetAbs "index.md"
    $sectionIndexPath = "$targetRel/index.md"
    if (-not (Test-Path -LiteralPath $indexCandidate)) {
      $sectionIndexPath = "$targetRel/README.md"
    }

    $lines.Add("  - $(Quote-YamlScalar $sectionTitle):")
    $lines.Add("      - $(Quote-YamlScalar 'Index'): $(Quote-YamlScalar $sectionIndexPath)")

    $noteFiles = Get-ChildItem -LiteralPath $targetAbs -Recurse -File -Filter *.md |
      Where-Object { $_.Name -ine "README.md" -and $_.Name -ine "index.md" } |
      Sort-Object FullName

    foreach ($file in $noteFiles) {
      $rel = Get-RelativePathCompat -BasePath $targetAbs -Path $file.FullName
      $rel = ($rel -replace '\\', '/')
      $docPath = "$targetRel/$rel"
      $display = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
      $lines.Add("      - $(Quote-YamlScalar $display): $(Quote-YamlScalar $docPath)")
    }
  }

  $lines.Add("")
  $lines.Add("markdown_extensions:")
  $lines.Add("  - attr_list")
  $lines.Add("  - md_in_html")
  $lines.Add("  - pymdownx.highlight:")
  $lines.Add("      anchor_linenums: true")
  $lines.Add("  - pymdownx.inlinehilite")
  $lines.Add("  - pymdownx.snippets")
  $lines.Add("  - pymdownx.superfences")
  $lines.Add("  - pymdownx.arithmatex:")
  $lines.Add("      generic: true")
  $lines.Add("  - pymdownx.tasklist:")
  $lines.Add("      custom_checkbox: true")
  $lines.Add("")
  $lines.Add("extra_css:")
  $lines.Add("  - stylesheets/extra.css")
  $lines.Add("")
  $lines.Add("extra_javascript:")
  $lines.Add("  - javascripts/extra.js")

  ($lines -join [Environment]::NewLine) | Out-File -FilePath (Join-Path $RepoRoot "mkdocs.yml") -Encoding utf8 -Force
}

function Invoke-SyncMappings {
  param(
    [string]$RepoRoot,
    [string]$SyncConfigPath
  )

  if (-not (Test-Path -LiteralPath $SyncConfigPath)) {
    throw "Sync config not found: $SyncConfigPath"
  }

  $config = Get-Content -Raw -LiteralPath $SyncConfigPath | ConvertFrom-Json
  $mappings = @($config.mappings)

  if ($mappings.Count -eq 0) {
    throw "No mappings found in sync config: $SyncConfigPath"
  }

  foreach ($mapping in $mappings) {
    $name = [string]$mapping.name
    if ([string]::IsNullOrWhiteSpace($name)) {
      $name = "Unnamed mapping"
    }

    $enabled = Get-BoolValue -Value $mapping.enabled -DefaultValue $true
    if (-not $enabled) {
      Write-Host "Skip mapping: $name (disabled)" -ForegroundColor Yellow
      continue
    }

    $source = [Environment]::ExpandEnvironmentVariables([string]$mapping.source)
    $targetRel = [string]$mapping.target
    $recurse = Get-BoolValue -Value $mapping.recurse -DefaultValue $true
    $flatten = Get-BoolValue -Value $mapping.flatten -DefaultValue $false
    $deleteMissing = Get-BoolValue -Value $mapping.deleteMissing -DefaultValue $false

    if ([string]::IsNullOrWhiteSpace($source) -or [string]::IsNullOrWhiteSpace($targetRel)) {
      throw "Mapping '$name' requires both source and target."
    }

    if (-not [System.IO.Path]::IsPathRooted($source)) {
      $source = Join-Path $RepoRoot $source
    }

    $target = $targetRel
    if (-not [System.IO.Path]::IsPathRooted($targetRel)) {
      $target = Join-Path $RepoRoot $targetRel
    }

    if (-not (Test-Path -LiteralPath $source)) {
      throw "Mapping '$name' source folder not found: $source"
    }

    New-Item -ItemType Directory -Force -Path $target | Out-Null

    if ($recurse) {
      $files = Get-ChildItem -LiteralPath $source -File -Recurse -Filter *.md
    } else {
      $files = Get-ChildItem -LiteralPath $source -File -Filter *.md
    }

    $excludeNames = @()
    if ($null -ne $mapping.excludeFileNames) {
      $excludeNames = @($mapping.excludeFileNames | ForEach-Object { [string]$_ })
    }

    if ($excludeNames.Count -gt 0) {
      $files = $files | Where-Object { $excludeNames -notcontains $_.Name }
    }

    $updatedCount = 0
    $seenRelative = New-Object "System.Collections.Generic.HashSet[string]"

    foreach ($file in $files) {
      if ($flatten) {
        $relative = $file.Name
      } else {
        $relative = Get-RelativePathCompat -BasePath $source -Path $file.FullName
      }

      $relative = $relative -replace '[\\/]+', [System.IO.Path]::DirectorySeparatorChar
      $null = $seenRelative.Add($relative)

      $destination = Join-Path $target $relative
      $destinationDir = Split-Path -Parent $destination
      if (-not [string]::IsNullOrWhiteSpace($destinationDir)) {
        New-Item -ItemType Directory -Force -Path $destinationDir | Out-Null
      }

      $shouldCopy = $true
      if (Test-Path -LiteralPath $destination) {
        $srcHash = Get-FileHashCompat -Path $file.FullName
        $dstHash = Get-FileHashCompat -Path $destination
        $shouldCopy = $srcHash -ne $dstHash
      }

      if ($shouldCopy) {
        Copy-Item -LiteralPath $file.FullName -Destination $destination -Force
        $updatedCount++
      }
    }

    $deletedCount = 0
    if ($deleteMissing) {
      $targetFiles = Get-ChildItem -LiteralPath $target -File -Recurse -Filter *.md
      foreach ($targetFile in $targetFiles) {
        if ($targetFile.Name -ieq "index.md") {
          continue
        }
        $targetRelative = Get-RelativePathCompat -BasePath $target -Path $targetFile.FullName
        $targetRelative = $targetRelative -replace '[\\/]+', [System.IO.Path]::DirectorySeparatorChar
        if (-not $seenRelative.Contains($targetRelative)) {
          Remove-Item -LiteralPath $targetFile.FullName -Force
          $deletedCount++
        }
      }
    }

    $generateReadme = Get-BoolValue -Value $mapping.generateReadme -DefaultValue $true
    if ($generateReadme) {
      $readmeTitle = [string]$mapping.readmeTitle
      if ([string]::IsNullOrWhiteSpace($readmeTitle)) {
        $readmeTitle = $name
      }

      $indexPath = Join-Path $target "index.md"
      $relativeList = @()
      foreach ($file in $files) {
        if ($flatten) {
          $relative = $file.Name
        } else {
          $relative = Get-RelativePathCompat -BasePath $source -Path $file.FullName
        }
        $relative = ($relative -replace '[\\/]+', '/')
        $relativeList += $relative
      }

      $relativeList = $relativeList | Sort-Object -Unique
      $readmeLines = @()
      $readmeLines += "# $readmeTitle"
      $readmeLines += ""
      $readmeLines += "Auto-synced from: $source"
      $readmeLines += ""

      if ($relativeList.Count -eq 0) {
        $readmeLines += "> No markdown notes found in source folder yet."
      } else {
        $readmeLines += "## Notes"
        $readmeLines += ""
        foreach ($rel in $relativeList) {
          $nameOnly = [System.IO.Path]::GetFileName($rel)
          $readmeLines += "- [$nameOnly](./$rel)"
        }
      }

      ($readmeLines -join [Environment]::NewLine) | Out-File -FilePath $indexPath -Encoding utf8 -Force
    }

    Write-Host "Mapping '$name': scanned $($files.Count) md files, updated $updatedCount, deleted $deletedCount." -ForegroundColor Green
  }
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

$resolvedConfigPath = Resolve-ConfigPath -UserConfigPath $ConfigPath -ScriptRoot $PSScriptRoot

if (-not $NoSync) {
  Invoke-Step "Sync markdown notes from external folders" {
    Invoke-SyncMappings -RepoRoot $repoRoot -SyncConfigPath $resolvedConfigPath
  }
} else {
  Write-Host "`n==> Sync step skipped" -ForegroundColor Yellow
}

Invoke-Step "Refresh mkdocs navigation from mapped courses" {
  Update-MkdocsConfig -RepoRoot $repoRoot -SyncConfigPath $resolvedConfigPath
}

if ($SyncOnly) {
  Write-Host "`n==> SyncOnly enabled, stop before build/commit/push" -ForegroundColor Yellow
  Write-Host "`nDone." -ForegroundColor Green
  exit 0
}

if (-not $SkipBuild) {
  if ($StrictBuild) {
    Invoke-Step "Run local build check (mkdocs build --strict)" {
      mkdocs build --strict
    }
  } else {
    Invoke-Step "Run local build check (mkdocs build)" {
      mkdocs build
    }
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
