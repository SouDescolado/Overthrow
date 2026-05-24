private _mortar = vehicle player;

private _allItems = (
    magazines player +
    backpackMagazines player +
    vestMagazines player +
    uniformMagazines player
);

private _shells = [];

diag_log format ["MORTAR DEBUG - Player All Items: %1", _allItems];

{
    if (_x find "ACE_1Rnd_82mm_Mo_" == 0) then {
        _shells pushBack _x;
    };
} forEach _allItems;

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
    switch (_x) do {

        case "ACE_1Rnd_82mm_Mo_HE": {
            _mortar addMagazine ["8Rnd_82mm_Mo_shells", [0]];
        };

        case "ACE_1Rnd_82mm_Mo_Smoke": {
            _mortar addMagazine ["8Rnd_82mm_Mo_Smoke_white", [0]];
        };

        case "ACE_1Rnd_82mm_Mo_Illum": {
            _mortar addMagazine ["8Rnd_82mm_Mo_Flare_white", [0]];
        };

        case "ACE_1Rnd_82mm_Mo_GUIDED": {
            _mortar addMagazine ["8Rnd_82mm_Mo_guided", [0]];
        };

        case "ACE_1Rnd_82mm_Mo_LG": {
            _mortar addMagazine ["8Rnd_82mm_Mo_LG", [0]];
        };
    };

    player removeMagazine _x;

} forEach _shells;

disableUserInput false;

format ["Loaded %1 mortar shells", _count] call OT_fnc_notifyMinor;
