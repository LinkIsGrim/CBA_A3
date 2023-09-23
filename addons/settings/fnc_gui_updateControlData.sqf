#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_gui_updateControlData

Description:
    Updates control values, text, color and status for the Addon Options menu.

Parameters:
    _display - Addons Options dialog <DISPLAY>

Returns:
    None

Author:
    commy2, kymckay, LinkIsGrim
---------------------------------------------------------------------------- */

params ["_display"];

private _category = uiNamespace getVariable QGVAR(addon);
private _source = uiNamespace getVariable QGVAR(source);

if (isNil "_category" || {isNil "_source"}) exitWith {};

{ // forEach (GVAR(categorySettings) get _category)
    private _setting = _x;
    private _settingInfo = (GVAR(allSettingsData) get _setting);

    private _ctrlSettingGroup = (_display getVariable QGVAR(settingControlGroups)) get _setting;
    private _settingControls = allControls _ctrlSettingGroup;


    private _wasEdited = false;
    private _currentValue = GET_TEMP_NAMESPACE_VALUE(_setting,_source);
    if (isNil "_currentValue") then {
        _currentValue = [_setting, _source] call FUNC(get);
    } else {
        _wasEdited = true;
    };

    private _currentPriority = GET_TEMP_NAMESPACE_PRIORITY(_setting,_source);
    if (isNil "_currentPriority") then {
        _currentPriority = [_setting, _source] call FUNC(priority);
    } else {
        _wasEdited = true;
    };

    // Update control value
    switch (_settingInfo get "settingType") do {
        case "CHECKBOX": {
            GET_CTRL_CHECKBOX(_ctrlSettingGroup) cbSetChecked _currentValue;
        };
        case "EDITBOX": {
            GET_CTRL_EDITBOX(_ctrlSettingGroup) ctrlSetText _currentValue;
        };
        case "LIST": {
            GET_CTRL_LIST(_ctrlSettingGroup) lbSetCurSel _currentValue;
        };
        case "TIME";
        case "SLIDER": {
            GET_CTRL_SLIDER(_ctrlSettingGroup) sliderSetPosition _currentValue;
        };
        case "COLOR": {
            {
                private _sliderPos = _x;
                private _xSlider = _ctrlSettingGroup controlsGroupCtrl (IDCS_SETTING_COLOR select _forEachIndex);
                _xSlider sliderSetPosition _sliderPos;
            } forEach _currentValue;
        };
    };

    // ----- check if setting can be altered
    private _enabled = switch (_source) do {
        case "client": {CAN_SET_CLIENT_SETTINGS && {isNil {GVAR(userconfig) getVariable _setting}}};
        case "mission": {CAN_SET_MISSION_SETTINGS && {isNil {GVAR(missionConfig) getVariable _setting}}};
        case "server": {CAN_SET_SERVER_SETTINGS && {isNil {GVAR(serverConfig) getVariable _setting}}};
    };

    {
        _x ctrlEnable _enabled;
    } forEach _settingControls;

    // change color if setting was edited/disabled
    private _ctrlName = GET_CTRL_NAME(_ctrlSettingGroup);
    private _ctrlTextColor = COLOR_TEXT_ENABLED;
    if (_wasEdited) then {
        _ctrlTextColor = COLOR_TEXT_ENABLED_WAS_EDITED;
    };
    if (!_enabled) then {
        _ctrlTextColor = COLOR_TEXT_DISABLED;
    };

    _ctrlName ctrlSetTextColor _ctrlTextColor;
} forEach (GVAR(categorySettings) get _category);
