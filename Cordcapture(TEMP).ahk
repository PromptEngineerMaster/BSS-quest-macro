#NoEnv
SendMode Input
SetBatchLines, -1
CoordMode, Mouse, Screen

MsgBox, Click the TOP-LEFT corner of the area, then press OK.

KeyWait, LButton, D
MouseGetPos, x1, y1
KeyWait, LButton

MsgBox, Click the BOTTOM-RIGHT corner of the area, then press OK.

KeyWait, LButton, D
MouseGetPos, x2, y2
KeyWait, LButton

coords =
(
Top-Left:
X1: %x1%
Y1: %y1%

Bottom-Right:
X2: %x2%
Y2: %y2%
)

Clipboard := coords
MsgBox, Coords copied to clipboard.

ExitApp
