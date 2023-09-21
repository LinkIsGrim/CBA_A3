#include "script_component.hpp"

params ["_display", "_searchbar"];

private _searchString = ctrlText _searchbar;
if (_searchString != "") then {
    _searchString = _searchString regexReplace ["[.?*+^$[\]\\(){}|-]/gio", "\\$&"]; // escape any user regex characters
    _searchString = ".*?" + (_searchString splitString " " joinString ".*?") + ".*?/io";
};

private _ctrlAddonList = _display displayCtrl IDC_ADDONS_LIST;

private _selectedAddon = _ctrlAddonList lbText lbCurSel _ctrlAddonList;
if (_selectedAddon == "") then {
    _selectedAddon = _ctrlAddonList lbText 0;
};

[_display, _selectedAddon, _searchString] call FUNC(gui_filterCategory)
