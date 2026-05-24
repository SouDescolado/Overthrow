private _mortar = vehicle player;
private _shells = [];
private _allItems = (
    magazines player +
    items player +
    backpackItems player +
    backpackMagazines player +
    vestItems player +
    vestMagazines player +
    uniformItems player +
    uniformMagazines player
);

diag_log format ["MORTAR DEBUG - Artillery Ammo: %1", getArtilleryAmmo [_mortar]];
diag_log format ["MORTAR DEBUG - Player All Items: %1", _allItems];

{
    if (_x in (getArtilleryAmmo [_mortar])) then {
        _shells pushBack _x;
    };
} forEach magazines player;

private _count = count _shells;
private _time = _count * 7;

if (_count <= 0) exitWith {
    "No mortar ammo found" call OT_fnc_notifyMinor;
};

format ["Loading %1 mortar shells...", _count] call OT_fnc_notifyMinor;

disableUserInput true;
[] spawn {
    sleep 10;
    disableUserInput false;
    //Fail safe for user input disabled.
};

[_time, false] call OT_fnc_progressBar;
private _end = time + _time;
waitUntil { time > _end };
{
    _mortar addMagazineTurret [_x, [0]];
    player removeMagazine _x;
} forEach _shells;

disableUserInput false;

format ["Loaded %1 mortar shells", _count] call OT_fnc_notifyMinor;
