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

params ["_display"];

private _category = uiNamespace getVariable [QGVAR(addon), ""];
if (_category == "") exitWith {};

private _createdSettings = _display getVariable QGVAR(createdSettings);
private _subCategories = GVAR(subCategories) get _category;
private _subCategoryNames = keys _subCategories;
_subCategoryNames sort true;

private _tablePosY = TABLE_LINE_SPACING/2;

// Settings with no headers go first
{
    private _settingCtrl = _createdSettings get _x;
    if (!isNull (_settingCtrl getVariable [QGVAR(header), controlNull])) then {continue};
    private _shown = ctrlShown _settingCtrl;
    if (_shown) then {
        _tablePosY = [_settingCtrl, _tablePosY] call FUNC(gui_controlSetTablePosY);
    } else {
        [_settingCtrl, 0, 0] call FUNC(gui_controlSetTablePosY);
    };
} forEach (GVAR(categorySettings) get _addon);

// Settings with headers afterwards
{
    private _headerCtrl = _ctrlOptionsGroup getVariable (format ["%1$%2", QGVAR(header), _x]);
    _tablePosY = [_headerCtrl, _tablePosY] call FUNC(gui_controlSetTablePosY);
    {
        private _settingCtrl = _createdSettings get _x;
        private _shown = ctrlShown _settingCtrl;
        if (_shown) then {
            _tablePosY = [_settingCtrl, _tablePosY] call FUNC(gui_controlSetTablePosY);
        } else {
            [_settingCtrl, 0, 0] call FUNC(gui_controlSetTablePosY);
        };
    } forEach (_subCategories get _x);
} forEach _subCategoryNames;
