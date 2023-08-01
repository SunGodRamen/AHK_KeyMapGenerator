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
;       - Check if the function wrappers exist
;       - Check if the functions exist
;       - Check if the parameters are valid

; Todo: Check if the configuration is updated everytime a hotkey is called
;       - if the updated config file is invalid, keep the old config and show a warning
;       - when the config is updated, register the pressed hotkey if still relevant

; Todo: Error handling in functions passed back to the CommonWrapper

; Load the functions related to the keymap
#Include %A_ScriptDir%\config\Functions.ahk
; Load the keymap configuration
global CONFIG_FILE := A_ScriptDir . "\config\KeyMap.json"

if (!FileExist(CONFIG_FILE))
{
    MsgBox, % "The keymap file does not exist in the expected location:" . CONFIG_FILE . ".`nExiting."
    ExitApp
}

IfExist, A_ScriptDir. "\cache\pid.ini"
    FileDelete, A_ScriptDir . "\cache\pid.ini"

FileAppend, % A_ScriptPID, A_ScriptDir . "\cache\pid.ini"

; Create a dictionary to store the hotkey-function pairs
global KeyMap := {}
global last_config_mod_time := 0

ParseKeymapFunction()
FileGetTime, last_config_mod_time, %CONFIG_FILE%, M

CommonWrapper(funcName, params*) {
    CheckForConfigUpdate()
    ; Create a function object
    func := Func(funcName)

    Result := func.Call(params*)
    return Result
}

ParseKeymapFunction() {
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
        ; Create a wrapper function with the function name and parameters
        wrapperBinding := Func("CommonWrapper").Bind(config.function, config.parameters*)
        ; Add the hotkey to the hotkey dictionary
        KeyMap[config.hotkey] := wrapperBinding
    }

    ; Bind the hotkeys to the function with the configured parameters
    for key, value in KeyMap
    {   
        ; Create a new hotkey with the key and bound function
        hk := new Hotkey(key), hk.onEvent(value)
    }
    return
}

CheckForConfigUpdate() {
    ; Get the current config file modified time
    FileGetTime, curr_config_mod_time, %CONFIG_FILE%, M

    ; Check if the config file has been modified since the last check
    if (curr_config_mod_time != last_config_mod_time)
    {
        ParseKeymapFunction()
        last_config_mod_time := curr_config_mod_time

        ; Show the tooltip in the bottom right corner
        ToolTip, Config Updated
        SoundPlay *-1

        ; Remove the tooltip after 3 seconds
        SetTimer, RemoveToolTip, -1000
    }
}

RemoveToolTip:
    ; Remove the tooltip and the GUI
    ToolTip
return
