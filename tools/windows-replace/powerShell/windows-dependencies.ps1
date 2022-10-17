
# Downloads and builds dependencies for Windows
# Run this PowerShell script from the repository root folder
# > powershell .\tools\windows-dependencies.ps1

# Ported from the `install-dependencies` bash script

# GoogleTest
# Check
# Downloads the single-header Nlohmann JSON library
# Downloads boost library, only require the headers
# Downloads and builds Protobuf in static debug and release mode, with dynamic C runtime
# Builds the Wallet Core protobuf plugins in release mode


$ErrorActionPreference = "Stop"

$root = $pwd
$prefix = Join-Path $pwd "build\local"
$include = Join-Path $prefix "include"

# Load dependencies version
. $PSScriptRoot\windows-dependencies-version.ps1




function download_dependencies 
{
    & $PSScriptRoot\windows-download-dependencies.ps1
}

# GoogleTest
function build_gtest
{
   # Build debug and release libraries
    $gtest_dir = Join-Path $root "build\local\src\gtest\googletest-release-$gtestVersion" 
    cd $gtest_dir
    if (Test-Path -Path build_msvc -PathType Container) 
    {
         Remove-Item ¨CPath build_msvc -Recurse
    }
    mkdir build_msvc | Out-Null
    cd build_msvc
    cmake -G $cmakeGenerator -A $cmakePlatform -T $cmakeToolset "-DCMAKE_INSTALL_PREFIX=$prefix" "-DCMAKE_DEBUG_POSTFIX=d" "-DCMAKE_BUILD_TYPE=Release" "-Dgtest_force_shared_crt=ON" ..
    if ($LASTEXITCODE -ne 0) 
    {
        exit $LASTEXITCODE
    }
    cmake --build . --target INSTALL --config Debug
    if ($LASTEXITCODE -ne 0) 
    {
        exit $LASTEXITCODE
    }
    cmake --build . --target INSTALL --config Release
    if ($LASTEXITCODE -ne 0) 
    {
        exit $LASTEXITCODE
    }
}

#check
function build_libcheck
{
    # Build debug and release libraries
    $check_dir = Join-Path $root "build\local\src\check\check-$checkVersion" 
    cd $check_dir
    if (-not(Test-Path -Path $check_dir\build_msvc -PathType Container))
    {
        mkdir build_msvc | Out-Null
    }
    cd build_msvc
    cmake -G $cmakeGenerator -A $cmakePlatform -T $cmakeToolset "-DCMAKE_INSTALL_PREFIX=$prefix" "-DCMAKE_DEBUG_POSTFIX=d" "-DCMAKE_BUILD_TYPE=Release" ..
    if ($LASTEXITCODE -ne 0) 
    {
        exit $LASTEXITCODE
    }
    cmake --build . --target INSTALL --config Debug
    if ($LASTEXITCODE -ne 0) 
    {
        exit $LASTEXITCODE
    }
    cmake --build . --target INSTALL --config Release
    if ($LASTEXITCODE -ne 0) 
    {
        exit $LASTEXITCODE
    }
}

#protobuf
function build_protobuf
{
    # Build debug and release libraries
    $protobuf_dir = Join-Path $root "build\local\src\protobuf\protobuf-$protobufVersion" 
    cd $protobuf_dir
    if (Test-Path -Path build_msvc -PathType Container) 
    {
         Remove-Item ¨CPath build_msvc -Recurse
    }
    mkdir build_msvc | Out-Null
    cd build_msvc
    $protobufCMake = Get-Content ..\cmake\CMakeLists.txt # Bugfix
    $protobufCMake = $protobufCMake.Replace("set(CMAKE_MSVC_RUNTIME_LIBRARY MultiThreaded$<$<CONFIG:Debug>:Debug>)",
        "if (MSVC AND protobuf_MSVC_STATIC_RUNTIME)`r`nset(CMAKE_MSVC_RUNTIME_LIBRARY MultiThreaded$<$<CONFIG:Debug>:Debug>)`r`nendif()") # Bugfix
    $protobufCMake | Out-File -encoding UTF8 ..\cmake\CMakeLists.txt # Bugfix
    cmake -G $cmakeGenerator -A $cmakePlatform -T $cmakeToolset "-DCMAKE_INSTALL_PREFIX=$prefix" "-DCMAKE_BUILD_TYPE=Release" "-Dprotobuf_WITH_ZLIB=OFF" "-Dprotobuf_MSVC_STATIC_RUNTIME=OFF" "-Dprotobuf_BUILD_TESTS=OFF" "-Dprotobuf_BUILD_SHARED_LIBS=OFF" ../cmake
    if ($LASTEXITCODE -ne 0) 
    {
        exit $LASTEXITCODE
    }
    cmake --build . --target INSTALL --config Debug
    if ($LASTEXITCODE -ne 0) 
    {
        exit $LASTEXITCODE
    }
    cmake --build . --target INSTALL --config Release
    if ($LASTEXITCODE -ne 0) 
    {
        exit $LASTEXITCODE
    }

    build_swift_plugin
}

# Protobuf plugins
function build_swift_plugin
{    
    $pluginSrc = Join-Path $root "protobuf-plugin"
    cd $pluginSrc
    if (Test-Path -Path build -PathType Container) 
    {
         Remove-Item ¨CPath build -Recurse
    }
    mkdir build | Out-Null
    cd build
    cmake -G $cmakeGenerator -A $cmakePlatform -T $cmakeToolset "-DCMAKE_INSTALL_PREFIX=$prefix" "-DCMAKE_BUILD_TYPE=Release" ..
    if ($LASTEXITCODE -ne 0) 
    {
        exit $LASTEXITCODE
    }
    cmake --build . --target INSTALL --config Release
    if ($LASTEXITCODE -ne 0) 
    {
        exit $LASTEXITCODE
    }
}



download_dependencies

build_gtest
build_libcheck
build_protobuf
echo "`n`n"
echo "--------------------done...."

cd $root
