#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_gui_sortMenu
Description:
    Sorts the Addon Options menu.

Parameters:
    _display - Addons Options dialog <DISPLAY>

Returns:
    None

Author:
    LinkIsGrim
---------------------------------------------------------------------------- */

#define UPDATE_CONTROL_POS(control) _tablePosY = [control, _tablePosY] call FUNC(gui_controlSetTablePos)
#define HIDE_CONTROL(control) [control, 0, 0] call FUNC(gui_controlSetTablePosY)

params ["_display"];

private _category = uiNamespace getVariable [QGVAR(addon), ""];
if (_category == "") exitWith {};

private _createdSettings = _display getVariable QGVAR(createdSettings);
private _subCategoryNames = keys (GVAR(subCategories) get _category);
_subCategoryNames sort true;

private _tablePosY = TABLE_LINE_SPACING/2;

// Settings with no headers go first
{
    private _settingCtrl = _createdSettings get _x;
    if (!isNil {_settingCtrl getVariable QGVAR(header)}) then {continue};
    if (ctrlShown _settingCtrl) then {
        UPDATE_CONTROL_POS(_settingCtrl);
    } else {
        HIDE_CONTROL(_settingCtrl);
    };
} forEach (GVAR(categorySettings) get _addon);


// Settings with headers afterwards
private _ctrlOptionsGroup = _display getVariable QGVAR(createdCategories) get _addon;
private _headers = _subCategoryNames apply {_ctrlOptionsGroup getVariable (format ["%1$%2", QGVAR(header), _x])};
{
    private _headerControls = _x getVariable QGVAR(headerControls);

    // Hide header if no settings are shown
    if (_headerControls findIf {ctrlShown _x} == -1) then {
        _x ctrlShow false;
        HIDE_CONTROL(_x);
    } else {
        _x ctrlShow true;
        UPDATE_CONTROL_POS(_x);
    };
    {
        if (ctrlShown _x) then {
            UPDATE_CONTROL_POS(_x);
        } else {
            HIDE_CONTROL(_x);
        };
    } forEach _headerControls;
} forEach _headers;
