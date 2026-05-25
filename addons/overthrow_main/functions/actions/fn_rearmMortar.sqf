params ["_user"];

private _veh = objectParent _user;
if (isNull _veh || _veh isEqualTo _user) exitWith {};

private _mortarAmmo = [
    "ACE_1Rnd_82mm_Mo_HE",
    "ACE_1Rnd_82mm_Mo_Smoke",
    "ACE_1Rnd_82mm_Mo_Illum",
    "ACE_1Rnd_82mm_Mo_HE_Guided",
    "ACE_1Rnd_82mm_Mo_HE_LaserGuided"
];

private _shells = [];

{
    if (_x in _mortarAmmo) then {
        _shells pushBack _x;
    };
} forEach magazines _user;

if (_shells isEqualTo []) exitWith {
    "No mortar ammo found" call OT_fnc_notifyMinor;
};

private _count = count _shells;
private _time = _count * 7;

format ["Loading %1 mortar shells...", _count] call OT_fnc_notifyMinor;
[_time, false] call OT_fnc_progressBar;

_veh enableSimulation false;


[_user, _veh, _shells, _time] remoteExecCall ["TAG_fnc_mortarServer", 2];

TAG_fnc_mortarServer = {
    params ["_user", "_veh", "_shells", "_time"];

    if (!local _veh) exitWith {
        [_user, _veh, _shells, _time] remoteExecCall ["TAG_fnc_mortarServer", _veh];
    };

    private _aceAmmoHandling =
        ["ace_advanced_ammoHandling_enabled"] call CBA_fnc_getSetting;

    sleep _time;

    {
        if (_aceAmmoHandling) then {
            _veh addMagazineTurret [_x, [0]];
        } else {
            _veh addMagazine _x;
        };

        _user removeMagazine _x;

    } forEach _shells;

    reload _veh;

    [_veh, true] remoteExecCall ["enableSimulationGlobal", 0];
};
