params ["_qty"];

private _queue = server getVariable ["factoryQueue", []];
private _idx = lbCurSel 1500;
if (_idx isEqualTo -1) exitWith {};

private _cls = lbData [1500, _idx];

private _queueitem = [_cls, 0];
private _doadd = true;

if (_queue isNotEqualTo []) then {
    private _i = _queue select -1;
    if ((_i select 0) isEqualTo _cls) then {
        _queueitem = _i;
        _doadd = false;
    };
} else {
    if ((server getVariable ["GEURproducing", ""]) isEqualTo "") then {
        server setVariable ["GEURproducing", _cls, true];
    };
};

_queueitem set [1, (_queueitem select 1) + _qty];

if (_doadd) then {
    _queue pushBack _queueitem;
};

server setVariable ["factoryQueue", _queue, true];

[] call OT_fnc_factoryRefresh;
