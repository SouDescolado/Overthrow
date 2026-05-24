private _mortar = vehicle player;
private _shells = [];

private _allMags = magazines player;

diag_log format ["MORTAR DEBUG - Artillery Ammo: %1", getArtilleryAmmo [_mortar]];
diag_log format ["MORTAR DEBUG - Player Magazines: %1", _allMags];

{
    if (_x in (getArtilleryAmmo [_mortar])) then {
        _shells pushBack _x;
    };
} forEach _allMags;

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
    diag_log format ["MORTAR DEBUG - Adding shell: %1", _x];

    _mortar addMagazine [_x, 1];

    player removeMagazine _x;

} forEach _shells;

reload _mortar;

disableUserInput false;

format ["Loaded %1 mortar shells", _count] call OT_fnc_notifyMinor;

diag_log format ["MORTAR DEBUG - Mortar magazines after load: %1", magazinesAmmo _mortar];
