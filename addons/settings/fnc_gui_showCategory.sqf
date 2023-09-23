#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_gui_showCategory

Description:
    Shows category for the Addon Options menu. Hides other categories.

Parameters:
    _display - Addons Options dialog <DISPLAY>
    _category - Name of category as shown by "ADDON:" listbox, case-sensitive <STRING>

Returns:
    None

Author:
    commy2, kymckay, LinkIsGrim
---------------------------------------------------------------------------- */


params ["_display", "_category"];

private _createdCategories = _display getVariable QGVAR(categoryControlGroups);
if !(_category in _createdCategories) then {
    [_display, _category] call FUNC(gui_createCategory);
};

private _ctrlOptionsGroup = _createdCategories get _category;

{
    private _enabled = _x == _ctrlOptionsGroup;
    _x ctrlShow _enabled;
    _x ctrlEnable _enabled;
} forEach (values _createdCategories);

_display call FUNC(gui_updateControlData);

_display call FUNC(gui_sortMenu);
