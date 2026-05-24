private _mortar = vehicle player;
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
} forEach magazines player;

diag_log format ["MORTAR DEBUG - Found Shells: %1", _shells];

private _count = count _shells;
private _time = _count * 7;

if (_count <= 0) exitWith {
    "No mortar ammo found" call OT_fnc_notifyMinor;
};

format ["Loading %1 mortar shells...", _count] call OT_fnc_notifyMinor;

disableUserInput true;

[_time, false] call OT_fnc_progressBar;

sleep _time;

{
    _mortar addMagazineTurret [_x, [0]];
    player removeMagazine _x;

    diag_log format ["MORTAR DEBUG - Loaded shell: %1", _x];

} forEach _shells;

reload _mortar;

disableUserInput false;

format ["Loaded %1 mortar shells", _count] call OT_fnc_notifyMinor;

diag_log format ["MORTAR DEBUG - Mortar Ammo After: %1", magazinesAmmo _mortar];
