#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_gui_createSetting

Description:
    Creates a setting for the Addon Options menu.

Parameters:
    _display - Addons Options dialog <DISPLAY>
    _setting - Variable Name of Setting, case-sensitive <STRING>

Returns:
    None

Author:
    commy2, kymckay, LinkIsGrim
---------------------------------------------------------------------------- */

params ["_display", "_setting", "_ctrlOptionsGroup"];

if (_setting in (_display getVariable QGVAR(createdSettings))) exitWith {};

private _source = uiNamespace getVariable QGVAR(source);
private _settingInfo = (GVAR(allSettingsData) get _setting);
private _category = _settingInfo get "category";
private _ctrlOptionsGroup = (_display getVariable QGVAR(createdCategories)) get _category;

private _settingControlsTable = _display ctrlCreate [QGVAR(Row_Base_Table), IDC_SETTING_CONTROLS_GROUP, _ctrlOptionsGroup];

// Create setting control group
private _settingType = _settingInfo get "settingType";
private _rowTemplate = configFile >> QGVAR(Row_Base_Table) >> "RowTemplate" >> _settingType;

(_display getVariable QGVAR(createdSettings)) set [_setting, _settingControlsTable];
private _subCategory = _settingInfo get "subCategory";
if (_subCategory != "") then {
    private _header = _ctrlOptionsGroup getVariable [format ["%1$%2", QGVAR(header), _x], controlNull];
    _settingControlsTable setVariable [QGVAR(header), _header];
};

_settingControlsTable ctSetRowTemplate _rowTemplate;
(ctAddRow _settingControlsTable) params ["_ctrlName"];

// Set name and tooltip
private _displayName = _settingInfo get "displayName";
private _tooltip = _settingInfo get "tooltip";

if (_tooltip == "") then {
    _tooltip = _x;
} else {
    _tooltip = format ["%1\n%2", _tooltip, _x];
};

_ctrlName ctrlSetText format ["%1:", _displayName];
_ctrlName ctrlSetTooltip _tooltip;
