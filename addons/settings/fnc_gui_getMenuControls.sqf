#include "script_component.hpp"

params [["_display", displayNull]];

if (isNull _display) then {
    _display = uiNamespace getVariable [QGVAR(display), displayNull];
};

if (isNull _display) exitWith {[]};

private _addon = uiNamespace getVariable [QGVAR(addon), ""];
if (_addon isEqualTo "") exitWith {[]};

private _source = uiNamespace getVariable [QGVAR(source), ""];

private _controls = createHashMap;

{
    _controls set [_x, (_display getVariable (format ["%1$%2$%3", QGVAR(controlGroup), _x, _source]))];
} forEach (GVAR(categorySettings) get _addon);

_controls
