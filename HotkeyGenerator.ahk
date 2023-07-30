#NoEnv
#SingleInstance force
SetWorkingDir % A_ScriptDir
SendMode, Input

#Include %A_ScriptDir%\lib\Hotkey.ahk
#Include %A_ScriptDir%\lib\JSON.ahk

; Load the functions related to the keymap
#Include %A_ScriptDir%\config\Functions.ahk
; Load the keymap configuration
CONFIG_FILE := A_ScriptDir . "\config\KeyMap.json"

; Create a dictionary to store the hotkey-function pairs
hotkeyDict := {}

; Read the config file
FileRead, configFileContent, %CONFIG_FILE%
if (ErrorLevel) {
    MsgBox, 0, Error, Could not open configuration file.
    ExitApp
}

; Parse the JSON config file
hotkeyConfig := JSON.Load(configFileContent)

; Loop over the hotkey configurations
for index, config in hotkeyConfig.hotkeys
{
    ; Create a function object with the bound parameters
    MsgBox, % config.parameters*
    funcBinding := Func(config.function).Bind(config.parameters*)
    ; Add the hotkey to the hotkey dictionary
    hotkeyDict[config.hotkey] := funcBinding
}

; Bind the hotkeys to the function with the configured parameters
for key, value in hotkeyDict
{   
    ; Create a new hotkey with the key and bound function
    hk := new Hotkey(key), hk.onEvent(value)
}

return
