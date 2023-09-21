#include "script_component.hpp"

params ["_display", "_ctrlAddonList"];

if (lbSize _ctrlAddonList > 0) then {
    lbClear _ctrlAddonList
};

private _categories = [];
{
    (GVAR(default) getVariable _x) params ["", "", "", "", "_category"];

    if !(_category in _categories) then {
        private _index = _ctrlAddonList lbAdd _category;
        _ctrlAddonList lbSetData [_index, str _index];
        _display setVariable [str _index, _category];

        _categories pushBack _category;
    };
} forEach GVAR(allSettings);

lbSort _ctrlAddonList;
