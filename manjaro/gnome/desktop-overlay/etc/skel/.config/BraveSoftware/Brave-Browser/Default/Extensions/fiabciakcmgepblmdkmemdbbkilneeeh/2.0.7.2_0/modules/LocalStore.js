var LocalStoreKeys;
(function (LocalStoreKeys) {
    LocalStoreKeys["INSTALLED"] = "installed";
    LocalStoreKeys["PARK_HISTORY"] = "parkHistory";
    LocalStoreKeys["CLOSE_HISTORY"] = "closeHistory";
})(LocalStoreKeys || (LocalStoreKeys = {}));
// eslint-disable-next-line @typescript-eslint/no-unused-vars
class LocalStore {
    static keys = Object.fromEntries(Object.values(LocalStoreKeys).map(name => [name, true]));
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    static async get(key) {
        this.checkKey(key);
        return (await chrome.storage.local.get([key]))[key];
    }
    static set(key, value) {
        this.checkKey(key);
        return chrome.storage.local.set({ [key]: value });
    }
    static remove(key) {
        this.checkKey(key);
        return chrome.storage.local.remove(key);
    }
    static checkKey(key) {
        if (!LocalStore.keys[key]) {
            console.error(`Key[${key}] is not supported by LocalStore`);
        }
    }
}
//# sourceMappingURL=LocalStore.js.map