#!/usr/bin/perl

if ($#ARGV+1 != 1 ) {

	print "Enter the command: -e or -r,\n";
	print " -e : extract command is used to extract the modified source code to a tools file.\n";
	print " -r : replace command is used to replace the source code file.\n";
	exit;
}

$op=$ARGV[0];

@trezor_crypto_file = (
	"trezor-crypto/crypto/rand.c",
	"trezor-crypto/crypto/base32.c",
	"trezor-crypto/crypto/base58.c",
	"trezor-crypto/crypto/bignum.c",
	"trezor-crypto/crypto/blake2b.c",
	"trezor-crypto/crypto/blake2s.c",
	"trezor-crypto/crypto/cardano.c",
	"trezor-crypto/crypto/shamir.c",
	"trezor-crypto/crypto/sha3.c",
	"trezor-crypto/crypto/tests/test_check.c",
	"trezor-crypto/crypto/tests/CMakeLists.txt", 
	"trezor-crypto/crypto/monero/base58.c",
	"trezor-crypto/include/TrezorCrypto/ed25519-donna/ed25519-donna-portable.h",
	"trezor-crypto/include/TrezorCrypto/groestl_internal.h",
	"trezor-crypto/include/TrezorCrypto/nist256p1.h",
	"trezor-crypto/include/TrezorCrypto/rand.h",
	"trezor-crypto/include/TrezorCrypto/aes.h",
	"trezor-crypto/include/TrezorCrypto/endian.h",
	"trezor-crypto/CMakeLists.txt"
);

@src_file = (
	"src/Base32.h",
	"src/BinaryCoding.h",
	"src/HDWallet.cpp",
	"src/Aptos/MoveTypes.cpp",
	"src/Everscale/Cell.h",
	"src/Everscale/Cell.cpp",
	"src/Everscale/CellSlice.h",
	"src/NULS/Address.cpp",
	"src/Ethereum/ABI/ParamFactory.cpp",
	"src/interface/TWBitcoinScript.cpp",
	"src/Keystore/EncryptionParameters.cpp"
);

@tests_file = (
	"tests/chains/Bitcoin/MessageSignerTests.cpp",
	"tests/chains/Cardano/SigningTests.cpp",
	"tests/chains/Cardano/TWCardanoAddressTests.cpp",
	"tests/chains/Polkadot/SignerTests.cpp",
	"tests/chains/Zilliqa/SignerTests.cpp",
	"tests/chains/Aptos/MoveTypesTests.cpp",
	"tests/common/BCSTests.cpp",
	"tests/CMakeLists.txt",
	"tests/main.cpp"
);


@include_file = (
	"include/TrustWalletCore/TWBase.h",
	"include/TrustWalletCore/TWString.h",
	"include/TrustWalletCore/TWAnySigner.h"
);

@walletconsole_file = (
	"walletconsole/CMakeLists.txt",
	"walletconsole/lib/CMakeLists.txt"
);

@cmake_file = (
	"cmake/Protobuf.cmake",
	"cmake/CompilerWarnings.cmake"

);

@wallet_cmakeLists_file = (
	"CMakeLists.txt"
);

@protobuf_plugin_file = (
	"protobuf-plugin/CMakeLists.txt"
);

