#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_gui_showSetting
Description:
    Shows/hides a setting from the Addon Options menu. Doesn't sort the menu.

Parameters:
    _display - Addons Options dialog <DISPLAY>
    _setting - Variable Name of Setting, case-sensitive <STRING>

Returns:
    None

Author:
    LinkIsGrim
---------------------------------------------------------------------------- */

params ["_display", "_setting", "_show"];

private _settingCtrl = _display getVariable QGVAR(settingControlGroups) get _setting;

_settingCtrl ctrlShow _show;
_settingCtrl ctrlEnable _show;
