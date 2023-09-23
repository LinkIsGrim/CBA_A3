#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_gui_sourceChanged

Description:
    Handles changing setting source in the Addon Options menu.

Parameters:
    _display - Addons Options dialog <DISPLAY>

Returns:
    None

Author:
    commy2, kymckay, LinkIsGrim
---------------------------------------------------------------------------- */

// get button
params ["_control"];

// get dialog
private _display = ctrlParent _control;

private _category = uiNamespace getVariable QGVAR(addon);
private _source = ["server", "mission", "client"] param [[IDC_BTN_SERVER, IDC_BTN_MISSION, IDC_BTN_CLIENT] find ctrlIDC _control];

uiNamespace setVariable [QGVAR(source), _source];

_display call FUNC(gui_updateControlData);

// toggle source buttons
{
    private _ctrlX = _display displayCtrl _x;
    _ctrlX ctrlSetTextColor ([COLOR_BUTTON_ENABLED, COLOR_BUTTON_DISABLED] select (_control == _ctrlX && {!isClass (configFile >> "CfgPatches" >> "A3_Data_F_Contact")}));
    _ctrlX ctrlSetBackgroundColor ([COLOR_BUTTON_DISABLED, COLOR_BUTTON_ENABLED] select (_control == _ctrlX));
} forEach [IDC_BTN_SERVER, IDC_BTN_MISSION, IDC_BTN_CLIENT];

(_display displayCtrl IDC_TXT_OVERWRITE_CLIENT) ctrlShow (_source isNotEqualTo "client");
(_display displayCtrl IDC_TXT_OVERWRITE_MISSION) ctrlShow (_source isEqualTo "server");

// enable / disable IMPORT and LOAD buttons
private _ctrlButtonImport = _display displayCtrl IDC_BTN_IMPORT;
private _ctrlButtonLoad = _display displayCtrl IDC_BTN_LOAD;

private _enabled = switch (_source) do {
    case "server": {CAN_SET_SERVER_SETTINGS};
    case "mission": {CAN_SET_MISSION_SETTINGS};
    case "client": {CAN_SET_CLIENT_SETTINGS};
};

_ctrlButtonImport ctrlEnable _enabled;
_ctrlButtonLoad ctrlEnable _enabled;
