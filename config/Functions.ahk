;Functions.ahk
#Include %A_ScriptDir%\features\ProcessWindowManager.ahk

Wrapper_ProcessWindowManager(params*) {
    process_path := params[1]
    winget_query := params[2]
    ProcessWindowManager(process_path, winget_query)
}