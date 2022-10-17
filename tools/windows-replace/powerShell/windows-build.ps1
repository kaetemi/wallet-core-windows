# Load dependencies version
. $PSScriptRoot\windows-dependencies-version.ps1

$root = $pwd
$prefix = Join-Path $pwd "build\local"
$install = Join-Path $pwd "build\install"


if (Test-Path -Path $install -PathType Container) {
	Remove-Item ¨CPath $install -Recurse
}

cd build

if (-not(Test-Path -Path "static" -PathType Container)) {
    mkdir "static" | Out-Null
}
cd static
cmake -G $cmakeGenerator -A $cmakePlatform -T $cmakeToolset "-DCMAKE_PREFIX_PATH=$prefix" "-DCMAKE_INSTALL_PREFIX=$install" "-DCMAKE_BUILD_TYPE=Release" "-DTW_STATIC_LIBRARY=ON" ../..
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
cmake --build . --target INSTALL --config Release
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
$libInstall = Join-Path $install "lib\TrustWalletCore.lib"
Remove-Item ¨CPath $libInstall # Replaced with the shared lib afterwards
cd ..

if (-not(Test-Path -Path "shared" -PathType Container)) {
    mkdir "shared" | Out-Null
}
cd shared
cmake -G $cmakeGenerator -A $cmakePlatform -T $cmakeToolset "-DCMAKE_PREFIX_PATH=$prefix" "-DCMAKE_INSTALL_PREFIX=$install" "-DCMAKE_BUILD_TYPE=Release" "-DCMAKE_DEBUG_POSTFIX=d" "-DTW_STATIC_LIBRARY=OFF" ../..
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
cmake --build . --target INSTALL --config Debug
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
$pdbBuild = Join-Path $root "build\shared\Debug\TrustWalletCored.pdb"
$pdbInstall = Join-Path $install "bin\TrustWalletCored.pdb"
copy $pdbBuild $pdbInstall
cmake --build . --target INSTALL --config Release
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}
$cppInclude = Join-Path $install "include\WalletCore"
Remove-Item ¨CPath $cppInclude -Recurse # Useless from shared library
cd ..

cd $root
