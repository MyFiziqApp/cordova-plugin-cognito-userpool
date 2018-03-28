#import <Cordova/CDV.h>

@interface CognitoUserPool : CDVPlugin

- (void)idpSetup:(CDVInvokedUrlCommand *)command;

@end