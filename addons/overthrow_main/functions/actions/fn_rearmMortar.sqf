params ["_user"];
private _mortar = vehicle _user;
private _shells = [];

private _mortarAmmo = [
    "ACE_1Rnd_82mm_Mo_HE",
    "ACE_1Rnd_82mm_Mo_Smoke",
    "ACE_1Rnd_82mm_Mo_Illum",
    "ACE_1Rnd_82mm_Mo_HE_Guided",
    "ACE_1Rnd_82mm_Mo_HE_LaserGuided"
];

{
    if (_x in _mortarAmmo) then {
        _shells pushBack _x;
    };
} forEach magazines _user;

diag_log format ["MORTAR DEBUG - Found Shells: %1", _shells];

private _count = count _shells;
private _time = _count * 7;

if (_count <= 0) exitWith {
    "No mortar ammo found" call OT_fnc_notifyMinor;
};

private _veh = objectParent _user;
if (_veh isEqualTo _user) exitWith {};
if (isPlayer _user) then {
    _veh enableSimulation false;
    [_time, _veh] spawn {
        params ["_time", "_veh"];
        sleep (_time + 5);
        _veh enableSimulation true;
        //Fail safe for user input disabled.
    };
    format ["Loading %1 mortar shells...", _count] call OT_fnc_notifyMinor;
    [_time, false] call OT_fnc_progressBar;
} else {
    _user globalChat format ["Loading %1 mortar shells...", _count];
};
private _aceAmmoHandling = ace_mk6mortar_useAmmoHandling; //["ace_mk6mortar_useAmmoHandling"] call CBA_fnc_getSetting;
sleep _time;

{
    if (_aceAmmoHandling) then {
        _mortar addMagazineTurret [_x, [0]];
    } else {
        _mortar addMagazine _x;
    };
    _user removeMagazine _x;

    diag_log format ["MORTAR DEBUG - Loaded shell: %1", _x];

} forEach _shells;

reload _mortar;


if (isPlayer _user) then {
    _veh enableSimulation true;
    format ["Loaded %1 mortar shells", _count] call OT_fnc_notifyMinor;
} else {
    _user globalChat format ["Loaded %1 mortar shells", _count];
};

diag_log format ["MORTAR DEBUG - Mortar Ammo After: %1", magazinesAmmo _mortar];