@windows_tools_file =(
	"tools/windows-build.ps1",
	"tools/windows-build-and-test.ps1",
	"tools/windows-dependencies.ps1",
	"tools/windows-dependencies-version.ps1",
	"tools/windows-download-dependencies.ps1",
	"tools/windows-doxygen_convert_comments.ps1",
	"tools/windows-generate.ps1",
	"tools/windows-replace-file.p1",
	"tools/windows-samples.ps1",
	"tools/windows-tests.ps1",
);
#完整路径
sub addFullPath
{
	@pathAndCMD = @_;

	$prefixPathName = $_[0];

	for($a = 1;$a < $#pathAndCMD + 1;$a = $a + 1)
	{
		$pathAndCMD[$a] = join( "", $pathAndCMD[0] ,$pathAndCMD[$a] );
	}
	return @pathAndCMD;
	
}

#拷贝文件
sub copyFile
{
	#my($walletPath,$toolsPath) = @_;
	my($fromPath,$toPath) = @_;

	use File::Copy;
	for($a = 1;$a < @$fromPath;$a = $a + 1)
	{
=pod
		print "\n";
		print "fromPath = ",$fromPath->[$a],"\n";
		print "toPath = ",$toPath->[$a],"\n";
		print "\n";
=cut
		copy $fromPath->[$a] , $toPath->[$a] or warn 'copy failed.';
	}
				
}

#path-->  /wallet-core-win
use Cwd;
$TWdir = getcwd;

$TWdir =  join( "", $TWdir ,"/" );

#path--> tools/windows-replace/
$toolsDir = join( "", $TWdir,"tools/windows-replace/" );

#trezor_crypto文件
@wallet_trezor_crypto_path = addFullPath($TWdir,@trezor_crypto_file);
@tools_trezor_crypto_path = addFullPath($toolsDir,@trezor_crypto_file);

#src
@wallet_src_path = addFullPath($TWdir,@src_file);
@tools_src_path = addFullPath($toolsDir,@src_file);

#tests
@wallet_tests_path = addFullPath($TWdir,@tests_file);
@tools_tests_path = addFullPath($toolsDir,@tests_file);

#include
@wallet_include_path = addFullPath($TWdir,@include_file);
@tools_include_path = addFullPath($toolsDir,@include_file);

#walletconsole
@wallet_walletconsole_path = addFullPath($TWdir,@walletconsole_file);
@tools_walletconsole_path = addFullPath($toolsDir,@walletconsole_file);

#protobuf_plugin
@wallet_protobuf_plugin_path = addFullPath($TWdir,@protobuf_plugin_file);
@tools_protobuf_plugin_path = addFullPath($toolsDir,@protobuf_plugin_file);

#cmake
@wallet_cmake_path = addFullPath($TWdir,@cmake_file);
@tools_cmake_path = addFullPath($toolsDir,@cmake_file);

# wallet_cmakeLists
@wallet_cmakeLists_path = addFullPath($TWdir,@wallet_cmakeLists_file);
@tools_wallet_cmakeLists_path = addFullPath($toolsDir,@wallet_cmakeLists_file);



if ($op eq "-e")
{

	#copy trezor_crypto文件
	copyFile(\@wallet_trezor_crypto_path ,\@tools_trezor_crypto_path);

	#copy src	
	copyFile(\@wallet_src_path ,\@tools_src_path);

	#copy test	
	copyFile(\@wallet_tests_path ,\@tools_tests_path);
 
	#copy include
	copyFile(\@wallet_include_path ,\@tools_include_path);

	#copy walletconsole
	copyFile(\@wallet_walletconsole_path ,\@tools_walletconsole_path);

	#copy protobuf_plugin_
	copyFile(\@wallet_protobuf_plugin_path ,\@tools_protobuf_plugin_path);

	#copy cmake
	copyFile(\@wallet_cmake_path ,\@tools_cmake_path);

	#copy cmakeLists
	copyFile(\@wallet_cmakeLists_path ,\@tools_wallet_cmakeLists_path);
}
elsif($op eq "-r")
{
	#tools替换源码
	#copy trezor_crypto文件
	copyFile(\@tools_trezor_crypto_path,\@wallet_trezor_crypto_path );

	#copy src	
	copyFile(\@tools_src_path,\@wallet_src_path );

	#copy test	
	copyFile(\@tools_tests_path,\@wallet_tests_path );
 
	#copy include
	copyFile(\@tools_include_path,\@wallet_include_path);

	#copy walletconsole
	copyFile(\@tools_walletconsole_path,\@wallet_walletconsole_path );

	#copy protobuf_plugin_
	copyFile(\@tools_protobuf_plugin_path,\@wallet_protobuf_plugin_path);

	#copy cmake
	copyFile(\@tools_cmake_path,\@wallet_cmake_path );

	#copy cmakeLists
	copyFile(\@tools_wallet_cmakeLists_path,\@wallet_cmakeLists_path);
}
else{

	print "Enter the command: -e or -r,\n";
	print " -e : extract command is used to extract the modified source code to a tools file.\n";
	print " -r : replace command is used to replace the source code file.\n";
	exit;
}




