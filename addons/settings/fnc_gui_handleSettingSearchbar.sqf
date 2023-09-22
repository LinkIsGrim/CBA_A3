#include "script_component.hpp"

#define LAST_SEARCH_TEXT (_display getVariable [QGVAR(lastSearchTextSetting), ""])

params ["_display", "_searchbar"];

private _searchString = ctrlText _searchbar;
private _searchPattern = ".*?/io";
if (_searchString != "") then {
    _searchPattern = _searchString regexReplace ["[.?*+^$[\]\\(){}|-]/gio", "\\$&"]; // escape any user regex characters
    _searchPattern = ".*?" + (_searchPattern splitString " " joinString ".*?") + ".*?/io";
};

private _category = uiNamespace getVariable [QGVAR(addon), ""];
if (_category == "") then {
    private _ctrlAddonList = _display displayCtrl IDC_ADDONS_LIST;
    _category = _ctrlAddonList lbText 0;
};
if (LAST_SEARCH_TEXT != "" && {(_searchString find LAST_SEARCH_TEXT) != 0}) then {
    _display setVariable [QGVAR(shownSettings), nil];
    {
        [_display, _x, true] call FUNC(gui_showSetting);
    } forEach (GVAR(categorySettings) get _category);
};

_display setVariable [QGVAR(lastSearchTextSetting), _searchString];

if (_searchString == "") exitWith {
    call FUNC(gui_sortMenu);
};

// Micro-optimization, saves memory allocation time in loop
private _createdSettings = _display getVariable QGVAR(createdSettings);
private _settingInfo = createHashMap;
private _displayName = "";
private _tooltip = "";
private _type = "";
private _settingCtrl = controlNull;
private _showSetting = false;
private _labels = [];
private _shownSettings = _display getVariable [QGVAR(shownSettings), +(GVAR(categorySettings) get _category)];

{
    _settingCtrl = _createdSettings get _x;
    _settingInfo = _settingCtrl getVariable QGVAR(info);
    _displayName = _settingInfo get "displayName";
    _tooltip = _settingInfo get "tooltip";
    _type = _settingInfo get "settingType";

    _showSetting = _displayName regexMatch _searchPattern || {_tooltip regexMatch _searchPattern} || {_x regexMatch _searchPattern};
    if (!_showSetting && {_type == "LIST"}) then {
        _labels = _settingInfo get "settingData" param [1, []];
        {
            if (_x regexMatch _searchPattern) then {
                _showSetting = true;
                break;
            };
        } forEach _labels;
    };
    [_display, _x, _showSetting] call FUNC(gui_showSetting);
    if (!_showSetting) then {
        _shownSettings deleteAt _forEachIndex;
    };
} forEachReversed _shownSettings;

_display setVariable [QGVAR(shownSettings), _shownSettings];

call FUNC(gui_sortMenu);
