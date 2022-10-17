#!/usr/bin/env bash

# > powershell .\windows-bootstrap

# Ported from the `bootstrap.sh` bash script
# Initializes the workspace with dependencies, then performs full build

# Fail if any commands fails
$ErrorActionPreference = "Stop"

#Set the position of the toolchain = $toolsPath
$toolsPath = Join-Path $PSScriptRoot "tools"

Write-Host "#### Initializing workspace with dependencies ... ####"
& $toolsPath\windows-dependencies.ps1

Write-Host "#### Building and running tests ... ####"
& $toolsPath\windows-build-and-test.ps1


