#include "script_component.hpp"

params ["_control", "_tablePosY", "_height"];

private _config = configFile >> ctrlClassName _control;

private _posX = getNumber (_config >> "x");
private _posY = getNumber (_config >> "y") + _tablePosY;
private _width = getNumber (_config >> "w");

if (isNil "_height") then {
    _height = getNumber (_config >> "h");
};

_control ctrlSetPosition [_posX, _posY, _width, _height];
_control ctrlCommit 0;

_posY + _height
