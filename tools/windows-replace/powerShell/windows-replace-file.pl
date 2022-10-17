#!/usr/bin/perl
if ($#ARGV+1 != 1 ) {

	print "Enter the command: -e or -r,\n";
	print " -e : extract command is used to extract the modified source code to a tools file.\n";
	print " -r : replace command is used to replace the source code file.\n";
	exit;
}

$op=$ARGV[0];

$searchPoint = "windows-replace/";
$searchPointLength = length($searchPoint);
$searchPointLength = $searchPointLength - 1;
sub recure{

  my $file = shift @_;

  if( -d $file ){
    
     my @sub_files = <$file/*>;

     
     foreach  $sub_file (@sub_files )
	 {
		 if(($sub_file ne $powerShellDir) && ($sub_file ne $READMEfile) && ($sub_file ne $dragonFile) )
		 {	
			&recure($sub_file);     
		 }
     }
   }else {
    $cnt_file++;

    $windows_replaceFiles[$cnt_file] = $sub_file;
   }
}

sub replace_head
{
	my @toolsFiles = @_;
	@TWFiles;
	for($a = 0;$a < $#toolsFiles + 1;$a = $a + 1)
	{
		 $toolsFilesString = join("",$toolsFiles[$a]);
		 my $stringPos = rindex($toolsFilesString,$searchPoint);
		 $stringPos += $searchPointLength;
		 my $filesName = substr($toolsFilesString,$stringPos + 1);
		 my $TWFileNameString = join( "",$TWdir ,$filesName );
		 $TWFiles[$a] =  $TWFileNameString;
	}
	return @TWFiles;
	
}

sub copyFile
{
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

$windowsToolkitName = "windows-replace";

#path--> tools/$windowsToolkitName
$windows_replaceDir = join( "", $TWdir,"/tools/$windowsToolkitName" );

#path--> tools/$windowsToolkitName/powerShell/
$powerShellDir = join( "", $TWdir,"/tools/$windowsToolkitName/powerShell" );

#file--> tools/$windowsToolkitName/README.md
$READMEfile = join( "", $TWdir,"/tools/$windowsToolkitName/README.md" );

#file--> tools/$windowsToolkitName/windows-dragon-king.pl
$dragonFile = join( "", $TWdir,"/tools/$windowsToolkitName/windows-dragon-king.pl" );

#file--> tools/$windowsToolkitName/*.*
@windows_replaceFiles;
&recure($windows_replaceDir);


#file--> tools/windows-*.ps1 & tools/windows-*.pl
@TWFiles = replace_head(@windows_replaceFiles);

if ($op eq "-e")
{
	copyFile(\@TWFiles,\@windows_replaceFiles);
	
}
elsif($op eq "-r")
{
	copyFile(\@windows_replaceFiles,\@TWFiles);
}
else{

	print "Enter the command: -e or -r,\n";
	print " -e : extract command is used to extract the modified source code to a tools file.\n";
	print " -r : replace command is used to replace the source code file.\n";
	exit;
}



