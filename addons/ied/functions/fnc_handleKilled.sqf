#include "script_component.hpp"
params ["_unit", "_killer", "_instigator", "_useEffects"];

// ensure event is only called once
private _killedEhId = _unit getVariable [QGVAR(KilledEhId), -1];
diag_log format ["_killedEhId %1 ",_killedEhId];
if (_killedEhId != -1) then {
    _unit removeEventHandler ["Killed", _killedEhId];
    private _attachedObjects = attachedObjects _unit;
    private _index = _attachedObjects findIf {typeOf _x == QGVAR(Charge)};
    if (_index == -1) exitWith {};
    private _charges = _attachedObjects select {typeOf _x == QGVAR(Charge)};
    {
        private _charge = _x;
        private _isBomb = _charge getVariable [QGVAR(bomb),false];
        diag_log format ["_Charge :%2, _isBomb:%1",_charge, _isBomb];
        if (_isBomb) then {
            [QGVAR(explosion), [_charge]] call CBA_fnc_serverEvent;
        } else {
            deleteVehicle _charge;
        };
    } forEach _charges;
};


