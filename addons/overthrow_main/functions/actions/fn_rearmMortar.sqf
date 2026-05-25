params ["_user"];
private _veh = objectParent _user;
if (isNull _veh || _veh isEqualTo _user) exitWith {
    "Not in a mortar" call OT_fnc_notifyMinor;
};
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
[_user, _veh, _shells, _time] remoteExecCall [
    {
        params ["_user", "_veh", "_shells", "_time"];
        if (!local _veh) exitWith {
            [_user, _veh, _shells, _time] remoteExecCall [_thisScript, _veh];
        };
        private _aceAmmoHandling = ["ace_advanced_ammoHandling_enabled"] call CBA_fnc_getSetting;
        sleep _time;
        {
            if (_aceAmmoHandling) then {
                _veh addMagazineTurret [_x, [0]];
            } else {
                _veh addMagazine _x;
            };
            if (local _user) then {
                _user removeMagazine _x;
            } else {
                [_user, _x] remoteExecCall [
                    {
                        params ["_u", "_m"];
                        _u removeMagazine _m;
                    },
                    _user
                ];
            };
            diag_log format ["MORTAR DEBUG - Loaded shell: %1", _x];
        } forEach _shells;
        reload _veh;
        [_veh, true] remoteExecCall ["enableSimulationGlobal", 0];
        diag_log format [
            "MORTAR DEBUG - Mortar Ammo After: %1",
            magazinesAmmo _veh
        ];
    },
    2
];
[_veh, _time, _count] spawn {
    params ["_veh", "_time", "_count"];
    sleep (_time + 1);
    _veh enableSimulation true;
    format ["Loaded %1 mortar shells", _count] call OT_fnc_notifyMinor;
};
