# Installation

1. Add the Plugin to the Cordova Project:
```sh
cordova plugin add https://github.com/MyFiziqApp/cordova-plugin-cognito-userpool.git
```
1. Add the iOS platform to the Cordova Project:
```sh
cordova platform add ios
```

When the ios platform add command is run, the Cocoapods and dependencies will be downloaded and integrated into the Cordova Project.

## Use example

In the Cordova App project, edit `www/js/index.js` and implement the following:

```js
var app = {
    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },
    // deviceready Event Handler
    onDeviceReady: function() {
        var success = function() {
            alert("IDP setup success");
            app.receivedEvent('deviceready');
        }
        var failure = function(msg) {
            alert("IDP setup failed");
            app.receivedEvent('deviceready');
        }
        idp.idpSetup('REGION', 'USER POOL ID', 'CLIENT ID', success, failure);
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    }
};

app.initialize();

$('#btn-login').click(function(){
    var success = function() {
        alert("Login success");
        var successKey = function(key) {
            alert(key);
        }
        var failureKey = function(msg) {
            alert(msg);
        }
        idp.idpUserToken(successKey, failureKey);
    }
    var failure = function(msg) {
        alert(msg);
    }
    idp.idpUserLogin($('#usr-email').val(), $('#usr-pass').val(), success, failure);
});
```

Where: **REGION**, **USER POOL ID**, and **CLIENT ID** are the AWS Cognito User Pool configuration details.

**NOTE:** The example code uses JQuery to handle login button click.

## Author

MyFiziq iOS Dev, dev@myfiziq.com

## License

ISC
