;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;             Please support your local animal shelter              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CFG_KEY_RELOAD := "F8"           ; Key to reload messages
CFG_KEY_START  := "F9"           ; Key to start script
CFG_KEY_STOP   := "F10"          ; Key to stop script
CFG_MSG_FILE   := "CatFacts.txt" ; Located in messages/<filename>
CFG_MSG_URL    := "https://raw.githubusercontent.com/mdlindsey/AutoChatRL-AHK/main/messages/CatFacts.txt"

CFG_MSG_STATIC := Object()       ; Do not delete this line
CFG_MSG_STATIC["F11"] := "Follow us at twitch.tv/rlcatfacts"
CFG_MSG_STATIC["F12"] := "Please support your local animal shelter"

CFG_RANDOM   := true   ; Use random or sequential order
CFG_CHANNEL  := "game" ; Which chat channel to use ("game", "team", or "party")
CFG_INTERVAL := 30000  ; Delay between messages in milliseconds
CFG_MSG_LIST  =        ; One message per line, do not delete parentheses ()
(
    Messages can go here instead of a file
    If you have a file it will take priority
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;           This is the text that shows on notifications            ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UI_INIT_TITLE    := "AutoChat Ready"
UI_INIT_MESSAGE  := "Press your start key when ready"

UI_STOP_TITLE    := "AutoChat Disabled"
UI_STOP_MESSAGE  := "Chat messages are paused"

UI_START_TITLE   := "AutoChat Enabled"
UI_START_MESSAGE := "Chat messages incoming"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                              Enjoy!                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;