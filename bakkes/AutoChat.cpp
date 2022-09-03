#include "pch.h"
#include "AutoChat.h"
#include <Windows.h>

// Config
int AHK_STOP        = VK_F6;  // Stop without sending static messages
int AHK_GAME_START  = VK_F3;  // Start the script w/delay relative to user ID
int AHK_GAME_END    = VK_F4;  // Stop the script and send all static messages
bool DEFAULT_TOGGLE = false;  // Toggle game vs default start/stop via GUI

// State
bool PLUGIN_ENABLED = false;  // Toggle plugin on/off via GUI
bool ROUND_STARTED  = false;  // This gets toggled in onKickoffTimerStart/onGameComplete

// Boilerplate
std::shared_ptr<CVarManagerWrapper> _globalCvarManager;
BAKKESMOD_PLUGIN(AutoChat, "Auto Chat", plugin_version, PLUGINTYPE_FREEPLAY)

// Utilities
void sendVirtualKey(int vk) {
	INPUT keyInput;
	keyInput.type = INPUT_KEYBOARD;
	keyInput.ki.wVk = vk;
	keyInput.ki.dwFlags = 0;
	keyInput.ki.time = 0;
	keyInput.ki.wScan = 0;
	keyInput.ki.dwExtraInfo = 0;
	// Send the press
	SendInput(1, &keyInput, sizeof(INPUT));
	// Send the keyup
	keyInput.ki.dwFlags = KEYEVENTF_UNICODE | KEYEVENTF_KEYUP;
	SendInput(1, &keyInput, sizeof(INPUT));
}

// Only accepts F1-F12 so remove first char and convert to int
int str2vk(string vkStr) {
	return VK_F1 - 1 + std::stoi(vkStr.replace(0, 1, ""));
}
string vk2str(int vk) {
	return "F" + std::to_string(vk - VK_F1 + 1);
}

// Event Listeners
void AutoChat::onLoad() {
	_globalCvarManager = cvarManager;

	cvarManager->registerCvar("auto_chat_enabled", "0", "Enable hotkey automation", true, false)
		.addOnValueChanged([this](std::string oldValue, CVarWrapper cvar) {
			PLUGIN_ENABLED = cvar.getBoolValue();
		});

	cvarManager->registerCvar("auto_chat_smart_toggles", "1", "Use game start/stop keys", true, false)
		.addOnValueChanged([this](std::string oldValue, CVarWrapper cvar) {
			DEFAULT_TOGGLE = cvar.getBoolValue();
		});

	cvarManager->registerCvar("auto_chat_game_start_key", vk2str(AHK_GAME_START), "Game start key for AHK", true, false)
		.addOnValueChanged([this](std::string oldValue, CVarWrapper cvar) {
			AHK_GAME_START = str2vk(cvar.getStringValue());
		});

	cvarManager->registerCvar("auto_chat_game_stop_key", vk2str(AHK_GAME_END), "Game stop key for AHK", true, false)
		.addOnValueChanged([this](std::string oldValue, CVarWrapper cvar) {
			AHK_GAME_END = str2vk(cvar.getStringValue());
		});

	cvarManager->registerCvar("auto_chat_stop_key", vk2str(AHK_STOP), "Stop key for AHK", true, false)
		.addOnValueChanged([this](std::string oldValue, CVarWrapper cvar) {
			AHK_STOP = str2vk(cvar.getStringValue());
		});

	// This fires at the beginning of every kickoff timer
	gameWrapper->HookEventWithCaller<ServerWrapper>(
		"Function GameEvent_Soccar_TA.Countdown.BeginState",
		bind(
			&AutoChat::onKickoffTimerStart,
			this,
			placeholders::_1,
			placeholders::_2,
			placeholders::_3
		)
	);

	// This fires when a match ends naturally
	gameWrapper->HookEventWithCaller<ServerWrapper>(
		"Function TAGame.GameEvent_Soccar_TA.EventMatchEnded",
		bind(
			&AutoChat::onGameComplete,
			this,
			placeholders::_1,
			placeholders::_2,
			placeholders::_3
		)
	);
	
	// This fires when you leave a match prematurely
	gameWrapper->HookEventWithCaller<ServerWrapper>(
		"Function TAGame.GameEvent_Soccar_TA.Destroyed",
		bind(
			&AutoChat::onGameComplete,
			this,
			placeholders::_1,
			placeholders::_2,
			placeholders::_3
		)
	);

}

void AutoChat::onUnload() {
	sendVirtualKey(AHK_STOP);
}

void AutoChat::onKickoffTimerStart(ServerWrapper caller, void* params, string eventName) {
	if (!PLUGIN_ENABLED || !gameWrapper->IsInOnlineGame() || ROUND_STARTED) {
		return;
	}
	ROUND_STARTED = true;
	sendVirtualKey(AHK_GAME_START);
}

void AutoChat::onGameComplete(ServerWrapper caller, void* params, string eventName) {
	ROUND_STARTED = false;
	if (!PLUGIN_ENABLED) {
		return;
	}
	if (eventName == "Function TAGame.GameEvent_Soccar_TA.EventMatchEnded") {
		sendVirtualKey(AHK_GAME_END);
	} else {
		sendVirtualKey(AHK_STOP);
	}
}
