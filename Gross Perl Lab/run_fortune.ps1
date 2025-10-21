# Helper to run the fortune_escalator.pl script with a friendly check for Perl
param()

$perl = Get-Command perl -ErrorAction SilentlyContinue
if (-not $perl) {
    Write-Host "Perl executable not found in PATH."
    Write-Host "Please install Strawberry Perl (https://strawberryperl.com/) or ActivePerl and ensure 'perl' is on your PATH."
    exit 1
}

$script = Join-Path -Path $PSScriptRoot -ChildPath 'fortune_escalator.pl'
if (-not (Test-Path $script)) {
    Write-Host "Cannot find $script"
    exit 
}

perl $script
