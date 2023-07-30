;HotkeyGenerator.ahk
#NoEnv
#SingleInstance force
SetWorkingDir % A_ScriptDir
SendMode, Input

#Include %A_ScriptDir%\lib\Hotkey.ahk
#Include %A_ScriptDir%\lib\JSON.ahk

; Todo: Validate the configuration file
;       - Check if the syntax is correct
;       - Check if the hotkeys are valid
;       - Check if the functions exist
;       - Check if the parameters are valid

; Todo: Check if the configuration is updated everytime a hotkey is called
;       - if the updated config file is invalid, keep the old config and show a warning
;       - if the updated config file is valid, update the config without restarting the script,
;               register the pressed hotkey if still relevant

; Load the functions related to the keymap
#Include %A_ScriptDir%\config\Functions.ahk
; Load the keymap configuration
CONFIG_FILE := A_ScriptDir . "\config\KeyMap.json"

if (!FileExist(CONFIG_FILE))
{
    MsgBox, % "The keymap file does not exist in the expected location:" . CONFIG_FILE . ".`nExiting."
    ExitApp
}

CommonWrapper(funcBind, params*) {
    ; Pre-processing code here...

    ; Call the actual function
    Result := funcBind.Call(params*) 

    ; Return the result
    return Result
}

; check when the config file was last modified
FileGetTime, last_config_mod_time, %CONFIG_FILE_PATH%, M


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
    actualFuncBinding := Func(config.function).Bind(config.parameters*)
    funcBinding := Func("CommonWrapper").Bind(actualFuncBinding)

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
