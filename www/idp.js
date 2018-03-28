var exec = require('cordova/exec');

module.exports = {
    idpSetup: function (region, userPoolId, clientId, success_cb, error_cb) {
        exec(success_cb, error_cb, 'CognitoUserPool', 'idpSetup', [region, userPoolId, clientId]);
    },
    idpIsUserSignedIn: function (success_cb, error_cb) {
        exec(success_cb, error_cb, 'CognitoUserPool', 'idpIsUserSignedIn', []);
    },
    idpValidateInput: function (email, passA, passB, success_cb, error_cb) {
        exec(success_cb, error_cb, 'CognitoUserPool', 'idpValidateInput', [email, passA, passB]);
    },
    idpUserLogin: function (email, pass, success_cb, error_cb) {
        exec(success_cb, error_cb, 'CognitoUserPool', 'idpUserLogin', [email, pass]);
    },
    idpUserPasswordResetRequest: function (email, success_cb, error_cb) {
        exec(success_cb, error_cb, 'CognitoUserPool', 'idpUserPasswordResetRequest', [email]);
    },
    idpUserPasswordResetConfirm: function (email, resetCode, newPass, success_cb, error_cb) {
        exec(success_cb, error_cb, 'CognitoUserPool', 'idpUserPasswordResetConfirm', [email, resetCode, newPass]);
    },
    idpUserLogout: function (success_cb, error_cb) {
        exec(success_cb, error_cb, 'CognitoUserPool', 'idpUserLogout', []);
    },
    idpUserToken: function (success_cb, error_cb) {
        exec(success_cb, error_cb, 'CognitoUserPool', 'idpUserToken', []);
    }
};
