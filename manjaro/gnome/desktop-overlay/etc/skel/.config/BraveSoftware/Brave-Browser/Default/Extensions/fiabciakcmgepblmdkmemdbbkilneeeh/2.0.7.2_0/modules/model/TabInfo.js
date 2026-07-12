// eslint-disable-next-line @typescript-eslint/no-unused-vars
class TabInfo {
    _id;
    _oldRefId;
    _originRefId;
    _newRefId;
    _winId;
    _idx;
    _time;
    _suspended_time;
    _active_time;
    _swch_cnt;
    _parkTrys;
    _lstCapUrl;
    _v;
    _suspendPercent;
    _discarded;
    _markedForDiscard;
    _parkedCount;
    _nonCmpltInput;
    _refreshIconRetries;
    _zoomFactor;
    // Dynamic fields
    _closed;
    _parked;
    _parkedUrl;
    _lstCapTime;
    _lstSwchTime;
    _missingCheckTime;
    constructor(tab) {
        this._id = tab.id;
        this._winId = tab.windowId;
        this._idx = tab.index;
        this._lstCapUrl = tab.url;
        this._discarded = tab.discarded;
        this._time = 0;
        this._suspended_time = 0;
        this._active_time = 0;
        this._swch_cnt = 0;
        this._parkTrys = 0;
        this._v = 2;
        this._suspendPercent = 0;
        this._markedForDiscard = false;
        this._parkedCount = 0;
        this._nonCmpltInput = false;
        this._refreshIconRetries = 0;
        // Dynamic fields
        this._parked = null;
        this._parkedUrl = null;
        this._lstCapTime = null;
        this._lstSwchTime = null;
        this._missingCheckTime = null;
    }
    toObject() {
        // eslint-disable-next-line @typescript-eslint/no-this-alias
        const self = this;
        const object = {};
        Object.getOwnPropertyNames(this).forEach(function (propName) {
            if (propName.startsWith('_')) {
                object[propName.substring(1)] = self[propName];
            }
        });
        return object;
    }
    static fromObject(iTabInfo) {
        const tabInfo = new TabInfo({});
        Object.getOwnPropertyNames(iTabInfo).forEach(function (propName) {
            tabInfo[propName] = iTabInfo[propName];
        });
        return tabInfo;
    }
    get id() {
        return this._id;
    }
    set id(value) {
        this._id = value;
    }
    get oldRefId() {
        return this._oldRefId;
    }
    set oldRefId(value) {
        this._oldRefId = value;
    }
    get originRefId() {
        return this._originRefId;
    }
    set originRefId(value) {
        this._originRefId = value;
    }
    get newRefId() {
        return this._newRefId;
    }
    set newRefId(value) {
        this._newRefId = value;
    }
    get winId() {
        return this._winId;
    }
    set winId(value) {
        this._winId = value;
    }
    get idx() {
        return this._idx;
    }
    set idx(value) {
        this._idx = value;
    }
    get time() {
        return this._time;
    }
    set time(value) {
        this._time = value;
    }
    get suspended_time() {
        return this._suspended_time;
    }
    set suspended_time(value) {
        this._suspended_time = value;
    }
    get active_time() {
        return this._active_time;
    }
    set active_time(value) {
        this._active_time = value;
    }
    get swch_cnt() {
        return this._swch_cnt;
    }
    set swch_cnt(value) {
        this._swch_cnt = value;
    }
    get parkTrys() {
        return this._parkTrys;
    }
    set parkTrys(value) {
        this._parkTrys = value;
    }
    get lstCapUrl() {
        return this._lstCapUrl;
    }
    set lstCapUrl(value) {
        this._lstCapUrl = value;
    }
    get v() {
        return this._v;
    }
    set v(value) {
        this._v = value;
    }
    get suspendPercent() {
        return this._suspendPercent;
    }
    set suspendPercent(value) {
        this._suspendPercent = value;
    }
    get discarded() {
        return this._discarded;
    }
    set discarded(value) {
        this._discarded = value;
    }
    get markedForDiscard() {
        return this._markedForDiscard;
    }
    set markedForDiscard(value) {
        this._markedForDiscard = value;
    }
    get parkedCount() {
        return this._parkedCount;
    }
    set parkedCount(value) {
        this._parkedCount = value;
    }
    get nonCmpltInput() {
        return this._nonCmpltInput;
    }
    set nonCmpltInput(value) {
        this._nonCmpltInput = value;
    }
    get refreshIconRetries() {
        return this._refreshIconRetries;
    }
    set refreshIconRetries(value) {
        this._refreshIconRetries = value;
    }
    get parked() {
        return this._parked;
    }
    set parked(value) {
        this._parked = value;
    }
    get parkedUrl() {
        return this._parkedUrl;
    }
    set parkedUrl(value) {
        this._parkedUrl = value;
    }
    get lstCapTime() {
        return this._lstCapTime;
    }
    set lstCapTime(value) {
        this._lstCapTime = value;
    }
    get lstSwchTime() {
        return this._lstSwchTime;
    }
    set lstSwchTime(value) {
        this._lstSwchTime = value;
    }
    get zoomFactor() {
        return this._zoomFactor;
    }
    set zoomFactor(value) {
        this._zoomFactor = value;
    }
    get closed() {
        return this._closed;
    }
    set closed(value) {
        this._closed = value;
    }
    get missingCheckTime() {
        return this._missingCheckTime;
    }
    set missingCheckTime(value) {
        this._missingCheckTime = value;
    }
}
if (typeof module != 'undefined')
    module.exports = {
        TabInfo,
    };
//# sourceMappingURL=TabInfo.js.map