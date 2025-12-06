params ["_veh", "_pos", "_fnc"];
if ((_fnc select [0, 6]) != "OT_fnc") then {
    //Legacy building Init

    private _code = {};
    if ("policeStation" in _fnc) then {
        _code = OT_fnc_initPoliceStation;
    };
    if ("trainingCamp" in _fnc) then {
        _code = OT_fnc_initTrainingCamp;
    };
    if ("warehouse" in _fnc) then {
        _code = OT_fnc_initWarehouse;
    };
    if ("workshop" in _fnc) then {
        _code = OT_fnc_initWorkshop;
    };
    [_pos, _veh] spawn _code;
} else {
    [_pos, _veh] spawn (missionNamespace getVariable _fnc);
};
