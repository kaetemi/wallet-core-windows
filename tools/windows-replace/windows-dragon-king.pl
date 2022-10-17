if ($#ARGV+1 != 1 ) {

	print "Enter the command: -spouting or -suction,\n";
	print " -spouting : Place Windows dependencies in the tools folder and project home directory.\n";
	print " -suction : Bring Windows dependencies back into the tools folder.\n";
	exit;
}
sub replace_head
{
	@toolsPath = @_;
	@TWtoolsFiles;
	for($a = 0;$a < $#toolsPath + 1;$a = $a + 1)
	{
		 $toolsPathString = join("",$toolsPath[$a]);
		 my $stringPos = rindex($toolsPathString,"/");
		 my $toolsName = substr($toolsPathString,$stringPos + 1);

		 my $TWtoolsFilesString = join( "",$tools_Dir ,$toolsName );
		 $TWtoolsFiles[$a] =  $TWtoolsFilesString;
	}
	return @TWtoolsFiles;
	
}


$op=$ARGV[0];
#path-->  /wallet-core-win
use Cwd;
$TWdir = getcwd;

$TWdir =  join( "", $TWdir ,"/" );

#path--> tools/
$tools_Dir = join( "", $TWdir,"tools/" );


#path--> tools/windows-replace/
$tools_windowsReplace_Dir = join( "", $TWdir,"tools/windows-replace/" );


#file--> tools/windows-replace/powerShell/*
$powerShellAllDir = join( "", $TWdir,"tools/windows-replace/powerShell/*" );

#path--> tools/windows-replace/powerShell/
$powerShellDir = join( "", $TWdir,"tools/windows-replace/powerShell/" );

#file--> tools/windows-replace/powerShell/*.*
@powerShellFiles = glob( $powerShellAllDir );

#file--> tools/*
@TWtoolsFile = replace_head(@powerShellFiles);

#file--> tools/windows-replace/powerShell/windows-bootstrap.ps1
$windowsBootstrapFile =  join( "", $powerShellDir,"windows-bootstrap.ps1" );

#file--> ./windows-bootstrap.ps1
$TWwindowsBootstrapFile =  join( "", $TWdir,"windows-bootstrap.ps1" );


if ($op eq "-spouting")
{	
	use File::Copy;
	for($a = 0;$a < @powerShellFiles;$a = $a + 1)
	{

		if($windowsBootstrapFile eq $powerShellFiles[$a] )
		{
			#将windowsBootstrap文件拷贝到主目录下
			copy $windowsBootstrapFile  ,$TWdir or warn 'copy failed.';
		}
		else
		{
			#拷贝到tools目录下
			copy $powerShellFiles[$a]  ,$tools_Dir or warn 'copy failed.';
		}

	}

}
elsif($op eq "-suction")
{
	use File::Copy;
	move($TWwindowsBootstrapFile,$powerShellDir);
	for($a = 0;$a < @powerShellFiles;$a = $a + 1)
	{
			move($TWtoolsFile[$a],$powerShellDir);
	}
}
else{

	print "Enter the command: -spouting or -suction,\n";
	print " -spouting : Place Windows dependencies in the tools folder and project home directory.\n";
	print " -suction : Bring Windows dependencies back into the tools folder.\n";
	exit;
}

