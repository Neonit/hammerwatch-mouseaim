;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         Neonit
;

;;;;;;;;;;;;;;;;;;;;
;; VERY IMPORTANT ;;
;;;;;;;;;;;;;;;;;;;;
/*
    YOU CAN FIND A LIST OF ALL KEY NAMES USED IN THIS SCRIPT AND AVAILABLE TO YOUR PERSONAL ADJUSTMENTS HERE:

    https://autohotkey.com/docs/KeyList.htm
*/

; basic script initialization
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
CoordMode Mouse, Screen
SetKeyDelay 25, 25

; constants (NEVER CHANGE THESE, unless you know what you're doing)
idx_up := 1
idx_left := 2
idx_down := 3
idx_right := 4
pi := 3.14159265358979323846
pi_by_4 := pi / 4
pi_by_8 := pi / 8
screen_center_x := A_ScreenWidth / 2
screen_center_y := A_ScreenHeight / 2
state_actions := ["up", "down"]

; configuration
crosshair_size := [17, 17] ; [width, height] in pixels; adjust to the current crosshair image
; you may adjust the keys here, but it's probably easier to bind them ingame like they are set here
ctrl_up :=      "i"
ctrl_left :=    "j"
ctrl_down :=    "k"
ctrl_right :=   "l"
ctrl_stand :=   "n"
ctrl_strafe :=  "m"

; you can set your control keys here, if you don't want to use wasd
mvm_binds := []
mvm_binds[idx_up] := "w"
mvm_binds[idx_left] := "a"
mvm_binds[idx_down] := "s"
mvm_binds[idx_right] := "d"

; runtime variables (DO NOT CHANGE)
cur_direction := 0
crosshair_offset := [Floor(crosshair_size[1] / 2), Floor(crosshair_size[2] / 2)]
is_running := false
is_setup := false

; DO NOT CHANGE
mvm_keys := []
mvm_keys[idx_up] := ctrl_up
mvm_keys[idx_left] := ctrl_left
mvm_keys[idx_down] := ctrl_down
mvm_keys[idx_right] := ctrl_right

; DO NOT CHANGE
; this maps the current mouse aim segment to the movement key combination
; e.g. 1 is for the segment to the straight left, thus both keys are ctrl_left, 2 is for the one
; above it (up and left) and so on; each segment covers 45°, so there are 360° / 45° = 8 segments,
; because ingame you can look into 8 different directions
key_combs := []
key_combs[1] := [ctrl_left, ctrl_left]
key_combs[2] := [ctrl_up, ctrl_left]
key_combs[3] := [ctrl_up, ctrl_up]
key_combs[4] := [ctrl_up, ctrl_right]
key_combs[5] := [ctrl_right, ctrl_right]
key_combs[6] := [ctrl_down, ctrl_right]
key_combs[7] := [ctrl_down, ctrl_down]
key_combs[8] := [ctrl_left, ctrl_down]

; [enabledisablekey]
; this is the control for activating and deactivating the mouseaim; you can change it, if you want
; the asterisk in front means it also triggers, if any other key is pressed, which is recommended,
; because the script often holds keys automatically for you (e.g. for strafing)
*NumpadMult::
    is_running := !is_running
    if (is_running)
	{
        if (!is_setup)
		{
            SetupCrosshair() ; [disablecrosshair] preceed with a semicolon, if you don't want the crosshair
            is_setup := true
		}
        SetTimer, mainloop, -1
	}
Return

/* [attackhotkeys]
    I noticed that when playing as the ranger, the right mouse button would place multiple bombs at once, at least when *invert autofire* is enabled. In such a case (I don't know, if it happens with other skills as well), you can use the following hotkey setup:

    *RButton::
        SendEvent {LCtrl down}{Left}{LCtrl up}
    Return

    Just replace the respective hotkey entry below. Of course you can replace RButton and Left with the keys you need.

    If you want to decide against *invert autofire*, but want one or more attacks to have autofire, try the following script:

    *LButton:: ; trigger, when you press LButton (left mouse button); adjust to your needs
        Send {LCtrl down}{Up down} ; pretend that you are holding LCtrl (left CTRL) and Up (arrow up); adjust Up to your needs
        While GetKeyState(LButton, "p") ; this basically waits until LButton is released; you have to replace LButton here to match the key you set in the first line
            Sleep 10
        Send {LCtrl up}{Up up} ; pretend that you release LCtrl and Up; adjust Up to match the key you set in the second line
    Return
*/

; these hotkeys only work when the mouseaim is active
#If is_running
*LButton:: Up
*RButton:: Left
*LShift:: Right
*Space:: Down
#if

mainloop:
	if (is_running)
	{
		UpdateState()
		SetTimer, mainloop, -1
	}
	else
	{
		Gui, Hide
		ReleaseMovementKeys()
		Send % "{" ctrl_strafe " up}{" ctrl_stand " up}"
	}
Return

; from https://github.com/aviaryan/autohotkey-scripts/blob/master/Functions/Math-Functions.ahk
Atan2(x, y) ; 4-quadrant atan
{
    Return dllcall("msvcrt\atan2", "Double", y, "Double", x, "CDECL Double")
}

DetermineDirection(x, y)
{
    global pi_by_4, pi_by_8, screen_center_x, screen_center_y
    angle := atan2(x - screen_center_x, y - screen_center_y)
    direction := Floor((angle - pi_by_8) / pi_by_4) + 5
    if (direction = 8)
        direction := 0
	return direction
}

DetermineMoving()
{
    global mvm_binds
    return GetKeyState(mvm_binds[1]) || GetKeyState(mvm_binds[2]) || GetKeyState(mvm_binds[3]) || GetKeyState(mvm_binds[4])
}

ReleaseMovementKeys()
{
	global mvm_keys
	Loop % mvm_keys.Length()
		Send % "{" mvm_keys[A_Index] " up}"
}

SetupCrosshair()
{
	global crosshair_size
    Gui, Margin, 0, 0
    Gui +AlwaysOnTop -Caption +ToolWindow
    Gui, Add, Picture, AltSubmit, ch.gif
    Gui, Color, FFFFFF
    Gui, Show, NoActivate NA x0 y0
    WinSet, TransColor, White, %A_ScriptName%
}

UpdateCrosshair(x, y)
{
    global crosshair_offset
    Gui, Show, % "NoActivate NA x" (x - crosshair_offset[1]) " y" (y - crosshair_offset[2])
}

UpdateDirection(direction)
{
	global ctrl_stand, ctrl_strafe, cur_direction, key_combs
	idx := direction + 1

    ReleaseMovementKeys()
    Send % "{" ctrl_strafe " up}{" ctrl_stand " down}"
    ; Sleep 1
    Send % "{" key_combs[idx][1] " down}{" key_combs[idx][2] " down}"
    Sleep 1
    Send % "{" ctrl_strafe " down}"
    Sleep 1
	Send % "{" ctrl_stand " up}{" key_combs[idx][1] " up}{" key_combs[idx][2] " up}"

	cur_direction := direction
}

UpdateMovement()
{
	global mvm_binds, mvm_keys, state_actions

    Loop % mvm_keys.Length()
    {
        state := GetKeyState(mvm_keys[A_Index])
        if (GetKeyState(mvm_binds[A_Index]) != state)
        {
            state := 2 - state
            Send % "{" mvm_keys[A_Index] " " state_actions[state] "}"
        }
    }
}

UpdateState()
{
	global cur_direction

	MouseGetPos, mx, my
	direction := DetermineDirection(mx, my)

	if (cur_direction != direction)
		UpdateDirection(direction)
	UpdateMovement()
	UpdateCrosshair(mx, my) ; [disablecrosshair] preceed with semicolon, if you don't want a crosshair
}
