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

if !(_category in (uiNamespace getVariable QGVAR(createdLists))) then {
    [_display, _category] call FUNC(gui_createCategory);
};

{ // forEach (GVAR(settingCategories) get _category)
    private _setting = _x;
    private _settingInfo = (GVAR(allSettingsData) get _setting);
    private _currentValue = GET_TEMP_NAMESPACE_VALUE(_setting,_source);

    private _settingControlsTable = (_display getVariable QGVAR(createdSettings)) get _setting;
    private _settingControls =  _settingControlsTable ctRowControls 0;

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
    private _ctrlName = _settingControls param [0, controlNull]
    if (_wasEdited) then {
        _ctrlSettingName ctrlSetTextColor COLOR_TEXT_ENABLED_WAS_EDITED;
    };

    private _defaultValue = _settingInfo get "defaultValue";
    private _settingData = _settingInfo get "settingData";

    // ----- determine display string for default value
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

    // ----- set tooltip on "Reset to default" button
    private _ctrlDefault = _settingControls param [1, controlNull];
    _ctrlDefault ctrlSetTooltip (format ["%1\n%2", localize LSTRING(default_tooltip), _defaultValueTooltip]);

    // ----- execute setting script
    private _script = getText (_rowTemplate >> QGVAR(script));
    [_settingControlsTable, _setting, _source, _currentValue, _settingData] call (uiNamespace getVariable _script);

    // ----- default button
    [_settingControlsTable, _setting, _source, _currentValue, _defaultValue] call FUNC(gui_settingDefault);

    // ----- priority list
    [_settingControlsTable, _setting, _source, _currentPriority, _isGlobal] call FUNC(gui_settingOverwrite);

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
} forEach (GVAR(settingCategories) get _category);
