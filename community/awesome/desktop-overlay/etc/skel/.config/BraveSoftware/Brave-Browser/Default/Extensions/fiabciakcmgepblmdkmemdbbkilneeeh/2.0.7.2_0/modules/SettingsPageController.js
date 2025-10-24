// eslint-disable-next-line @typescript-eslint/no-unused-vars
class SettingsPageController {
    settingsPage = chrome.runtime.getURL(chrome.runtime.getManifest().options_page);
    reloadSettingsPage() {
        chrome.runtime.getContexts({ documentUrls: [this.settingsPage] }, (contexts) => {
            for (let i = 0; i <= contexts.length; i++) {
                if (contexts[i]) {
                    chrome.tabs.reload(contexts[i].tabId, {}).catch(console.error);
                }
            }
        });
    }
    static openSettings() {
        const manifest = chrome.runtime.getManifest();
        focusOrOpenTSPage(manifest.options_page);
    }
    /**
     *
     */
    static async reloadSettings(options) {
        /* STORE TABS STATE */
        tabObserver.settingsChanged();
        await preInit({ reloadSettings: true });
        if (!options || !options.fromSettingsPage)
            settingsPageController.reloadSettingsPage();
        chrome.runtime.sendMessage({
            method: '[AutomaticTabCleaner:UpdateTabsSettings]',
            restoreEvent: await getRestoreEvent(),
            reloadTabOnRestore: await getReloadTabOnRestore(),
            parkBgColor: await getParkBgColor(),
            screenshotCssStyle: await getScreenshotCssStyle(),
            restoreButtonView: await getRestoreButtonView(),
            tabIconOpacityChange: await getTabIconOpacityChange(),
            tabIconStatusVisualize: await getTabIconStatusVisualize(),
            screenshotsEnabled: await settings.get('screenshotsEnabled')
        }).catch(console.error);
    }
}
//# sourceMappingURL=SettingsPageController.js.map