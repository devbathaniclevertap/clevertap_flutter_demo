const functions = require('firebase-functions');
const admin = require('firebase-admin');
const request = require('requestretry');

admin.initializeApp();

exports.sendAndroidUninstallToCleverTap = functions.analytics.event('app_remove').onLog((event) => {
    function myRetryStrategy(err, response) {
        return !!err || response.statusCode === 503;
    }

    const clevertapId = event.user.userProperties.ct_objectId.value;
    const data = JSON.stringify({
        "d": [{
            "objectId": clevertapId,
            "type": "event",
            "evtName": "App Uninstalled",
            "evtData": {}
        }]
    });

    return request({
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CleverTap-Account-Id': 'YOUR_CT_ACCOUNT_ID',
            'X-CleverTap-Passcode': 'YOUR_CT_PASSCODE',
        },
        body: data,
        url: 'https://api.clevertap.com/firebase/upload',
        maxAttempts: 5,
        retryDelay: 2000,
        retryStrategy: myRetryStrategy
    }).then(response => {
        if (response.statusCode === 200) {
            console.log("Success:", JSON.stringify(response.body));
            return null;
        }
        throw new Error(`Failed with status ${response.statusCode}`);
    }).catch(error => {
        console.error("Error:", error);
        throw error;
    });
});
