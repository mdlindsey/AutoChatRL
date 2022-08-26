;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;             Please support your local animal shelter              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Hotkeys can be changed here
CFG_KEY_RUN := "F5" ; Key to turn the script on
CFG_KEY_END := "F6" ; Key to turn the script off
CFG_KEY_INT := "F7" ; Key to prompt interval config
CFG_KEY_USR := "F8" ; Key to prompt multi-user config

; Used by Bakkes plugin on game start/end but can be used manually
CFG_KEY_GAME_START := "F3" ; Starts script w/delay relative to user ID
CFG_KEY_GAME_END   := "F4" ; Stops the script and sends static messages

; This can be a url or filepath (eg: messages/CatFacts.txt)
CFG_MSG_SRC := "https://raw.githubusercontent.com/mdlindsey/AutoChatRL-AHK/main/messages/CatFacts.txt"

; Static messages/hotkeys can be changed here
CFG_MSG_STATIC := Object() ; Do not delete this line
CFG_MSG_STATIC["F11"] := "Follow us at twitch.tv/rlcatfacts"
CFG_MSG_STATIC["F12"] := "Please support your local animal shelter <3"

; Used by CFG_KEY_GAME_END
CFG_MSG_STATIC_DELAY := 100 ; Delay between static messages in milliseconds

; Interval config has a prompt above via CFG_KEY_INT hotkey
CFG_INTERVAL := 30000 ; Delay between messages in milliseconds

; Multi-user config has a prompt above via CFG_KEY_MU hotkey
CFG_USERS   := 1 ; Total users running script (eg: 3)
CFG_USER_ID := 1 ; Your position in the group (eg: 1-3)

; Misc config
CFG_RANDOM  := true   ; Use random or sequential order
CFG_CHANNEL := "game" ; Which chat channel to use ("game", "team", or "party")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                  This appears in your task tray                   ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OS_TASK_NAME := "Cat Facts"
OS_TASK_ICON := "brand/cat.ico"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;              This is the text that shows on prompts               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UI_INIT_TITLE      := "AutoChat Ready"
UI_INIT_MESSAGE    := "Press your start key when ready"

UI_STOP_TITLE      := "AutoChat Disabled"
UI_STOP_MESSAGE    := "Chat messages are paused"

UI_START_TITLE     := "AutoChat Enabled"
UI_START_MESSAGE   := "Chat messages incoming"

UI_MU_TOTAL_TITLE  := "Total Users"
UI_MU_TOTAL_PROMPT := "Enter the total amount of script users"

UI_MU_ID_TITLE     := "Select Your User ID"
UI_MU_ID_PROMPT    := "Enter your ID relative to total users"

UI_INT_TITLE       := "Message Interval"
UI_INT_PROMPT      := "Enter number of seconds between messages"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                              Enjoy!                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;