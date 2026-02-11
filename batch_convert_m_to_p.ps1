[CmdletBinding()]
param(
    [string]$SrcDir = "full_test_case_matlab",
    [string[]]$ExcludePath = @(),
    [string]$OutDir = "pcode_out_flat",
    [string]$MatlabExe = "C:\Program Files\MATLAB\R2016a\bin\matlab.exe",
    [int]$Threads = 4,
    [int]$MaxFiles = 0,
    [switch]$KeepStage,
    [switch]$KeepM,
    [string]$MapFile = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-FlatName {
    param(
        [string]$Root,
        [string]$Path
    )
    $rel = $Path.Substring($Root.Length).TrimStart("\", "/")
    $relNoExt = [System.IO.Path]::ChangeExtension($rel, $null)
    if ($relNoExt.EndsWith(".")) {
        $relNoExt = $relNoExt.Substring(0, $relNoExt.Length - 1)
    }
    $flat = [regex]::Replace($relNoExt, "[\\/]+", "__")
    while ($flat.Contains("..")) {
        $flat = $flat.Replace("..", ".")
    }
    $flat = [regex]::Replace($flat, "[^A-Za-z0-9_]", "_")
    return "$flat.m"
}

function Wait-StageOutputs {
    param(
        [string]$StageRoot,
        [int]$ExpectedCount,
        [int]$MaxWaitSeconds = 120
    )
    if (-not (Test-Path -LiteralPath $StageRoot)) {
        return
    }
    $lastCount = -1
    $stableTicks = 0
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    while ($sw.Elapsed.TotalSeconds -lt $MaxWaitSeconds) {
        $count = @(Get-ChildItem -Path $StageRoot -Recurse -Filter *.p -File -ErrorAction SilentlyContinue).Count
        if ($ExpectedCount -gt 0 -and $count -ge $ExpectedCount) {
            break
        }
        if ($ExpectedCount -le 0) {
            if ($count -eq $lastCount) {
                $stableTicks++
            } else {
                $stableTicks = 0
                $lastCount = $count
            }
            if ($stableTicks -ge 3 -and $count -gt 0) {
                break
            }
        }
        Start-Sleep -Seconds 1
    }
}

function Copy-FromStageMaps {
    param(
        [string]$StageRoot,
        [hashtable]$FlatMap,
        [string]$OutRoot
    )
    if (-not (Test-Path -LiteralPath $StageRoot)) {
        return 0
    }
    $copied = 0
    $stageMaps = @(Get-ChildItem -Path $StageRoot -Recurse -Filter stage_map.csv -File -ErrorAction SilentlyContinue)
    foreach ($mapFile in $stageMaps) {
        $mapPath = $mapFile.FullName
        $jobDir = Split-Path -Parent $mapPath
        $lines = @(Get-Content -LiteralPath $mapPath -Encoding ASCII -ErrorAction SilentlyContinue)
        foreach ($line in $lines) {
            if ([string]::IsNullOrWhiteSpace($line)) { continue }
            $parts = $line.Split(",", 2)
            if ($parts.Count -lt 2) { continue }
            $origRel = $parts[0].Trim()
            $stageRel = $parts[1].Trim()
            if ([string]::IsNullOrWhiteSpace($origRel) -or [string]::IsNullOrWhiteSpace($stageRel)) { continue }
            $origRelP = [System.IO.Path]::ChangeExtension($origRel, ".p")
            if (-not $FlatMap.ContainsKey($origRelP)) { continue }
            $dst = Join-Path $OutRoot $FlatMap[$origRelP]
            if (Test-Path -LiteralPath $dst) { continue }
            $stageRelP = [System.IO.Path]::ChangeExtension($stageRel, ".p")
            $src = Join-Path $jobDir $stageRelP
            if (Test-Path -LiteralPath $src) {
                Copy-Item -LiteralPath $src -Destination $dst -Force
                $copied++
            }
        }
    }
    return $copied
}

if (-not (Test-Path -LiteralPath $MatlabExe)) {
    throw "MATLAB executable not found: $MatlabExe"
}

$srcRoot = (Resolve-Path -LiteralPath $SrcDir).Path
$outRoot = (Resolve-Path -LiteralPath (New-Item -ItemType Directory -Force -Path $OutDir)).Path
$logDir = Join-Path $outRoot "logs"
$stageRoot = Join-Path $outRoot "_stage"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
New-Item -ItemType Directory -Force -Path $stageRoot | Out-Null

$files = Get-ChildItem -Path $srcRoot -Recurse -File -Filter *.m
if ($MaxFiles -gt 0) {
    $files = $files | Select-Object -First $MaxFiles
}
if (-not $files) {
    throw "No .m files found under $srcRoot"
}

$excludeSet = @{}
foreach ($path in $ExcludePath) {
    if ([string]::IsNullOrWhiteSpace($path)) { continue }
    $resolved = Resolve-Path -LiteralPath $path -ErrorAction SilentlyContinue
    if ($resolved) {
        $excludeSet[$resolved.Path] = $true
    } else {
        Write-Warning "ExcludePath not found: $path"
    }
}
if ($excludeSet.Count -gt 0) {
    $files = $files | Where-Object { -not $excludeSet.ContainsKey($_.FullName) }
}
if (-not $files) {
    throw "No .m files left after applying ExcludePath."
}

$map = foreach ($f in $files) {
    $flatName = Get-FlatName -Root $srcRoot -Path $f.FullName
    [pscustomobject]@{
        Source = $f.FullName
        FlatName = $flatName
    }
}
$map = @($map)

# Ensure unique flat names
$seen = @{}
foreach ($item in $map) {
    $name = $item.FlatName
    if ($seen.ContainsKey($name)) {
        $idx = ++$seen[$name]
        $base = [System.IO.Path]::GetFileNameWithoutExtension($name)
        $item.FlatName = "{0}__dup{1}.m" -f $base, $idx
    } else {
        $seen[$name] = 0
    }
}

if ([string]::IsNullOrWhiteSpace($MapFile)) {
    $MapFile = Join-Path $outRoot "map.csv"
}
$map | ForEach-Object {
    "$($_.Source),$($_.FlatName)"
} | Set-Content -Path $MapFile -Encoding ASCII

$total = $map.Count
$Threads = [Math]::Max(1, [Math]::Min($Threads, $total))
$chunkSize = [Math]::Ceiling($total / $Threads)

Write-Host "Total files: $total"
Write-Host "Threads: $Threads"
Write-Host "Output: $outRoot"
Write-Host "Map: $MapFile"

$jobs = @()
for ($i = 0; $i -lt $Threads; $i++) {
    $chunk = $map | Select-Object -Skip ($i * $chunkSize) -First $chunkSize
    if (-not $chunk) { continue }
    $jobId = $i + 1
    $logPath = Join-Path $logDir ("pcode_job_{0:00}.log" -f $jobId)
    $jobs += Start-Job -ArgumentList @($chunk, $MatlabExe, $outRoot, $stageRoot, $jobId, $KeepStage, $KeepM, $logPath, $srcRoot) -ScriptBlock {
        param($Chunk, $MatlabExe, $OutRoot, $StageRoot, $JobId, $KeepStage, $KeepM, $LogPath, $SrcRoot)

        function Get-ValidFunctionName {
            param([string]$Name)
            $clean = [regex]::Replace($Name, '[^A-Za-z0-9_]', '_')
            if ($clean -match '^[A-Za-z]') {
                return $clean
            }
            return ("f_{0}" -f $clean)
        }

        $stageDir = Join-Path $StageRoot ("job_{0:00}" -f $JobId)
        New-Item -ItemType Directory -Force -Path $stageDir | Out-Null
        Get-ChildItem -Path $stageDir -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

        $listPath = Join-Path $stageDir "list.txt"
        $scriptPath = Join-Path $stageDir "run_pcode_job.m"

        $staged = @()
        $stageRelMap = @{}
        foreach ($item in $Chunk) {
            $origRel = $item.Source.Substring($SrcRoot.Length).TrimStart("\", "/")
            $dstRel = $origRel
            $dst = Join-Path $stageDir $dstRel
            $dstDir = Split-Path -Parent $dst
            if (-not (Test-Path -LiteralPath $dstDir)) {
                New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
            }
            $content = Get-Content -LiteralPath $item.Source -Raw
            $lines = $content -split "`r?`n"
            $firstFunc = -1
            $firstClass = -1
            for ($i = 0; $i -lt $lines.Count; $i++) {
                if ($firstClass -lt 0 -and $lines[$i] -match "^\s*classdef\b") {
                    $firstClass = $i
                }
                if ($lines[$i] -match "^\s*function\s") {
                    $firstFunc = $i
                    break
                }
            }
            $isClassdef = ($firstClass -ge 0 -and ($firstFunc -lt 0 -or $firstClass -lt $firstFunc))
            $needsWrap = $false
            if (-not $isClassdef -and $firstFunc -ge 0) {
                for ($i = 0; $i -lt $firstFunc; $i++) {
                    $line = $lines[$i].Trim()
                    if ($line.Length -eq 0) { continue }
                    if ($line.StartsWith("%")) { continue }
                    $needsWrap = $true
                    break
                }
            }
            if ($needsWrap) {
                $base = [System.IO.Path]::GetFileNameWithoutExtension($dst)
                $wrapBase = Get-ValidFunctionName -Name $base
                if ($wrapBase -ne $base) {
                    $relDir = Split-Path -Parent $origRel
                    if ([string]::IsNullOrWhiteSpace($relDir)) {
                        $dstRel = $wrapBase + ".m"
                    } else {
                        $dstRel = Join-Path $relDir ($wrapBase + ".m")
                    }
                    $dst = Join-Path $stageDir $dstRel
                    $dstDir = Split-Path -Parent $dst
                    if (-not (Test-Path -LiteralPath $dstDir)) {
                        New-Item -ItemType Directory -Force -Path $dstDir | Out-Null
                    }
                }
                $prefix = if ($firstFunc -gt 0) { ($lines[0..($firstFunc - 1)] -join "`n") } else { "" }
                $suffix = ($lines[$firstFunc..($lines.Count - 1)] -join "`n")
                $newText = "function $wrapBase()`n$prefix`nend`n$suffix`n"
                Set-Content -Path $dst -Value $newText -Encoding ASCII
            } else {
                Set-Content -Path $dst -Value $content -Encoding ASCII
            }
            $stageRelMap[$origRel] = $dstRel
            $staged += $dst
        }

        $mapPath = Join-Path $stageDir "stage_map.csv"
        $stageRelMap.GetEnumerator() | ForEach-Object {
            "$($_.Key),$($_.Value)"
        } | Set-Content -Path $mapPath -Encoding ASCII

        $staged | Set-Content -Path $listPath -Encoding ASCII

        $escapedList = $listPath.Replace("'", "''")
        $script = @"
try
  fid = fopen('$escapedList','r');
  if fid < 0, error('Cannot open list'); end
  while true
    tline = fgetl(fid);
    if ~ischar(tline), break; end
    if isempty(tline), continue; end
    try
      pcode('-inplace', tline);
    catch ME
      disp(getReport(ME,'extended'));
    end
  end
  fclose(fid);
catch ME
  disp(getReport(ME,'extended'));
end
exit
"@
        $script | Set-Content -Path $scriptPath -Encoding ASCII

        $escapedScript = $scriptPath.Replace("'", "''")
        $runCmd = "run('$escapedScript')"
        $proc = Start-Process -FilePath $MatlabExe -ArgumentList @("-nosplash", "-nodesktop", "-logfile", $LogPath, "-r", $runCmd) -PassThru -WindowStyle Hidden
        $proc.WaitForExit()
        $exitCode = $proc.ExitCode

        if (-not $KeepM) {
            Get-ChildItem -Path $stageDir -Recurse -Filter *.m -File | Remove-Item -Force -ErrorAction SilentlyContinue
        }

        [pscustomobject]@{
            JobId = $JobId
            ExitCode = $exitCode
            Count = @($Chunk).Count
            StageDir = $stageDir
            LogPath = $LogPath
        }
    }
}

$results = $jobs | Wait-Job | Receive-Job
$jobs | Remove-Job

$stageRootExists = Test-Path -LiteralPath $stageRoot
Write-Host ("StageRoot: {0}" -f $stageRoot)
Write-Host ("StageRoot exists: {0}" -f $stageRootExists)

if ($stageRootExists) {
    Wait-StageOutputs -StageRoot $stageRoot -ExpectedCount $map.Count
}

$stageMaps = @()
if ($stageRootExists) {
    $wait = [System.Diagnostics.Stopwatch]::StartNew()
    while ($wait.Elapsed.TotalSeconds -lt 10) {
        $stageMaps = @(Get-ChildItem -Path $stageRoot -Recurse -Filter stage_map.csv -File -ErrorAction SilentlyContinue)
        if ($stageMaps -and $stageMaps.Count -gt 0) { break }
        Start-Sleep -Seconds 1
    }
}

$stageRelMap = @{}
if ($stageMaps -is [string]) {
    $stageMaps = @(Get-Item -LiteralPath $stageMaps -ErrorAction SilentlyContinue | Where-Object { $_ })
} elseif ($stageMaps -is [System.IO.FileInfo]) {
    $stageMaps = @($stageMaps)
}
foreach ($mapFile in $stageMaps) {
    $mapPath = if ($mapFile.PSObject.Properties.Match('FullName').Count -gt 0) { $mapFile.FullName } else { [string]$mapFile }
    if ([string]::IsNullOrWhiteSpace($mapPath)) { continue }
    if (-not (Test-Path -LiteralPath $mapPath) -and $stageRootExists) {
        $candidate = Join-Path $stageRoot $mapPath
        if (Test-Path -LiteralPath $candidate) {
            $mapPath = $candidate
        } else {
            continue
        }
    }
    $jobDir = Split-Path -Parent $mapPath
    $lines = @(Get-Content -LiteralPath $mapPath -Encoding ASCII -ErrorAction SilentlyContinue)
    foreach ($line in $lines) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        $parts = $line.Split(",", 2)
        if ($parts.Count -lt 2) { continue }
        $origRel = $parts[0].Trim()
        $stageRel = $parts[1].Trim()
        if ([string]::IsNullOrWhiteSpace($origRel) -or [string]::IsNullOrWhiteSpace($stageRel)) { continue }
        $origRelP = [System.IO.Path]::ChangeExtension($origRel, ".p")
        $stageRelP = [System.IO.Path]::ChangeExtension($stageRel, ".p")
        $stageP = Join-Path $jobDir $stageRelP
        if (-not $stageRelMap.ContainsKey($origRelP)) {
            $stageRelMap[$origRelP] = $stageP
        }
    }
}
Write-Host ("StageRelMap: {0}" -f $stageRelMap.Count)

$stageIndex = @{}
Get-ChildItem -Path $stageRoot -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $jobDir = $_.FullName
    Get-ChildItem -Path $jobDir -Recurse -Filter *.p -File -ErrorAction SilentlyContinue | ForEach-Object {
        $rel = $_.FullName.Substring($jobDir.Length).TrimStart("\", "/")
        if (-not $stageIndex.ContainsKey($rel)) {
            $stageIndex[$rel] = $_.FullName
        }
    }
}

$flatMap = @{}
foreach ($item in $map) {
    $rel = $item.Source.Substring($srcRoot.Length).TrimStart("\", "/")
    $relP = [System.IO.Path]::ChangeExtension($rel, ".p")
    $flatP = [System.IO.Path]::ChangeExtension($item.FlatName, ".p")
    if (-not $flatMap.ContainsKey($relP)) {
        $flatMap[$relP] = $flatP
    }
}

$copiedPrimary = 0
foreach ($relP in $flatMap.Keys) {
    if ($stageRelMap.ContainsKey($relP)) {
        $dst = Join-Path $outRoot $flatMap[$relP]
        $src = $stageRelMap[$relP]
        if (-not (Test-Path -LiteralPath $dst) -and (Test-Path -LiteralPath $src)) {
            Copy-Item -LiteralPath $src -Destination $dst -Force
            $copiedPrimary++
        }
    }
}
if ($copiedPrimary -gt 0) {
    Write-Host ("Primary: copied {0} .p files from stage maps." -f $copiedPrimary)
}

$copiedFallback = 0
$missing = @()
foreach ($item in $map) {
    $rel = $item.Source.Substring($srcRoot.Length).TrimStart("\", "/")
    $relP = [System.IO.Path]::ChangeExtension($rel, ".p")
    $flatP = [System.IO.Path]::ChangeExtension($item.FlatName, ".p")
    $dst = Join-Path $outRoot $flatP
    if (-not (Test-Path -LiteralPath $dst)) {
        if ($stageRelMap.ContainsKey($relP)) {
            $src = $stageRelMap[$relP]
            if (Test-Path -LiteralPath $src) {
                Copy-Item -LiteralPath $src -Destination $dst -Force
                $copiedFallback++
            }
        } elseif ($stageIndex.ContainsKey($relP)) {
            Copy-Item -LiteralPath $stageIndex[$relP] -Destination $dst -Force
            $copiedFallback++
        } else {
            $missing += $item.Source
        }
    }
}
if ($copiedFallback -gt 0) {
    Write-Host ("Fallback: copied {0} .p files from stage." -f $copiedFallback)
}
if ($missing.Count -gt 0) {
    $excludeFile = Join-Path $outRoot "exclude_m_files.txt"
    $missing | Set-Content -Path $excludeFile -Encoding ASCII
    Write-Warning ("Missing pcode outputs: {0} (list in {1})" -f $missing.Count, $excludeFile)
}

if ($missing.Count -gt 0 -and $stageRootExists) {
    $extra = Copy-FromStageMaps -StageRoot $stageRoot -FlatMap $flatMap -OutRoot $outRoot
    if ($extra -gt 0) {
        $missing = @()
        foreach ($item in $map) {
            $flatP = [System.IO.Path]::ChangeExtension($item.FlatName, ".p")
            $dst = Join-Path $outRoot $flatP
            if (-not (Test-Path -LiteralPath $dst)) {
                $missing += $item.Source
            }
        }
        $excludeFile = Join-Path $outRoot "exclude_m_files.txt"
        if ($missing.Count -gt 0) {
            $missing | Set-Content -Path $excludeFile -Encoding ASCII
            Write-Warning ("Missing pcode outputs (post-map): {0} (list in {1})" -f $missing.Count, $excludeFile)
        } elseif (Test-Path -LiteralPath $excludeFile) {
            Set-Content -Path $excludeFile -Value "" -Encoding ASCII
        }
    }
}

if (-not $KeepStage) {
    Remove-Item -LiteralPath $stageRoot -Recurse -Force -ErrorAction SilentlyContinue
}

$failed = $false
foreach ($r in $results) {
    if ($r.ExitCode -ne 0) {
        $failed = $true
        Write-Warning ("Job {0} failed (exit {1}). Log: {2}" -f $r.JobId, $r.ExitCode, $r.LogPath)
        if ($KeepStage) {
            Write-Warning ("Stage kept: {0}" -f $r.StageDir)
        }
    } else {
        Write-Host ("Job {0} done ({1} files). Log: {2}" -f $r.JobId, $r.Count, $r.LogPath)
    }
}

if ($failed) {
    throw "One or more jobs failed. Check logs under $logDir."
}
