# Build Wallet Core

# Run after installing `dependencies` and `generating` code
# > powershell .\tools\windows-build-and-test.ps1

# Builds Wallet Core in static release mode, to build the console wallet
# Builds Wallet Core in dynamic release and debug mode, to build a DLL for applications



# Fail if any commands fails
$ErrorActionPreference = "Stop"

#Set the position of the toolchain = $toolsPath
$toolsPath = $PSScriptRoot

echo "#### Generating files... ####"
& $toolsPath\windows-generate.ps1


echo "#### Building... ####"	
& $toolsPath\windows-build.ps1

& $toolsPath\windows-tests.ps1

