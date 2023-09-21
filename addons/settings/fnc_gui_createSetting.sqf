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

private _settingInfo = (GVAR(allSettingsData) get _setting);
private _category = _settingInfo get "category";
private _ctrlOptionsGroup = (_display getVariable QGVAR(createdCategories)) get _category;

// Create setting control group
private _settingType = _settingInfo get "settingType";
if (_settingType == "COLOR" && {count _defaultValue > 3}) then {
    _settingType = "ColorAlpha";
};
private _ctrlSettingGroup = _display ctrlCreate [format ["%1_%2", QGVAR(Row), _settingType], IDC_SETTING_CONTROLS_GROUP, _ctrlOptionsGroup]

(_display getVariable QGVAR(createdSettings)) set [_setting, _ctrlSettingGroup];
private _subCategory = _settingInfo get "subCategory";
if (_subCategory != "") then {
    private _header = _ctrlOptionsGroup getVariable [format ["%1$%2", QGVAR(header), _x], controlNull];
    (_header getVariable QGVAR(headerControls)) pushBack _ctrlSettingGroup;
    _ctrlSettingGroup setVariable [QGVAR(header), _header];
};

private _displayName = _settingInfo get "displayName";
private _tooltip = _settingInfo get "tooltip";
private _settingData = _settingInfo get "settingData"

// Save setting info in the control for easier searching/export
_ctrlSettingGroup setVariable [QGVAR(info), _settingInfo];
_ctrlSettingGroup setVariable [QGVAR(params), _settingData];
_ctrlSettingGroup setVariable [QGVAR(setting), _setting];
_ctrlSettingGroup setVariable [QGVAR(name), _displayName];
_ctrlSettingGroup setVariable [QGVAR(tooltip), _tooltip];

// Set name and tooltip
if (_tooltip == "") then {
    _tooltip = _x;
} else {
    _tooltip = format ["%1\n%2", _tooltip, _x];
};

_ctrlName ctrlSetText format ["%1:", _displayName];
_ctrlName ctrlSetTooltip _tooltip;

private _defaultValue = _settingInfo get "defaultValue";
// Determine display string for default value
private _defaultValueTooltip = switch (toUpper _settingType) do {
    case "LIST": {
        _settingData params ["_values", "_labels"];

        _labels param [_values find _defaultValue, ""];
    };
    case "SLIDER": {
        if (_settingData param [3, false]) then {
            format [localize "STR_3DEN_percentageUnit", round (_defaultValue * 100), "%"]
        } else {
            _defaultValue
        };
    };
    case "COLOR": {
        private _template = (["R: %1", "G: %2", "B: %3", "A: %4"] select [0, count _defaultValue]) joinString "\n";
        format ([_template] + _defaultValue)
    };
    case "TIME": {
        _defaultValue call CBA_fnc_formatElapsedTime
    };
    default {_defaultValue};
};

// Set tooltip on "Reset to default" button
private _ctrlDefault = GET_CTRL_DEFAULT(_ctrlSettingGroup);
_ctrlDefault ctrlSetTooltip (format ["%1\n%2", LLSTRING(default_tooltip), _defaultValueTooltip]);
