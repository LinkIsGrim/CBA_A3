#include "script_component.hpp"

// get button
params ["_control", "_index"];

// get dialog
private _display = ctrlParent _control;

private _selectedAddon = _display getVariable (_control lbData _index);

// fix error when no addons present
if (isNil "_selectedAddon") exitWith {};

if (_selectedAddon isEqualType "") then {
    uiNamespace setVariable [QGVAR(addon), _selectedAddon];
};

// toggle lists
private _selectedSource = uiNamespace getVariable QGVAR(source);

if !(_display getVariable [_selectedAddon, false]) then {
    [_display, _selectedAddon, _selectedSource] call FUNC(gui_showCategory);
    _display setVariable [_selectedAddon, true];
};
