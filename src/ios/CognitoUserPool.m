#import "CognitoUserPool.h"

@interface CognitoUserPool()
@end

@implementation CognitoUserPool

#pragma mark Delegates

- (void)pluginInitialize {
}

/*
- key
- secret
- environment
- success_cb
- error_cb
 */
- (void)idpSetup:(CDVInvokedUrlCommand *)command {
    __block CDVPluginResult *pluginResult = nil;
    @try {
        // NSLog(@"MyFiziqSDK setup called");
        // NSString *key = [command.arguments objectAtIndex:0];
        // NSString *secret = [command.arguments objectAtIndex:1];
        // NSString *env = [command.arguments objectAtIndex:2];
        // // REQUIRED: Initiate the MyFiziq service with the App configuration.
        // self.m_config = @{ kMFZSetupKey:key,kMFZSetupSecret:secret, kMFZSetupEnvironment:env };
        // MyFiziqSDK *mfz = [MyFiziqSDK shared];
        // [mfz setupWithConfig:self.m_config
        //         authDelegate:self
        //              success:^(NSDictionary * _Nonnull status) {
        //                  NSLog(@"MyFiziqSDK setup success");
                         pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                         [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                    // } failure:^(NSError * _Nonnull error) {
                    //     NSLog(@"MyFiziqSDK setup failed");
                    //      pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.localizedDescription];
                    //      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                    // }];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

@end
