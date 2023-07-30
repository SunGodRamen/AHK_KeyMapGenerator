
Function1(params*) {
    MsgBox, % "Function1: "
    MsgBox, % params*
    MsgBox, % params[1]
    MsgBox, % params[2]
    return
}

Function2(params*) {
    MsgBox, % "Function2: "
    MsgBox, % params*
    return
}
