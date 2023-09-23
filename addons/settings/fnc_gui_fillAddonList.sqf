#include "script_component.hpp"

params ["_display", "_ctrlAddonList", ["_filter", false]];

if (lbSize _ctrlAddonList > 0) then {
    lbClear _ctrlAddonList
};

{
    _ctrlAddonList lbAdd _x;
    _ctrlAddonList lbSetData [_forEachIndex, str _forEachIndex];
    _display setVariable [str _forEachIndex, _x];
} forEach (keys GVAR(categorySettings));

lbSort _ctrlAddonList;
