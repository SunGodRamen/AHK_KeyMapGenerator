; Send clipboard contents as keystrokes
PasteAsTyped() {
    ; Save the entire clipboard to the variable ClipSaved
    temp := ClipboardAll  
    ; Convert any copied files, HTML, or other formatted data to plain text
    Clipboard = %Clipboard%    
    ; Wait for the clipboard to contain text
    ClipWait, 1                
    ; If NOT ErrorLevel (clipboard contains text)
    if (!ErrorLevel)  
    {
        ; Send the contents of the clipboard as keystrokes
        SendInput, %Clipboard% 
    }
    Else
    {
        MsgBox, 48, Paste as Typed, The clipboard does not contain text.
    }
    ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
    Clipboard := temp     
    ; Free the memory in case the clipboard was very large.
    temp =                
return
}