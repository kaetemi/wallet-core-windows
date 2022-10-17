
# Build Samples

# Load dependencies version
. $PSScriptRoot\windows-dependencies-version.ps1

$ErrorActionPreference = "Stop"

$root = $pwd
$prefix = Join-Path $pwd "build\local"
$install = Join-Path $pwd "build\install"


cd samples\cpp
if (-not(Test-Path -Path "build" -PathType Container)) {
    mkdir "build" | Out-Null
}
cd build
cmake -G $cmakeGenerator -A $cmakePlatform -T $cmakeToolset "-DCMAKE_BUILD_TYPE=Release" "-DWALLET_CORE=$root" ..
cmake --build . --config Release
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
$dllInstall = Join-Path $install "bin\TrustWalletCore.dll"
$dllCopy = Join-Path $root "samples\cpp\build\Release\TrustWalletCore.dll"
copy $dllInstall $dllCopy

cd $root
