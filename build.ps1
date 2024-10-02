param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$MainFile
)

# Remove .tex extension if it was specified
$MAIN_FILE = [System.IO.Path]::GetFileNameWithoutExtension($MainFile)

# Function to display a spinning cursor
function Show-Spinner {
    param(
        [int]$Duration = 10
    )
    $spinChars = '|', '/', '-', '\'
    $startTime = Get-Date
    $i = 0

    do {
        Write-Host "`r$($spinChars[$i % 4]) Processing..." -NoNewline
        Start-Sleep -Milliseconds 100
        $i++
    } while ((Get-Date).Subtract($startTime).TotalSeconds -lt $Duration)

    Write-Host "`r" -NoNewline
}

# Function to execute command and check for errors
function Invoke-Command($command, $arguments) {
    Write-Host "Executing: $command $arguments" -ForegroundColor Cyan
    $job = Start-Job -ScriptBlock {
        param($cmd, $args)
        & $cmd $args 2>&1
    } -ArgumentList $command, $arguments

    while ($job.State -eq 'Running') {
        Show-Spinner -Duration 1
    }

    $output = Receive-Job -Job $job
    Remove-Job -Job $job

    $output | ForEach-Object { Write-Host $_ }

    if ($LASTEXITCODE -ne 0) {
        Write-Host "Warning: Command exited with code: $LASTEXITCODE" -ForegroundColor Yellow
        return $false
    }
    return $true
}

# Check if file exists
if (-not (Test-Path "$MAIN_FILE.tex")) {
    Write-Host "Error: File $MAIN_FILE.tex not found." -ForegroundColor Red
    exit 1
}

# Function to run XeLaTeX
function Run-XeLaTeX {
    return Invoke-Command "xelatex" "-synctex=1 -interaction=nonstopmode $MAIN_FILE.tex"
}

# Function to run Biber

function Run-Biber {
    return Invoke-Command "biber" "$MAIN_FILE.bcf"
}

# Main compilation loop
$maxIterations = 5
$iteration = 0
$success = $false

while ($iteration -lt $maxIterations -and -not $success) {
    $iteration++
    Write-Host "Compilation iteration $iteration" -ForegroundColor Green

    # Run XeLaTeX
    Write-Host "Running XeLaTeX..." -ForegroundColor Green
    $xelatexSuccess = Run-XeLaTeX

    # Run Biber
    Write-Host "Running Biber..." -ForegroundColor Green
    $biberSuccess = Run-Biber

    # Check if both XeLaTeX and Biber were successful
    if ($xelatexSuccess -and $biberSuccess) {
        $success = $true
    }
}

if ($success) {
    Write-Host "Compilation of $MAIN_FILE.tex completed successfully." -ForegroundColor Green
} else {
    Write-Host "Warning: Compilation completed with potential issues." -ForegroundColor Yellow
    Write-Host "Please check the $MAIN_FILE.log file for more details." -ForegroundColor Yellow

    $openLog = Read-Host "Do you want to open the log file? (Y/N)"
    if ($openLog -eq 'Y' -or $openLog -eq 'y') {
        Start-Process notepad "$MAIN_FILE.log"
    }
}

Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')