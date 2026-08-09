#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Function: CBA_fnc_currentUnit

Description:
    Returns the controlled unit. ("player" or a remote controlled unit)

    Uses focusOn, so any use of remoteControl is reported, not just the Zeus module
    that sets bis_fnc_moduleRemoteControl_unit. Falls back to the player unit when
    nothing is being controlled, as focusOn returns objNull in that case.

Parameters:
    None

Returns:
    Currently controlled unit <OBJECT>

Author:
    commy2
---------------------------------------------------------------------------- */
SCRIPT(currentUnit);

private _unit = focusOn;

[_unit, player] select (isNull _unit) // return
