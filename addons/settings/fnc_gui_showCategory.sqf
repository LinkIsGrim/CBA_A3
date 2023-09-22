#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_gui_showCategory

Description:
    Shows category for the Addon Options menu. Hides other categories if necessary.

Parameters:
    _display - Addons Options dialog <DISPLAY>
    _category - Name of category as shown by "ADDON:" listbox, case-sensitive <STRING>
    _source - Can be "client", "mission", or "server" <STRING>

Returns:
    None

Author:
    commy2, kymckay, LinkIsGrim
---------------------------------------------------------------------------- */


params ["_display", "_category", "_source"];

private _createdCategories = _display getVariable QGVAR(createdCategories);
if !(_category in _createdCategories) then {
    [_display, _category] call FUNC(gui_createCategory);
};

private _ctrlOptionsGroup = _createdCategories get _category;

{
    private _enabled = _x == _ctrlOptionsGroup;
    _x ctrlShow _enabled;
    _x ctrlEnable _enabled;
} forEach (values _createdCategories);

{ // forEach (GVAR(categorySettings) get _category)
    private _setting = _x;
    private _settingInfo = (GVAR(allSettingsData) get _setting);
    private _currentValue = GET_TEMP_NAMESPACE_VALUE(_setting,_source);

    private _ctrlSettingGroup = (_display getVariable QGVAR(createdSettings)) get _setting;
    private _settingControls =  allControls _ctrlSettingGroup;

    private _wasEdited = false;

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

    // change color if setting was edited
    private _ctrlName = GET_CTRL_NAME(_ctrlSettingGroup);
    if (_wasEdited) then {
        _ctrlName ctrlSetTextColor COLOR_TEXT_ENABLED_WAS_EDITED;
    };

    private _defaultValue = _settingInfo get "defaultValue";
    private _settingData = _settingInfo get "settingData";

    // ----- execute setting script
    private _script = getText (configFile >> ctrlClassName _ctrlSettingGroup >> QGVAR(script));
    [_ctrlSettingGroup, _setting, _source, _currentValue, _settingData] call (uiNamespace getVariable _script);

    // ----- default button
    [_ctrlSettingGroup, _setting, _source, _currentValue, _defaultValue] call FUNC(gui_settingDefault);

    // ----- priority list
    [_ctrlSettingGroup, _setting, _source, _currentPriority, _isGlobal] call FUNC(gui_settingOverwrite);

    // ----- check if setting can be altered
    private _enabled = switch (_source) do {
        case "client": {CAN_SET_CLIENT_SETTINGS && {isNil {GVAR(userconfig) getVariable _setting}}};
        case "mission": {CAN_SET_MISSION_SETTINGS && {isNil {GVAR(missionConfig) getVariable _setting}}};
        case "server": {CAN_SET_SERVER_SETTINGS && {isNil {GVAR(serverConfig) getVariable _setting}}};
    };

    if (!_enabled) then {
        _ctrlName ctrlSetTextColor COLOR_TEXT_DISABLED;
        {
            _x ctrlEnable false;
        } forEach _settingControls;
    };
} forEach (GVAR(categorySettings) get _category);

_display call FUNC(gui_sortMenu);
