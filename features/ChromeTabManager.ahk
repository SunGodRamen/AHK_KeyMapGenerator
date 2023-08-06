; Using a custom extension, returns the tab and window state of chrome

#Include %A_ScriptDir%\lib\JSON.ahk

GetChromeWindowTabState() {
  ; Step 1: Simulate pressing the hotkeys for your Chrome extension
  Send, !+K  ; Alt+Shift+K
  Send, !+J  ; Alt+Shift+J

  ; Step 2: Wait for a bit to ensure the file is downloaded
  Sleep, 800  ; Wait for 2 seconds. Adjust if necessary.

  ; Step 3: Locate the latest downloaded JSON file
  downloadsFolder := "C:\Users\avons\Downloads\"
  filePattern := "tab_names*.json"

  maxNumber := -1
  Loop, %downloadsFolder%%filePattern%
  {
      ; Extract the number from the filename pattern "tab_names (n).json"
      fileNumber := RegExReplace(A_LoopFileName, "tab_names \((\d+)\).json", "$1")
      if (fileNumber = "") {  ; this means it's probably the "tab_names.json" file without any number
          fileNumber := 0
      }
      if (fileNumber > maxNumber) {
          maxNumber := fileNumber
          latestFile := A_LoopFileFullPath
      }
  }
  
  ; Read the contents of the JSON file
  fileContent := ""
  FileRead, fileContent, % latestFile

  ; Step 4 & 5: Parse the JSON and extract desired information
  ; Parse the JSON content into an AHK object
  jsonObject := JSON.Load(fileContent)


  ; Number of windows
  windowsCount := jsonObject.windows.Length()

  ; Assuming you want to store each window's details in a local object
  windowsObj := {}

  ; Iterate through each window and extract its details
  for windowIndex, window in jsonObject.windows {
      windowDetails := {}

      ; Extract window ID
      windowDetails.id := window.id

      ; Extract tabs details
      windowDetails.tabs := []
      for tabIndex, tabn in window.tabs {
          tabDetails := {}
          tabDetails["index"] := tabn.index
          tabDetails["url"] := tabn.url
          tabDetails["active"] := tabn.active
          windowDetails.tabs.Push(tabDetails)
      }

      ; Extract window active state and window state
      windowDetails.active := window.active
      windowDetails.state := window.state

      ; Store the window details in the main object
      windowsObj["window" . windowIndex] := windowDetails
  }

  ; Step 6: Delete the JSON file
  FileDelete, %latestFile%

  Return windowsObj
}

; New function to download the active URL using youtube-dl
YTDownloadActiveTab() {
    ; Get the state of Chrome's windows and tabs
    windowsObj := GetChromeWindowTabState()
    
    ; Find the currently active tab's URL
    activeTabURL := ""
    for windowIndex, window in windowsObj {
        if (window.active) {  ; If the window is active
            for tabIndex, tabn in window.tabs {
                if (tabn.active) {  ; If the tab is active
                    activeTabURL := tabn.url
                    break  ; Once we find the active tab, no need to continue
                }
            }
        }
        if (activeTabURL != "") {
            break  ; If we have the URL, no need to continue checking other windows
        }
    }
    
    ; Pass the active tab's URL to youtube-dl to download
    if (activeTabURL != "") {
        outputFormat := "C:\Users\avons\Downloads\%(title)s.%(ext)s"
        ubuntuPath := "C:\Program Files\WindowsApps\CanonicalGroupLimited.Ubuntu22.04LTS_2204.2.47.0_x64__79rhkp1fndgsc\ubuntu2204.exe"
        Run, %ubuntuPath% youtube-dl  %activeTabURL% -o %outputFormat%
    }
}