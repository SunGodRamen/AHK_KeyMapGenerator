# KeyMapGenerator

KeyMapGenerator is an advanced hotkey configuration tool for Windows, developed using the AutoHotkey scripting language. It enables users to create complex hotkey mappings with an arbitrary number of parameters by modifying a simple JSON configuration file. This approach eliminates the need for hardcoding your hotkeys and makes the system easily adjustable according to your changing requirements.

## Features

- Configure your hotkeys using a simple JSON configuration file.
- Map hotkeys to custom functions with an arbitrary number of parameters.
- Flexible setup for various applications and use cases.

## Directory Structure

The project has the following directory structure:

.
├── HotkeyGenerator.ahk  # The main AutoHotkey script file
├── config
│   ├── Functions.ahk    # Contains the AutoHotkey functions that will be mapped to hotkeys
│   └── KeyMap.json      # JSON file for hotkey configurations
└── lib
    ├── Hotkey.ahk       # A library file for handling hotkeys
    └── JSON.ahk         # A library file for handling JSON operations

## Usage
1. Clone the repository to your local machine.
2. Modify the config/KeyMap.json file according to your requirements. The hotkey field takes the key combination for the hotkey, function takes the name of the function to be executed when the hotkey is triggered, and parameters takes a list of parameters to be passed to the function.
3. Define your functions in the config/Functions.ahk file. The functions should be able to handle the parameters you defined in the KeyMap.json file.
4. Run HotkeyGenerator.ahk to start the script.

