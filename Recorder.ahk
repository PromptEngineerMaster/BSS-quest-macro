#SingleInstance Force
#NoEnv
#InstallKeybdHook
SendMode Input
SetBatchLines, -1

recording := false
StartTime := 0
Events := []
KeyState := {}   ; tracks which keys are currently held

OutputDir := "C:\Users\Clanker\Desktop\BSS quest macro\Paths"
OutputFile := OutputDir "\Recorded_Keys.txt"

; =========================
; TOGGLE RECORDING
; =========================
F9::
    recording := !recording

    if (recording) {
        Events := []
        KeyState := {}
        StartTime := A_TickCount
        ToolTip, Recording...
    } else {
        ToolTip
        FileCreateDir, %OutputDir%
        FileDelete, %OutputFile%

        for _, line in Events
            FileAppend, % line "`n", %OutputFile%

        MsgBox, 64, Done, % "Saved to:`n" OutputFile
    }
return

; =========================
; MOVEMENT / ACTION KEYS
; =========================
~*w::KeyDown("w")
~*a::KeyDown("a")
~*s::KeyDown("s")
~*d::KeyDown("d")
~*Space::KeyDown("Space")
~*e::KeyDown("e")

~*w up::KeyUp("w")
~*a up::KeyUp("a")
~*s up::KeyUp("s")
~*d up::KeyUp("d")
~*Space up::KeyUp("Space")
~*e up::KeyUp("e")

return

; =========================
; FUNCTIONS
; =========================
KeyDown(key) {
    global recording, KeyState, StartTime, Events
    if (!recording)
        return

    ; ignore repeats
    if (KeyState.HasKey(key))
        return

    delay := A_TickCount - StartTime
    Events.Push("Sleep " delay)
    Events.Push("Send {" key " down}")

    KeyState[key] := true
    StartTime := A_TickCount
}

KeyUp(key) {
    global recording, KeyState, StartTime, Events
    if (!recording)
        return

    if (!KeyState.HasKey(key))
        return

    delay := A_TickCount - StartTime
    Events.Push("Sleep " delay)
    Events.Push("Send {" key " up}")

    KeyState.Delete(key)
    StartTime := A_TickCount
}
