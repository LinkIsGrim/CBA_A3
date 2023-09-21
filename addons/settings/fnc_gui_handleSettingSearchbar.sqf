#include "script_component.hpp"

params ["_display", "_searchbar"];

private _searchString = ctrlText _searchbar;
if (_searchString != "") then {
    _searchString = _searchString regexReplace ["[.?*+^$[\]\\(){}|-]/gio", "\\$&"]; // escape any user regex characters
    _searchString = ".*?" + (_searchString splitString " " joinString ".*?") + ".*?/io";
};

private _category = uiNamespace getVariable [QGVAR(addon), ""];
if (_category == "") then {
    private _ctrlAddonList = _display displayCtrl IDC_ADDONS_LIST;
    _category = _ctrlAddonList lbText 0;
};

private _addonSettings = GVAR(categorySettings) get _selectedAddon;
private _createdSettings = _display getVariable QGVAR(createdSettings);
{
    private _settingCtrl = _createdSettings get _x;
    private _settingName = _settingCtrl getVariable QGVAR(name);
    private _settingTooltip = _settingCtrl getVariable QGVAR(tooltip);

    private _showSetting = _settingName regexMatch _searchString || {_settingTooltip regexMatch _searchString};
    [_display, _x, _showSetting] call FUNC(gui_showSetting);
} forEach _addonSettings;

call FUNC(gui_sortMenu);
