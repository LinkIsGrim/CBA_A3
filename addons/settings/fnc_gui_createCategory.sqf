#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_gui_createCategory

Description:
    Creates category for the Addon Options menu.

Parameters:
    _display - Addons Options dialog <DISPLAY>
    _category - Name of category as shown by "ADDON:" listbox, case-sensitive <STRING>

Returns:
    None

Author:
    commy2, kymckay, LinkIsGrim
---------------------------------------------------------------------------- */

params ["_display", "_category"];

if (_category in (_display getVariable QGVAR(createdCategories))) exitWith {};

// This is a controls group containing multiple CT_CONTROLS_TABLEs
// Each setting needs a CT_CONTROLS_TABLE, and each category needs a CT_CONTROLS_GROUP to contain them
// Ideally CT_CONTROLS_TABLE would support multiple row template, and this wouldn't be necessary. BI pls fix
private _ctrlOptionsGroup = _display ctrlCreate [QGVAR(OptionsGroup), -1, _display displayCtrl IDC_ADDONS_GROUP];

// Cache the options group so we don't build it more than once per display lifetime
(_display getVariable QGVAR(createdCategories)) set [_category, _ctrlOptionsGroup];

private _categorySettings = GVAR(categorySettings) get _selectedAddon;
private _subCategories = GVAR(subCategories) get _selectedAddon;

// Create all the headers for sub-categories first
// Their position will be set later via FUNC(gui_sortMenu)
{
    private _ctrlHeaderGroup = _display ctrlCreate [QGVAR(subCat), -1, _ctrlOptionsGroup];
    private _ctrlHeaderName = _ctrlHeaderGroup controlsGroupCtrl IDC_SETTING_NAME;
    _ctrlHeaderName ctrlSetText format ["%1:", _x];
    _ctrlOptionsGroup setVariable [format ["%1$%2", QGVAR(header), _x], _ctrlHeaderGroup];
} forEach (keys _subCategories);

{
    [_display, _x] call FUNC(gui_createSetting);
} forEach _categorySettings;
