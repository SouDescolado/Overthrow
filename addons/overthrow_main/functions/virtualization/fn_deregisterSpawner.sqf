_found = false;
_idx = -1;
{
    _idx = _idx + 1;
    _id = _x select 0;
    if (_id isEqualTo _this) exitWith { _found = true };
} forEach (OT_allSpawners);
if (_found) then {
    OT_allSpawners deleteAt _idx;
};
