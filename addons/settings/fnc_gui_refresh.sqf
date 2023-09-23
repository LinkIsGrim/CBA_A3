#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_gui_refresh

Description:
    Resets all settings controls to their current (temporary) value.

Parameters:
    None

Returns:
    None

Author:
    commy2
---------------------------------------------------------------------------- */

private _display = uiNamespace getVariable [QGVAR(display), displayNull];
private _addon = uiNamespace getVariable QGVAR(addon);
private _source = uiNamespace getVariable QGVAR(source);

if (isNil "_source" || {isNil "_addon"}) exitWith {};

private _controls = _display getVariable QGVAR(categoryControlGroups) get _addon;

{
    private _setting = _x getVariable QGVAR(setting);

    private _value = GET_TEMP_NAMESPACE_VALUE(_setting,_source);
    private _wasEdited = false;

    if (isNil "_value") then {
        _value = [_setting, _source] call FUNC(get);
    } else {
        _wasEdited = true;
    };

    [_x, _value] call (_x getVariable QFUNC(updateUI));

    private _priority = GET_TEMP_NAMESPACE_PRIORITY(_setting,_source);

    if (isNil "_priority") then {
        _priority = [_setting, _source] call FUNC(priority);
    } else {
        _wasEdited = true;
    };

    [_x, _priority] call (_x getVariable QFUNC(updateUI_priority));

    // ----- check if setting can be altered
    private _enabled = switch (_source) do {
        case "client": {CAN_SET_CLIENT_SETTINGS && {isNil {GVAR(userconfig) getVariable _setting}}};
        case "mission": {CAN_SET_MISSION_SETTINGS && {isNil {GVAR(missionConfig) getVariable _setting}}};
        case "server": {CAN_SET_SERVER_SETTINGS && {isNil {GVAR(serverConfig) getVariable _setting}}};
    };

    _x ctrlEnable _enabled;

    // change color if setting was edited/disabled
    private _ctrlName = GET_CTRL_NAME(_x);
    private _ctrlTextColor = COLOR_TEXT_ENABLED;
    if (_wasEdited) then {
        _ctrlTextColor = COLOR_TEXT_ENABLED_WAS_EDITED;
    };
    if (!_enabled) then {
        _ctrlTextColor = COLOR_TEXT_DISABLED;
    };

    _ctrlName ctrlSetTextColor _ctrlTextColor;
} forEach _controls;
