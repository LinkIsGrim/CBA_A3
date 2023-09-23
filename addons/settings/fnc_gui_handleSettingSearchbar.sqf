#include "script_component.hpp"

#define LAST_SEARCH_TEXT (_display getVariable [QGVAR(lastSearchTextSetting), ""])
#define SETTING_NAME (_settingInfo get "displayName")
#define SETTING_TOOLTIP (_settingInfo get "tooltip")
#define SETTING_VARIABLE (_settingInfo get "setting")
#define SETTING_TYPE (_settingInfo get "settingType")

params ["_display", "_searchbar"];

private _searchString = ctrlText _searchbar;
private _searchPattern = ".*?/io";
if (_searchString != "") then {
    _searchPattern = _searchString regexReplace ["[.?*+^$[\]\\(){}|-]/gio", "\\$&"]; // escape any user regex characters
    _searchPattern = ".*?" + (_searchPattern splitString " " joinString ".*?") + ".*?/io";
};

private _category = uiNamespace getVariable QGVAR(addon);
if (LAST_SEARCH_TEXT != "" && {(_searchString find LAST_SEARCH_TEXT) != 0}) then {
    {
        [_display, _x, true] call FUNC(gui_showSetting);
    } forEach (GVAR(categorySettings) get _category);
};
_display setVariable [QGVAR(lastSearchTextSetting), _searchString];

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

call FUNC(gui_sortMenu);
