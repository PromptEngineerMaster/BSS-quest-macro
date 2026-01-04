; ==================================================
; ShiftLockFind.ahk
; Pure function library — cannot run standalone
; Presses Left Shift if the reference pixel is found
; ==================================================

; Usage:
; #Include ShiftLockFind.ahk
; pToken := Gdip_Startup()
; CheckShiftLock(LEFT, TOP, RIGHT, BOTTOM, IMAGE_PATH)
; Gdip_Shutdown(pToken)

CheckShiftLock(left, top, right, bottom, imagePath, requiredMatches := 5)
{
    ; ALWAYS show that function was called
    ToolTip, [ShiftLock] Checking...
    Sleep, 100
    
    static pBitmapRef := 0
    static refWidth := 0
    static refHeight := 0

    ; Load reference image ONCE
    if (!pBitmapRef)
    {
        pBitmapRef := Gdip_CreateBitmapFromFile(imagePath)
        if (!pBitmapRef)
        {
            ToolTip, [ShiftLock] Failed to load reference image
            Sleep, 1000
            ToolTip
            return false
        }

        refWidth  := Gdip_GetImageWidth(pBitmapRef)
        refHeight := Gdip_GetImageHeight(pBitmapRef)
        
        ToolTip, [ShiftLock] Reference loaded: %refWidth%x%refHeight%
        Sleep, 300
    }

    ; FIXED: Correct dimension calculation (add +1)
    width  := right - left + 1
    height := bottom - top + 1

    if (width <= 0)
        width := 1
    if (height <= 0)
        height := 1

    ; Capture screen area
    pBitmapScreen := Gdip_BitmapFromScreen(left "|" top "|" width "|" height)
    
    if (!pBitmapScreen)
    {
        ToolTip, [ShiftLock] Failed to capture screen
        Sleep, 1000
        ToolTip
        return false
    }

    matchCount := 0
    totalPixels := refWidth * refHeight

    ; Compare pixels
    Loop, %refHeight%
    {
        y := A_Index - 1
        Loop, %refWidth%
        {
            x := A_Index - 1

            if (Gdip_GetPixel(pBitmapScreen, x, y) = Gdip_GetPixel(pBitmapRef, x, y))
            {
                matchCount++
                if (matchCount >= requiredMatches)
                {
                    Gdip_DisposeImage(pBitmapScreen)
                    
                    ToolTip, [ShiftLock] DETECTED (%matchCount%/%totalPixels%) - Pressing Shift
                    Sleep, 300
                    ToolTip
                    
                    Send, {LShift}
                    return true
                }
            }
        }
    }

    Gdip_DisposeImage(pBitmapScreen)
    
    ; Show when shift lock is NOT detected
    matchPercent := Round((matchCount / totalPixels) * 100, 1)
    ToolTip, [ShiftLock] Not detected (%matchCount%/%totalPixels% = %matchPercent%`%)
    Sleep, 300
    ToolTip
    
    return false
}