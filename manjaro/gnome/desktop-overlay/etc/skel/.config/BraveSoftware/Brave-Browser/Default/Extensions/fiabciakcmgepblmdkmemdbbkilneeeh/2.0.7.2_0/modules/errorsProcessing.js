let trackError = async (error) => { };
let trackView = async (viewName, info) => { };
function trackErrors(pageName /* For example 'popup' */, buttons /* true/false */) {
    const tsErrorGaKey = 'ts_error';
    const sendErrorsKey = 'sendErrors';
    const extensionRootPath = chrome.runtime.getURL('');
    const eventsAccumulator = [];
    trackError = async function (error) {
        void chrome.runtime.sendMessage({
            method: '[TS:offscreenDocument:sendError]',
            type: 'error',
            error: {
                message: `${pageName}: ${error.message}`,
                stack: error.stack.replaceAll(extensionRootPath, ""),
            },
        });
    };
    trackView = async function (viewName, info) {
        void chrome.runtime.sendMessage({
            method: '[TS:offscreenDocument:sendError]',
            type: 'event',
            event: {
                message: viewName,
                ...info,
            },
        });
    };
}
if (typeof module != 'undefined')
    module.exports = {
        trackErrors,
        trackError,
        trackView,
    };
//# sourceMappingURL=errorsProcessing.js.map