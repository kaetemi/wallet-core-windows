
# Downloads and builds dependencies for Windows

#This script downloads third-party dependencies .By tools\Windows-dependencies.Ps1 calls.



$ErrorActionPreference = "Stop"


$root = $pwd
$prefix = Join-Path $pwd "build\local"
$include = Join-Path $prefix "include"

# Load dependencies version
. $PSScriptRoot\windows-dependencies-version.ps1



# GoogleTest
function download_gtest
{
    Write-Host "Downloading gtest..."
    $gtestDir = Join-Path $prefix "src\gtest"
    $gtestZip = "googletest-release-$gtestVersion.zip"
    $gtestUrl = "https://github.com/google/googletest/archive/refs/tags/release-$gtestVersion.zip"
    # Download and extract
    if (-not(Test-Path -Path $gtestDir -PathType Container)) 
    {
        mkdir $gtestDir | Out-Null
    }
    cd $gtestDir
    if (-not(Test-Path -Path $gtestZip -PathType Leaf)) 
    {
        Invoke-WebRequest -Uri $gtestUrl -OutFile $gtestZip
    }
    if (Test-Path -Path googletest-release-$gtestVersion -PathType Container) 
    {
         Remove-Item 每Path googletest-release-$gtestVersion -Recurse
    }
    Expand-Archive -LiteralPath $gtestZip -DestinationPath $gtestDir
}
# Check
function download_libcheck
{
    Write-Host "Downloading libcheck..."
    $checkDir = Join-Path $prefix "src\check"
    $checkZip = "check-$checkVersion.zip"
    $checkUrl = "https://codeload.github.com/libcheck/check/zip/refs/tags/$checkVersion"

    # Download and extract
    if (-not(Test-Path -Path $checkDir -PathType Container)) 
    {
        mkdir $checkDir | Out-Null
    }
    cd $checkDir
    if (-not(Test-Path -Path $checkZip -PathType Leaf)) 
    {
        Invoke-WebRequest -Uri $checkUrl -OutFile $checkZip
    }
    if (Test-Path -Path check-$checkVersion -PathType Container) 
    {
         Remove-Item 每Path check-$checkVersion -Recurse
    }
    Expand-Archive -LiteralPath $checkZip -DestinationPath $checkDir

}

# Nlohmann JSON
function download_nolhmann_json
{

    Write-Host "Downloading Nlohmann JSON..."
    $jsonDir = Join-Path $prefix "include\nlohmann"
    $jsonUrl = "https://github.com/nlohmann/json/releases/download/v$jsonVersion/json.hpp"
    $jsonFile = Join-Path $jsonDir "json.hpp"
    if (Test-Path -Path $jsonFile -PathType Leaf) {
        Remove-Item 每Path $jsonFile
    }
    if (-not(Test-Path -Path $jsonDir -PathType Container)) {
        mkdir $jsonDir | Out-Null
    }
    Invoke-WebRequest -Uri $jsonUrl -OutFile $jsonFile
}

# Boost
function download_and_move_include_boost
{
    Write-Host "Downloading boost..."
    
    $boostVersionU = $boostVersion.Replace(".", "_")
    $boostDir = Join-Path $prefix "src\boost"
    $boostZip = "boost_$boostVersionU.zip"
    $boostUrl = "https://nchc.dl.sourceforge.net/project/boost/boost/$boostVersion/$boostZip"

    # Download and extract
    if (-not(Test-Path -Path $boostDir -PathType Container)) 
    {
        mkdir $boostDir | Out-Null
    }
    cd $boostDir
    if (-not(Test-Path -Path $boostZip -PathType Leaf)) 
    {
        Invoke-WebRequest -Uri $boostUrl -OutFile $boostZip
    }
    if (Test-Path -Path boost_$boostVersionU -PathType Container) 
    {
         Remove-Item 每Path boost_$boostVersionU -Recurse
    }

    # Expand-Archive -LiteralPath $boostZip -DestinationPath $boostDir
    $boostZipPath = Join-Path $boostDir $boostZip
    Add-Type -Assembly "System.IO.Compression.Filesystem"
    [System.IO.Compression.ZipFile]::ExtractToDirectory($boostZipPath, $boostDir)

    #move include
    if (-not(Test-Path -Path $include -PathType Container)) 
    {
        mkdir $include | Out-Null
    }
    $boostInclude = Join-Path $include "boost"
    if (Test-Path -Path $boostInclude -PathType Container) 
    {
         Remove-Item 每Path $boostInclude -Recurse
    }
    $boostSrcInclude = Join-Path $boostDir "boost_$boostVersionU\boost"
    move $boostSrcInclude $boostInclude

}

function download_protobuf
{
    Write-Host "Downloading Protobuf..."

    # Protobuf
    $protobufVersion = "3.19.2"
    $protobufDir = Join-Path $prefix "src\protobuf"
    $protobufZip = "protobuf-cpp-$protobufVersion.zip"
    $protobufUrl = "https://github.com/protocolbuffers/protobuf/releases/download/v$protobufVersion/$protobufZip"

    # Download and extract
    if (-not(Test-Path -Path $protobufDir -PathType Container)) {
        mkdir $protobufDir | Out-Null
    }
    cd $protobufDir
    if (-not(Test-Path -Path $protobufZip -PathType Leaf)) {
        Invoke-WebRequest -Uri $protobufUrl -OutFile $protobufZip
    }
    if (Test-Path -Path protobuf-$protobufVersion -PathType Container) {
         Remove-Item 每Path protobuf-$protobufVersion -Recurse
    }
    Expand-Archive -LiteralPath $protobufZip -DestinationPath $protobufDir
}


download_gtest
download_libcheck
download_nolhmann_json
download_protobuf
download_and_move_include_boost

cd $root
