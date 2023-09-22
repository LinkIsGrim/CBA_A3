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

#define UPDATE_CONTROL_POS(control)
#define HIDE_CONTROL(control) [control, 0, 0] call FUNC(gui_controlSetTablePosY)

params ["_display"];

private _category = uiNamespace getVariable [QGVAR(addon), ""];
if (_category == "") exitWith {};

private _createdSettings = _display getVariable QGVAR(createdSettings);

private _tablePosY = TABLE_LINE_SPACING/2;
private _hasHeader = false;

// Settings with no headers go first
{
    private _settingCtrl = _createdSettings get _x;
    if (!isNil {_settingCtrl getVariable QGVAR(header)}) then {
        _hasHeader = true;
        continue
    };
    if (ctrlShown _settingCtrl) then {
        _tablePosY = [_settingCtrl, _tablePosY] call FUNC(gui_controlSetTablePosY);
    } else {
        [_settingCtrl, 0, 0] call FUNC(gui_controlSetTablePosY);
    };
} forEach (GVAR(categorySettings) get _category);

private _ctrlOptionsGroup = _display getVariable QGVAR(createdCategories) get _category;
if !(_hasHeader) exitWith {
    _ctrlOptionsGroup ctrlSetScrollValues [0, -1];
};

// Settings with headers afterwards
private _subCategoryNames = keys (GVAR(subCategories) get _category);
_subCategoryNames sort true;

private _headers = _subCategoryNames apply {_ctrlOptionsGroup getVariable (format ["%1$%2", QGVAR(header), _x])};
{
    private _headerControls = _x getVariable QGVAR(headerControls);
    diag_log str _headerControls;

    // Hide header if no settings are shown
    if (_headerControls findIf {ctrlShown _x} == -1) then {
        _x ctrlShow false;
        [_x, 0, 0] call FUNC(gui_controlSetTablePosY);
    } else {
        _x ctrlShow true;
        _tablePosY = [_x, _tablePosY] call FUNC(gui_controlSetTablePosY);
    };
    {
        if (ctrlShown _x) then {
            _tablePosY = [_x, _tablePosY] call FUNC(gui_controlSetTablePosY);
        } else {
            [_x, 0, 0] call FUNC(gui_controlSetTablePosY);
        };
    } forEach _headerControls;
} forEach _headers;
_ctrlOptionsGroup ctrlSetScrollValues [0, -1];
