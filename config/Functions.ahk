;Functions.ahk

; Control window states
#Include %A_ScriptDir%\features\ProcessWindowManager.ahk

Wrapper_ProcessWindowManager(params*) {
    process_path := params[1]
    winget_query := params[2]
    ProcessWindowManager(process_path, winget_query)
}

; Run executables
#Include %A_ScriptDir%\features\TerminalCommands.ahk

Wrapper_RunExecutable(params*) {
    executable_path := params[1]
    parameters := params[2]
    RunExecutable(executable_path, command)
}