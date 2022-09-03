#include "pch.h"
#include "imgui_stdlib.h"
#include "AutoChat.h"
#include <string>

using namespace std;

string AutoChat::GetPluginName() {
	return "Auto Chat";
}

void AutoChat::SetImGuiContext(uintptr_t ctx) {
	ImGui::SetCurrentContext(reinterpret_cast<ImGuiContext*>(ctx));
}

// When the plugin is loaded (manually or after build) these settings
// will show in BakkesMod (F2 while in-game) under Plugins > AutoChat
void AutoChat::RenderSettings() {
	ImGui::Text("The sole purpose of this plugin is to automatically toggle the");
	ImGui::Text("AutoChat.ahk script on/off before/after every game. This plugin");
	ImGui::Text("won't work if you aren't already running the AutoChat.ahk script.");
	ImGui::NewLine();
	CVarWrapper cvarEnabled = cvarManager->getCvar("auto_chat_enabled");
	if (cvarEnabled) {
		bool cvarVal = cvarEnabled.getBoolValue();
		ImGui::PushItemWidth(64);
		ImGui::Checkbox("Enable hotkey automation", &cvarVal);
		ImGui::Text("If you aren't running the AHK script this should be off.");
		ImGui::NewLine();
		cvarEnabled.setValue(cvarVal);
	}
	CVarWrapper cvarDefaultToggle = cvarManager->getCvar("auto_chat_smart_toggles");
	if (cvarDefaultToggle) {
		bool cvarVal = cvarDefaultToggle.getBoolValue();
		ImGui::PushItemWidth(64);
		ImGui::Checkbox("Use game start/stop keys", &cvarVal);
		ImGui::Text("This will enable multi-user message delays at the start of a round and");
		ImGui::Text("automatically trigger all static message hotkeys at the end of a round.");
		ImGui::NewLine();
		cvarDefaultToggle.setValue(cvarVal);
	}
	
	ImGui::Text("This plugin only supports F1-F12 hotkeys.");
	CVarWrapper cvarGameStartKey = cvarManager->getCvar("auto_chat_game_start_key");
	if (cvarGameStartKey) {
		string cvarStrVal = cvarGameStartKey.getStringValue();
		ImGui::PushItemWidth(32);
		ImGui::InputText("Game start key for AHK", &cvarStrVal);
		cvarGameStartKey.setValue(cvarStrVal);
	}
	CVarWrapper cvarGameStopKey = cvarManager->getCvar("auto_chat_game_stop_key");
	if (cvarGameStopKey) {
		string cvarStrVal = cvarGameStopKey.getStringValue();
		ImGui::PushItemWidth(32);
		ImGui::InputText("Game stop key for AHK", &cvarStrVal);
		cvarGameStopKey.setValue(cvarStrVal);
	}
	CVarWrapper cvarStopKey = cvarManager->getCvar("auto_chat_stop_key");
	if (cvarStopKey) {
		string cvarStrVal = cvarStopKey.getStringValue();
		ImGui::PushItemWidth(32);
		ImGui::InputText("Default stop key for AHK", &cvarStrVal);
		cvarStopKey.setValue(cvarStrVal);
	}
}