#import "CognitoUserPools.h"
#import "IdentityProviderHelper.h"

@interface CognitoUserPools()
@end

@implementation CognitoUserPools

#pragma mark Delegates

- (void)pluginInitialize {
}

/*
- region
- userPoolId
- clientId
- success_cb
- error_cb
 */
- (void)idpSetup:(CDVInvokedUrlCommand *)command {
    __block CDVPluginResult *pluginResult = nil;
    @try {
        NSLog(@"Cognito UserPools plugin setup called");
        NSString *region = [command.arguments objectAtIndex:0];
        NSString *userPoolId = [command.arguments objectAtIndex:1];
        NSString *clientId = [command.arguments objectAtIndex:2];
        // Initiate the IDP
        IdentityProviderHelper *idp = [IdentityProviderHelper shared];
        idp.cognitoUserPoolRegion = region;
        idp.cognitoUserPoolId = userPoolId;
        idp.clientId = clientId;
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

/*
@property idpIsUserSignedIn
 */
- (void)idpIsUserSignedIn:(CDVInvokedUrlCommand *)command {
    __block CDVPluginResult *pluginResult = nil;
    @try {
        IdentityProviderHelper *idp = [IdentityProviderHelper shared];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:idp.userIsSignedIn];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

/*
- email
- passA
- passB
- success_cb
- error_cb
 */
- (void)idpValidateInput:(CDVInvokedUrlCommand *)command {
    __block CDVPluginResult *pluginResult = nil;
    @try {
        NSString *email = [command.arguments objectAtIndex:0];
        NSString *passA = [command.arguments objectAtIndex:1];
        NSString *passB = [command.arguments objectAtIndex:2];
        IdentityProviderHelper *idp = [IdentityProviderHelper shared];
        kAuthValidation res = [idp validateEmail:email passwordA:passA passwordB:passB];
        if (res == kAuthValidationIsValid) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

/*
- email
- pass
- success_cb
- error_cb
 */
- (void)idpUserLogin:(CDVInvokedUrlCommand *)command {
    __block CDVPluginResult *pluginResult = nil;
    @try {
        NSString *email = [command.arguments objectAtIndex:0];
        NSString *pass = [command.arguments objectAtIndex:1];
        IdentityProviderHelper *idp = [IdentityProviderHelper shared];
        [idp userLoginWithEmail:email password:pass completion:^(NSError *error) {
            if (error) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

/*
- email
- success_cb
- error_cb
 */
- (void)idpUserPasswordResetRequest:(CDVInvokedUrlCommand *)command {
    __block CDVPluginResult *pluginResult = nil;
    @try {
        NSString *email = [command.arguments objectAtIndex:0];
        IdentityProviderHelper *idp = [IdentityProviderHelper shared];
        [idp userPasswordResetRequestWithEmail:email completion:^(NSError *error) {
            if (error) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

/*
- email
- resetCode
- newPass
- success_cb
- error_cb
 */
- (void)idpUserPasswordResetConfirm:(CDVInvokedUrlCommand *)command {
    __block CDVPluginResult *pluginResult = nil;
    @try {
        NSString *email = [command.arguments objectAtIndex:0];
        NSString *resetCode = [command.arguments objectAtIndex:1];
        NSString *newPass = [command.arguments objectAtIndex:2];
        IdentityProviderHelper *idp = [IdentityProviderHelper shared];
        [idp userPasswordResetConfirmWithEmail:email resetCode:resetCode newPassword:newPass completion:^(NSError *error) {
            if (error) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

/*
- success_cb
- error_cb
 */
- (void)idpUserLogout:(CDVInvokedUrlCommand *)command {
    __block CDVPluginResult *pluginResult = nil;
    @try {
        IdentityProviderHelper *idp = [IdentityProviderHelper shared];
        [idp userLogoutWithCompletion:^(NSError *error) {
            if (error) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

@end
