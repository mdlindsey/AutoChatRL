;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;     Don't edit this file unless you know what you're doing :)     ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#NoEnv
#Persistent
#Include cfg.ahk
#SingleInstance, Force

; Custom task tray name/icon
Menu, Tray, Tip,  % "Cat Facts"
Menu, Tray, Icon, % "brand/cat.ico"

; Assign hotkeys for toggle/prompts
Hotkey, %CFG_KEY_TOG%, ToggleState
Hotkey, %CFG_KEY_INT%, IntervalConfigPrompt
Hotkey, %CFG_KEY_USR%, MultiUserConfigPrompt

MSG_TOTAL := 0     ; This will be equal to ObjCount(MSG_QUEUE)
MSG_USAGE := []    ; Message indices will exist here after use
MSG_QUEUE := []    ; Messages from file or config are stored here
RUN_CYCLE := false ; When this is true the cycle will recur

; Load messages on initialization
LoadMessages()

; Pop OS notification on initialization
ShowTrayTip(UI_INIT_TITLE, UI_INIT_MESSAGE)

; Assign hotkeys for static messages
for StaticKey, StaticMessage in CFG_MSG_STATIC {
    Dispatcher := Func("SendStaticMessage").bind(StaticMessage)
    Hotkey, %StaticKey%, %Stop()%
}

SendStaticMessage(msg) {
    Stop()
    SendChatRL(msg)
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                          Main Process                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; This is called when the toggle key is pressed
ToggleState() {
    global RUN_CYCLE
    if (RUN_CYCLE) {
        Stop()
    } else {
        Start()
    }
}

; This is called via Toggle()
Stop() {
    global UI_STOP_TITLE
    global UI_STOP_MESSAGE
    global RUN_CYCLE := false
    SetTimer, Cycle, off
    ShowToolTip(UI_STOP_TITLE, UI_STOP_MESSAGE)
}

; This is called via Toggle()
Start() {
    global UI_START_TITLE
    global UI_START_MESSAGE
    global RUN_CYCLE := true
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
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                         Config Prompts                            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Interval config prompt
IntervalConfigPrompt() {
    global CFG_INTERVAL
    global UI_INT_TITLE
    global UI_INT_PROMPT
    IntervalInput := InputPrompt(UI_INT_TITLE, UI_INT_PROMPT, Floor(CFG_INTERVAL / 1000))
    if (IntervalInput >= 1) {
        CFG_INTERVAL := Floor(IntervalInput * 1000)
    }
}

; Multi-user config prompt
MultiUserConfigPrompt() {
    global CFG_USERS
    global CFG_USER_ID
    global CFG_INTERVAL
    global UI_MU_ID_TITLE
    global UI_MU_ID_PROMPT
    global UI_MU_TOTAL_TITLE
    global UI_MU_TOTAL_PROMPT

    PreviousUsers := CFG_USERS
    UserCountInput := InputPrompt(UI_MU_TOTAL_TITLE, UI_MU_TOTAL_PROMPT, CFG_USERS)
    if (UserCountInput <= 1) {
        CFG_USERS := 1
        CFG_USER_ID := 1
    } else {
        CFG_USERS := UserCountInput
        UserIdInput := InputPrompt(UI_MU_ID_TITLE, UI_MU_ID_PROMPT, CFG_USER_ID)
        CFG_USER_ID := Min(CFG_USERS, Max(1, UserIdInput))
    }

    if (PreviousUsers != CFG_USERS) {
        CFG_INTERVAL += (CFG_USERS - PreviousUsers) * (CFG_INTERVAL / PreviousUsers)
    }

    LoadMessages()
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                             Utilities                             ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Set the message globals
SetMessages(RawMessageStr) {
    global CFG_USERS
    global CFG_USER_ID
    global MSG_QUEUE := []
    RawMessages := StrSplit(RawMessageStr, "`n")
    RawTotal    := ObjCount(RawMessages)
    MsgPerUser  := Floor(RawTotal / CFG_USERS)
    StartIndex  := (CFG_USER_ID - 1) * MsgPerUser + 1
    EndIndex    := StartIndex + MsgPerUser
    for i, msg in RawMessages {
        if (i >= StartIndex and i <= EndIndex) {
            MSG_QUEUE.Push(msg)
        }
    }
    global MSG_TOTAL := ObjCount(MSG_QUEUE)
}

LoadMessages() {
    global CFG_MSG_SRC
    ; Try CFG_MSG_SRC as file
    try {
        FileRead, FileContents, %CFG_MSG_SRC%
        if (StrLen(Trim(FileContents)) > 0) {
            SetMessages(FileContents)
            return
        }
    }
    ; Try CFG_MSG_SRC as URL
    try {
        Request := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        Request.Open("GET", CFG_MSG_SRC, false)
        Request.Send()
        if (Request.Status == 200) {
            SetMessages(Request.ResponseText)
            return
        }
    }
    ; Resort to raw string
    SetMessages(CFG_MSG_SRC)
}

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

; Pre-sized input prompt
InputPrompt(PromptTitle, PromptBody, DefaultValue) {
    Stop() ; Halt execution to prevent autochat from submitting input
    InputBox, InputValue, %PromptTitle%, %PromptBody%,, 320, 140,,,,,%DefaultValue%
    return InputValue
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