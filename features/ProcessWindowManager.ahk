; These functions manage defined processes and their windows:
;=============================================================
; ▣ Hotkey released:
; ║
; ╠═══◈If the process is not running,
; ║   ║
; ║   ╚══◎ Start the process.
; ║
; ╚═══◈ If the process is running,
;     ║
;     ╠═══◈ If there are unminimized process windows,
;     ║   ║
;     ║   ╠═══◈ If the process window is not in focus,
;     ║   ║   ║
;     ║   ║   ╚══◎ Activate first unminimized window.
;     ║   ║
;     ║   ╚═══◈ If the process window is in focus,
;     ║       ║
;     ║       ╚══○ Minimize the focused process window.
;     ║          ║
;     ║          ╚═══◈If another unminimized window exists,
;     ║              ║
;     ║              ╚══◎ Activate the next unminimized process window.
;     ║
;     ╚═══◈ If there are no other unminimized windows,
;         ║
;         ╚══◎ Restore all of the process windows.
;=============================================================

ProcessWindowManager(process_path, winget_query) {
    ; Get the process name from the full path
    SplitPath, process_path, process_name
    process_exists := CheckProcessFunction(process_name)

    if (!process_exists)
    {
        ; The process isn't running, so start it
            Run, % process_path
    }
    else
    {
        ; The process is running, query for the process ID
        p_id := GetProcessIdFunction(winget_query)
        
        ; Determine the state and id of each window
        Window_Info := GetWindowInfoFunction(p_id)
        window_states := Window_Info.window_states
        window_ids := Window_Info.window_ids

        ; Perform relevant actions based on the state of the windows
        WindowActionFunction(window_states, window_ids)
    }
    return
}

CheckProcessFunction(name) {
    Process, Exist, % name
    return ErrorLevel != 0
}

GetProcessIdFunction(winget_query) {
    WinGet, p_id, PID, % winget_query
    return p_id
}

GetWindowInfoFunction(p_id) {
    window_states := {}  ; Reset the window states for this process
    window_ids := {}  ; Reset the window ids for this process
    WinGet, window_id_list, List, ahk_pid %p_id%

    Loop, %window_id_list%
    {
        this_id := window_id_list%A_Index%
        window_ids.Push(this_id)

        ; Determine if this window is active or minimized
        WinGet, MinMax, MinMax, ahk_id %this_id%
        isActive := WinActive("ahk_id " . this_id)

        Switch
        {
            Case (MinMax = -1):
                window_states[this_id] := "minimized"
            Case (isActive):
                window_states[this_id] := "active"
            Default:
                window_states[this_id] := "inactive"
        }

    }

    Window_Info := {}
    Window_Info.window_states := window_states
    Window_Info.window_ids := window_ids
    return Window_Info
}

WindowActionFunction(window_states, window_ids) {
    all_minimized := true
    all_inactive := true
    for window_id, state in window_states
    {
        if (state != "minimized")
        {
            all_minimized := false
        }
        if (state != "inactive")
        {
            all_inactive := false
        }
        if (!all_minimized && !all_inactive)
        {
            break
        }
    }

    if (all_minimized)
    {
        ; If all window_ids are minimized, restore all of them
        for window_id, state in window_states
        {
            WinRestore, ahk_id %window_id%
        }
    }
    else if (all_inactive)
    {
        ; If all window_ids are inactive, activate the first one
        first_window := window_ids[1]
        WinActivate, ahk_id %first_window%
        window_states[first_window] := "active"
    }
    else
    {
        ; If not all window_ids are minimized or inactive, find the active window and minimize it, then activate the next window in the list
        next_window := ""
        
        for index, window_id in window_ids
        {
            if (window_states[window_id] = "active")
            {
                ; If the window is active, minimize it
                WinMinimize, ahk_id %window_id%
                window_states[window_id] := "minimized"
                
                ; Set the next window to activate
                if (window_ids.MaxIndex() = index)
                {
                    ; If this is the last window in the list, the next window is the first window
                    next_window := window_ids[1]
                }
                else
                {
                    ; Otherwise, the next window is the window after this one in the list
                    next_window := window_ids[index + 1]
                }
                break
            }
        }
        
        ; If there is a next window to activate,
        if (next_window != "")
        {
            ; If the window is not minimized, activate it
            WinGet, MinMax, MinMax, ahk_id %next_window%
            if (MinMax != -1)
            {
                WinActivate, ahk_id %next_window%
                window_states[next_window] := "active"
            }
        }
    }
}
