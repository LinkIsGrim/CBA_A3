#include "script_component.hpp"

params ["_display", ["_addon", ""], ["_searchString", ""]];

private _menuControlsMap = _display call FUNC(gui_getMenuControls);
private _menuControls = values _menuControlsMap;
private _ctrlOptionsGroup = ctrlParentControlsGroup (_menuControls select 0);
private _headers = ((allControls _ctrlOptionsGroup) - _menuControls) select {ctrlType _x == 15};

if (_searchString isEqualTo "") exitWith {
    {
        _x ctrlShow true;
        _x ctrlEnable true;
        _x ctrlSetPosition (_x getVariable QGVAR(originalPosition));
        _x ctrlCommit 0;
    } forEach (_menuControls + _headers);
};

private _matches = [];
private _availableSettings = GVAR(categorySettings) get _addon;

{
    private _settingData = GVAR(allSettingsData) get _x;
    private _displayName = _settingData get "displayName";
    private _tooltip = _settingData get "tooltip";
    if (_displayName regexMatch _searchString || {_tooltip regexMatch _searchString}) then {
        private _settingControl = _menuControlsMap get _x;
        _matches pushBack _settingControl;
    };
} forEach _availableSettings;

private _tablePosY = TABLE_LINE_SPACING/2;

{
    private _enable = _x in _matches;
    _x ctrlShow _enable;
    _x ctrlEnable _enable;
    if (_enable) then {
        _tablePosY = [_x, _tablePosY] call FUNC(gui_controlSetTablePosY);
    } else {
        ([_x, 0] call FUNC(gui_controlSetTablePosY));
    };
} forEach _menuControls;

{
    _x ctrlShow false;
    ([_x, 0, 0] call FUNC(gui_controlSetTablePosY));
} forEach _headers;

_ctrlOptionsGroup ctrlSetScrollValues [0, -1];
