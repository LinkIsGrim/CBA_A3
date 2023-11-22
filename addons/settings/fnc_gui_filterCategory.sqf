#include "script_component.hpp"

#define SETTING_NAME (_settingInfo get "displayName")
#define SETTING_TOOLTIP (_settingInfo get "tooltip")
#define SETTING_VARIABLE (_settingInfo get "setting")
#define SETTING_TYPE (_settingInfo get "settingType")

params ["_display", ["_searchString", ""]];

private _searchPattern = ".*?/io";
if (_searchString != "") then {
    _searchPattern = _searchString regexReplace ["[.?*+^$[\]\\(){}|-]/gio", "\\$&"]; // escape any user regex characters
    _searchPattern = ".*?" + (_searchPattern splitString " " joinString ".*?") + ".*?/io";
};

private _category = uiNamespace getVariable QGVAR(addon);
private _shownSettings = (_display getVariable QGVAR(categoryControlGroups) get _category) select {ctrlShown _x};
{
    private _settingInfo = _x getVariable QGVAR(info);

    _showSetting = ([SETTING_NAME, SETTING_TOOLTIP, SETTING_VARIABLE] findIf {_x regexMatch _searchPattern}) != -1;
    if (!_showSetting && {SETTING_TYPE == "LIST"}) then {
        private _labels = _settingInfo get "settingData" param [1, []];
        _showSetting = (_labels findIf {_x regexMatch _searchPattern}) != -1;
    };
    _x ctrlEnable _showSetting;
    _x ctrlShow _showSetting;
    if (!_showSetting) then {
        _shownSettings deleteAt _forEachIndex;
    };
} forEachReversed _shownSettings;
