#perl Download http://strawberryperl.com/releases.html



$SWIFT_PARAMETER_PATTERN = 's/\\param\s+([^\s]+)/\- Parameter $1:/g'
$SWIFT_RETURN_PATTERN = 's/\\return/\- Returns:/g'
$SWIFT_NOTE_PATTERN = 's/\\note/\- Note:/g'
$SWIFT_SEE_PATTERN = 's/\\see/\- SeeAlso:/g'
$SWIFT_FOLDER_PATH = "swift\Sources\Generated\*.swift"
$SWIFT_FOLDER_PATH_BAK = "swift\Sources\Generated\*.bak"

function process_swift_comments($path)
{
    perl '-pi.bak' -e $SWIFT_PARAMETER_PATTERN $path
    perl '-pi.bak' -e $SWIFT_RETURN_PATTERN $path
    perl '-pi.bak' -e $SWIFT_NOTE_PATTERN $path
    perl '-pi.bak' -e $SWIFT_SEE_PATTERN $path
}

function swift_convert                                           
{
  echo "Processing swift convertion..."

  foreach($path in  Get-ChildItem $SWIFT_FOLDER_PATH)
  {
        process_swift_comments($path) 
  }
  Remove-Item $SWIFT_FOLDER_PATH_BAK

}
swift_convert