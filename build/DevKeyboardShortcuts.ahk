; AutoHotKey script for my own development convenience.
; See http://www.autohotkey.com/ to download AutoHotKey (freeware).
;
; This script provides the following keybindings:
;   Numpad -    Opens Git Gui if it's not already running, or switches to the
;               already-running instance and invokes "Rescan".
;   Numpad +    Opens Gitk (All Branch History) if it's not already running,
;               or switches to the running instance and invokes "Update".
;   Numpad *    Runs jake to build the sample project, then moves focus to an
;               existing instance of Google Chrome, switches to tab #4, and
;               invokes "Refresh".
;   Numpad /    Moves focus to the Sublime Text 2 editor currently editing the
;               "Tyler" project.

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode, RegEx

NumpadSub::
IfWinNotExist, Git Gui
  Run, git gui,, Hide
WinActivate, Git Gui
IfWinActive, Git Gui
{
  ControlGetPos, control_x, control_y,,, TkChild18, Git Gui
  CoordMode, Mouse, Screen
  MouseGetPos, mouse_x, mouse_y
  click_x := control_x + 5
  click_y := control_y + 5
  CoordMode, Mouse, Relative
  Click %click_x%, %click_y%
  CoordMode, Mouse, Screen
  MouseMove, %mouse_x%, %mouse_y%, 0

  Send, {F5}
}
return

NumpadAdd::
IfWinNotExist, gitk
  Run, cmd /c gitk --all
WinActivate, gitk
IfWinActive, gitk
  Send, {F5}
return

NumpadMult::
RunWait, %comspec% /c cd .. && jake || pause && exit /b 1
if ErrorLevel = 0
{
  WinActivate, Google Chrome
  IfWinActive, Google Chrome
    Send, ^4{F5}
}
return

NumpadDiv::
WinActivate, \(Tyler\) - Sublime Text 2
return