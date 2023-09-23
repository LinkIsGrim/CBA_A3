#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_gui_sourceChanged

Description:
    Handles changing addon in the Addon Options menu.

Parameters:
    _control - Addon combobox <CONTROL>
    _index - Addon combobox selection index <NUMBER>

Returns:
    None

Author:
    commy2, kymckay, LinkIsGrim
---------------------------------------------------------------------------- */

// get button
params ["_control", "_index"];

// get dialog
private _display = ctrlParent _control;

private _selectedAddon = (_control lbText _index);

// fix error when no addons present
if (isNil "_selectedAddon") exitWith {};

if (_selectedAddon isEqualType "") then {
    uiNamespace setVariable [QGVAR(addon), _selectedAddon];
};

[_display, _selectedAddon] call FUNC(gui_showCategory);
