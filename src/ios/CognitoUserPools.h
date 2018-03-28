#import <Cordova/CDV.h>
@import AWSCore;                    // NOTE: AWS service imports are required to authorize the user access.
@import AWSCognito;
@import AWSCognitoIdentityProvider;

@interface CognitoUserPools : CDVPlugin

- (void)idpSetup:(CDVInvokedUrlCommand *)command;
- (void)idpIsUserSignedIn:(CDVInvokedUrlCommand *)command;
- (void)idpValidateInput:(CDVInvokedUrlCommand *)command;
- (void)idpUserLogin:(CDVInvokedUrlCommand *)command;
- (void)idpUserPasswordResetRequest:(CDVInvokedUrlCommand *)command;
- (void)idpUserPasswordResetConfirm:(CDVInvokedUrlCommand *)command;
- (void)idpUserLogout:(CDVInvokedUrlCommand *)command;

@end