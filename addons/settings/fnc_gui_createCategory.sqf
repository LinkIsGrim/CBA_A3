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

if (_category in (_display getVariable QGVAR(categoryControlGroups))) exitWith {};

// This is a controls group containing multiple CT_CONTROLS_GROUPs
// Each setting needs a CT_CONTROLS_GROUP, and each category needs a CT_CONTROLS_GROUP to contain them
// Ideally CT_CONTROLS_TABLE would support multiple row templates, and this wouldn't be necessary. BI pls fix
private _ctrlOptionsGroup = _display ctrlCreate [QGVAR(OptionsGroup), IDC_OPTIONS_GROUP, _display displayCtrl IDC_ADDONS_GROUP];

// Cache the options group so we don't build it more than once per display lifetime
(_display getVariable QGVAR(categoryControlGroups)) set [_category, _ctrlOptionsGroup];

private _categorySettings = GVAR(categorySettings) get _selectedAddon;
private _subCategoryNames = keys (GVAR(subCategories) get _selectedAddon);

// Create all the headers for sub-categories first
// Their position will be set later via FUNC(gui_sortMenu)
{
    private _ctrlHeaderGroup = _display ctrlCreate [QGVAR(subCat), IDC_SETTING_CONTROLS_GROUP_HEADER, _ctrlOptionsGroup];
    private _ctrlHeaderName = GET_CTRL_NAME(_ctrlHeaderGroup);
    _ctrlHeaderName ctrlSetText format ["%1:", _x];
    _ctrlOptionsGroup setVariable [format ["%1$%2", QGVAR(header), _x], _ctrlHeaderGroup];
    _ctrlHeaderGroup setVariable [QGVAR(headerControls), []];
} forEach _subCategoryNames;

{
    [_display, _x] call FUNC(gui_createSetting);
} forEach _categorySettings;
