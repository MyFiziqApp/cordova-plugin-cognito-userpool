var exec = require('cordova/exec');

module.exports = {
    /* MyFiziqSDK */
    idpSetup: function (success_cb, error_cb) {
        exec(success_cb, error_cb, 'MyFiziq', 'idpSetup', []);
    }
};
