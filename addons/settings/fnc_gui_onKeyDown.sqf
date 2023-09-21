#include "script_component.hpp"

params ["_display", "_key", "_shift", "_ctrl"];

private _block = false;

switch (_key) do {
    case DIK_NUMPADENTER;
    case DIK_RETURN: {
        if (_display getVariable QGVAR(addonSearchbarFocus)) then {
            [_display, _display displayCtrl IDC_ADDONS_SEARCHBAR] call FUNC(gui_handleAddonSearchbar);
            _block = true;
        };
        if (_display getVariable QGVAR(settingSearchbarFocus)) then {
            [_display, _display displayCtrl IDC_SETTINGS_SEARCHBAR] call FUNC(gui_handleSettingSearchbar);
            _block = true;
        };
    };
    // Focus search bars
    case DIK_F: {
        if (_ctrl) then {
            if (_display getVariable QGVAR(settingSearchbarFocus)) then {
                ctrlSetFocus (_display displayCtrl IDC_ADDONS_SEARCHBAR);
            } else {
                ctrlSetFocus (_display displayCtrl IDC_SETTINGS_SEARCHBAR);
            };
            _block = true;
        };
    };
};

_block
