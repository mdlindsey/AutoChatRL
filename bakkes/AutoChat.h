#pragma once
#include <string>
#include <Windows.h>

#include "bakkesmod/plugin/bakkesmodplugin.h"
#include "bakkesmod/plugin/pluginwindow.h"
#include "bakkesmod/plugin/PluginSettingsWindow.h"

#include "version.h"


#define SC_ENTER 0x1C

using namespace std;

constexpr auto plugin_version = stringify(VERSION_MAJOR) "." stringify(VERSION_MINOR) "." stringify(VERSION_PATCH) "." stringify(VERSION_BUILD);

class AutoChat: public BakkesMod::Plugin::BakkesModPlugin, public BakkesMod::Plugin::PluginSettingsWindow {
	// Boilerplate
	virtual void onLoad();
	virtual void onUnload();

	// Inherited via PluginSettingsWindow
	string GetPluginName() override;
	void RenderSettings() override;
	void SetImGuiContext(uintptr_t ctx) override; 

	// Game event listeners
	void onKickoffTimerStart(ServerWrapper caller, void* params, string eventName);
	void onGameComplete(ServerWrapper caller, void* params, string eventName);
};
