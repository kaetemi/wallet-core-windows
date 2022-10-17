# windows-replace  folder

The windows-replace folder manages modified files.

used when there are no powershell scripts in the tools directory:

```perl .\tools\windows-replace\windows-dragon-king.pl -spouting```

Place Windows dependencies in the tools folder and project home directory.



```perl .\tools\windows-replace\windows-dragon-king.pl -suction```

Reclaim the files in the tools folder and project home directory.

#Replace the file
```perl .\tools\windows-replace-file.pl -e ```

Replace the modified file with the source file.

#Build

 powershell ```.\windows-bootstrap```

 Or, broken up in smaller steps:

 powershell ```.\tools\windows-dependencies.ps1```

 This script builds TrustWallet and runs the tests:

 powershell ```.\tools\windows-build-and-test.ps1```

