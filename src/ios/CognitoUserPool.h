#import <Cordova/CDV.h>
#import "IdentityProviderHelper.h"

@interface CognitoUserPool : CDVPlugin

- (void)idpSetup:(CDVInvokedUrlCommand *)command;
- (void)idpIsUserSignedIn:(CDVInvokedUrlCommand *)command;
- (void)idpValidateInput:(CDVInvokedUrlCommand *)command;
- (void)idpUserLogin:(CDVInvokedUrlCommand *)command;
- (void)idpUserPasswordResetRequest:(CDVInvokedUrlCommand *)command;
- (void)idpUserPasswordResetConfirm:(CDVInvokedUrlCommand *)command;
- (void)idpUserLogout:(CDVInvokedUrlCommand *)command;
- (void)idpUserToken:(CDVInvokedUrlCommand *)command;

@end