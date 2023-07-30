;Functions.ahk

Function1(params*) {
    for index,param in params
        if (index < params.MaxIndex())
            params_str .= str . "`n param" . index . ": " . param
    MsgBox, % "Function1: " . params_str
    return
}

Function2(params*) {
    for index,param in params
        if (index < params.MaxIndex())
                params_str .= str . "`n param" . index . ": " . param
    MsgBox, % "Function2: " . params_str
    return
}
