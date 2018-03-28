/*global cordova, module*/
var exec = require('cordova/exec');

module.exports = {
    idpSetup: function (region, userPoolId, clientId, success_cb, error_cb) {
        exec(success_cb, error_cb, 'MyFiziq', 'idpSetup', [key, secret, environment]);
    },
    idpIsUserSignedIn: function (success_cb, error_cb) {
        exec(success_cb, error_cb, 'MyFiziq', 'idpIsUserSignedIn', [key, secret, environment]);
    },
    idpValidateInput: function (email, passA, passB, success_cb, error_cb) {
        exec(success_cb, error_cb, 'MyFiziq', 'idpValidateInput', [key, secret, environment]);
    },
    idpUserLogin: function (email, pass, success_cb, error_cb) {
        exec(success_cb, error_cb, 'MyFiziq', 'idpUserLogin', [key, secret, environment]);
    },
    idpUserPasswordResetRequest: function (email, success_cb, error_cb) {
        exec(success_cb, error_cb, 'MyFiziq', 'idpUserPasswordResetRequest', [key, secret, environment]);
    },
    idpUserPasswordResetConfirm: function (email, resetCode, newPass, success_cb, error_cb) {
        exec(success_cb, error_cb, 'MyFiziq', 'idpUserPasswordResetConfirm', [key, secret, environment]);
    },
    idpUserLogout: function (success_cb, error_cb) {
        exec(success_cb, error_cb, 'MyFiziq', 'idpUserLogout', [key, secret, environment]);
    }
};
