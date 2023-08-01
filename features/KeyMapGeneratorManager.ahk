
RestartKeyMapGenerator() {
  ; Show the tooltip in the bottom right corner
  ToolTip, Restarting
  SoundPlay *-1
  ; Remove the tooltip after 1 seconds
  SetTimer, RemoveToolTip, -1000
  
  ; Read the PID from the file and delete the file
  FileRead, PID, A_ScriptDir . "\cache\pid.ini"
  FileDelete, A_ScriptDir . "\cache\pid.ini"

  ; Run the parent script again
  ; You need to replace ParentScript.ahk with the path to your script
  Run, %A_ScriptDir%\HotKeyGenerator.ahk

  ; Terminate the original script
  Process, Close, %PID%

  ; Exit the script
  ExitApp
}
