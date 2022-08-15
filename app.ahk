;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;     Don't edit this file unless you know what you're doing :)     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#Persistent
#Include cfg.ahk
#SingleInstance, Force

; Assign hotkeys for start/stop
Hotkey, %CFG_KEY_STOP%, Stop
Hotkey, %CFG_KEY_START%, Start
Hotkey, %CFG_KEY_RELOAD%, LoadMessages

; Pop OS notification on initialization
ShowTrayTip(UI_INIT_TITLE, UI_INIT_MESSAGE)

; Preload messages on initialization
LoadMessages()

MSG_TOTAL := 0     ; This will be equal to ObjCount(MSG_QUEUE)
MSG_USAGE := []    ; Message indices will exist here after use
MSG_QUEUE := []    ; Messages from file or config are stored here
RUN_CYCLE := false ; When this is true the cycle will recur

; Assign hotkeys for static messages
for StaticKey, StaticMessage in CFG_MSG_STATIC {
    Dispatcher := Func("SendChatRL").bind(StaticMessage)
    Hotkey, %StaticKey%, % Dispatcher
}

; Message sources take precedence in order of global vars
LoadMessages() {
    global CFG_MSG_URL
    global CFG_MSG_FILE
    global CFG_MSG_LIST
    RawMessageList := CFG_MSG_LIST
    if (StrLen(CFG_MSG_FILE) > 0) {
        FileRead, FileContents, % "messages/" . CFG_MSG_FILE
        if (StrLen(Trim(FileContents)) > 0) {
            RawMessageList = %FileContents%
        }
    }
    if (StrLen(CFG_MSG_URL) > 0) {
        Request := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        Request.Open("GET", CFG_MSG_URL, false)
        Request.Send()
        RawMessageList = % Request.ResponseText
    }
    global MSG_QUEUE := StrSplit(RawMessageList, "`n")
    global MSG_TOTAL := ObjCount(MSG_QUEUE)
}

; This is called when the stop key is pressed
Stop() {
    global UI_STOP_TITLE
    global UI_STOP_MESSAGE
    global RUN_CYCLE := false
    SetTimer, Cycle, off
    ShowToolTip(UI_STOP_TITLE, UI_STOP_MESSAGE)
}

; This is called when the start key is pressed
Start() {
    global UI_START_TITLE
    global UI_START_MESSAGE
    global RUN_CYCLE := true
    LoadMessages()
    ShowToolTip(UI_START_TITLE, UI_START_MESSAGE)
    SetTimer, Cycle, -1
}

; This runs recursively until stopped
Cycle() {
    global RUN_CYCLE
    global MSG_USAGE
    global MSG_QUEUE
    global MSG_TOTAL
    global CFG_RANDOM
    global CFG_CHANNEL
    global CFG_INTERVAL

    ; Halt the cycle when the stop key is pressed
    if (!RUN_CYCLE) {
        SetTimer, Cycle, off
        return
    }

    TotalUsed := ObjCount(MSG_USAGE)
    ; Reset and restart if we've used all messages
    if (TotalUsed == MSG_TOTAL) {
        global MSG_USAGE := []
        SetTimer, Cycle, -1
        return
    }

    ; Arrays aren't zero indexed because AHK is trash
    ChosenMessageIndex := %TotalUsed% + 1
    if (CFG_RANDOM) {
        ChosenMessageIndex := RandomInt(1, MSG_TOTAL)
        while (MSG_USAGE[ChosenMessageIndex]) {
            ChosenMessageIndex := RandomInt(1, MSG_TOTAL)
        }
    }

    MSG_USAGE[ChosenMessageIndex] := true
    SetTimer, Cycle, % (-1 * CFG_INTERVAL)
    SendChatRL(Trim(MSG_QUEUE[ChosenMessageIndex]), CFG_CHANNEL)
    return
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                             Utilities                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; RL doesn't allow copy/paste in chat so we have to used SendInput
; which seems to outpace RL's input mechanism resulting in only the
; final 30ish characters making it to the chat input so you'll notice
; we're just doing some hacky substring slicing to send longer messages
; as quickly as possible to best reduce gameplay input disruption
SendChatRL(OutputStr, Channel="game") {
    SUBSTR_MAX_LEN     := 20 ; Maximum number of characters to output at once
    SUBSTR_INPUT_DELAY := 25 ; Time to wait between SendInput calls in milliseconds

    switch (Channel) {
        case "team"  : Send {y}
        case "party" : Send {u}
        default      : Send {t}
    }

    SubStrsCreated := 0
    while (SubStrsCreated <= Ceil(StrLen(OutputStr) / SUBSTR_MAX_LEN)) {
        SendInput % SubStr(OutputStr, (SUBSTR_MAX_LEN * SubStrsCreated++) + 1, SUBSTR_MAX_LEN)
        Sleep, %SUBSTR_INPUT_DELAY%
    }

    Send {Enter}
}

; Avoid fugly AHK syntax
RandomInt(min, max) {
    Random RandomInt, min, max
    return RandomInt
}

; TrayTips pop at the OS level
ShowTrayTip(TitleText, BodyText, TTL=3000) {
    TrayTip %TitleText%, %BodyText%
    SetTimer, HideTrayTip, % (-1 * TTL)
}
HideTrayTip() {
    TrayTip  ; Try generic method first
    if (SubStr(A_OSVersion, 1, 3) = "10.") {
        Menu Tray, NoIcon
        Sleep 200  ; It may be necessary to adjust this sleep duration
        Menu Tray, Icon
    }
}

; ToolTips pop at the window level
ShowToolTip(TitleText, BodyText, TTL=3000, PosX=0, PosY=0) {
    ToolTip, %TitleText%`n%BodyText%, %PosX%, %PosY%
    SetTimer, HideToolTip, % (-1 * TTL)
}
HideToolTip() {
    ToolTip
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;     Don't edit this file unless you know what you're doing :)     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;