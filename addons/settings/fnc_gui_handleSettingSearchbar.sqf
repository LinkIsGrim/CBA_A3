#include "script_component.hpp"

#define LAST_SEARCH_TEXT (_display getVariable [QGVAR(lastSearchText), ""])
#define SETTING_NAME (_settingInfo get "displayName")
#define SETTING_TOOLTIP (_settingInfo get "tooltip")
#define SETTING_VARIABLE (_settingInfo get "setting")
#define SETTING_TYPE (_settingInfo get "settingType")

params ["_display", "_searchbar", ["_overrideRefill", false]];

private _searchString = ctrlText _searchbar;
private _ctrlAddonList = _display displayCtrl IDC_ADDONS_LIST;

private _category = uiNamespace getVariable QGVAR(addon);
if (!_overrideRefill && {LAST_SEARCH_TEXT != ""} && {(_searchString find LAST_SEARCH_TEXT) != 0}) then {
    [_display, _ctrlAddonList] call FUNC(gui_fillAddonList);
    {
        [_display, _x, true] call FUNC(gui_showSetting);
    } forEach (GVAR(categorySettings) get _category);
};
_display setVariable [QGVAR(lastSearchText), _searchString];

private _removeCategory = false;

if (_searchString == "") exitWith {
    call FUNC(gui_sortMenu);
};

private _searchPattern = _searchString regexReplace ["[.?*+^$[\]\\(){}|-]/gio", "\\$&"]; // escape any user regex characters
_searchPattern = ".*?" + (_searchPattern splitString " " joinString ".*?") + ".*?/io";;

[_ctrlAddonList, _searchPattern] call FUNC(gui_filterAddonList);
_removeCategory = [_display, _searchPattern] call FUNC(gui_filterCategory);

if (_removeCategory && {!_overrideRefill}) exitWith {
    if (lbSize _ctrlAddonList > 1) then {
        _ctrlAddonList lbDelete (lbCurSel _ctrlAddonList);
        _ctrlAddonList lbSetCurSel 0;
    };
};

call FUNC(gui_sortMenu);
