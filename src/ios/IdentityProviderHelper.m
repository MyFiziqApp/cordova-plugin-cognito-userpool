//
//  Copyright (c) 2018 MyFiziq. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "IdentityProviderHelper.h"
@import SHEmailValidator;

#define MIN_PASSWORD_LENGTH     6
#define MAX_AUTH_TIMEOUT_SEC    60

@interface IdentityProviderHelper()
@end


@implementation IdentityProviderHelper

#pragma mark Property methods

/*
 Lazily instantiated properties for the AWS services.
 */

- (AWSServiceConfiguration *)awsServiceConfiguration {
    if (!_awsServiceConfiguration) {
        _awsServiceConfiguration = [[AWSServiceConfiguration alloc] initWithRegion:[self.cognitoUserPoolRegion aws_regionTypeValue]
                                                               credentialsProvider:nil];
    }
    return _awsServiceConfiguration;
}

- (AWSCognitoIdentityUserPoolConfiguration *)awsUserPoolConfig {
    if (!_awsUserPoolConfig) {
        _awsUserPoolConfig = [[AWSCognitoIdentityUserPoolConfiguration alloc] initWithClientId:self.clientId
                                                                                  clientSecret:nil
                                                                                        poolId:self.cognitoUserPoolId];
    }
    return _awsUserPoolConfig;
}

- (AWSCognitoIdentityUserPool *)awsUserPool {
    if (!_awsUserPool) {
        [AWSCognitoIdentityUserPool registerCognitoIdentityUserPoolWithConfiguration:self.awsServiceConfiguration
                                                               userPoolConfiguration:self.awsUserPoolConfig
                                                                              forKey:@APP_NAME];
        _awsUserPool = [AWSCognitoIdentityUserPool CognitoIdentityUserPoolForKey:@APP_NAME];
    }
    return _awsUserPool;
}

- (AWSCognitoIdentityUser *)currentUser {
    return [self.awsUserPool currentUser];
}

#pragma mark Methods

+ (instancetype)shared {
    static IdentityProviderHelper *idp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        idp = [[IdentityProviderHelper alloc] init];
    });
    return idp;
}

#pragma mark User authentication methods

/*
 NOTE: The following methods are for AWS Cognito User Pool construction and usage. You can find more information on the \
 AWS Cognito Mobile SDK from this site: http://docs.aws.amazon.com/cognito/latest/developerguide/tutorial-integrating-user-pools-ios.html .
 */

- (BOOL)userIsSignedIn {
    return (self.currentUser && self.currentUser.username && ![self.currentUser.username isEqualToString:@""] && self.currentUser.isSignedIn);
}

/*
 NOTE: This method check if the data entered into the fields are valid. Return if user authentication can proceed.
 */
- (kAuthValidation)validateEmail:(NSString *)email passwordA:(NSString *)passA passwordB:(NSString *)passB {
    // NOTE: Validate email.
    if (!email || [email isEqualToString:@""]) {
        return kAuthValidationNoEmail;
    }
    NSError *error;
    [[SHEmailValidator validator] validateSyntaxOfEmailAddress:email withError:&error];
    if (error) {
        return kAuthValidationInvalidEmail;
    }
    // NOTE: Validate password.
    if (!passA || !passB || [passA isEqualToString:@""] || [passB isEqualToString:@""]) {
        return kAuthValidationNoPassword;
    }
    if (passA.length < MIN_PASSWORD_LENGTH) {
        return kAuthValidationPasswordTooShort;
    }
    if (![passA isEqualToString:passB]) {
        return kAuthValidationPasswordsNotEqual;
    }
    // NOTE: Inputs did not return as invalid, so return as valid.
    return kAuthValidationIsValid;
}

/*
 NOTE: Attempts to authenticate the user with the AWS Cognito User Pool idP service.
 */
- (void)userLoginWithEmail:(NSString *)email password:(NSString *)pass completion:(void (^)(NSError *err))completion {
    // NOTE: Make sure parameters are valid.
    kAuthValidation validation = [self validateEmail:email passwordA:pass passwordB:pass];
    if (validation != kAuthValidationIsValid) {
        NSLog(@"ERROR: Parameters are invalid for user login. Check with -validateEmail:passwordA:passwordB method first.");
        if (completion) {
            completion([NSError errorWithDomain:@"com.myfiziq" code:-4 userInfo:nil]);
        }
        return;
    }
    // NOTE: Attempt user authentication.
    AWSCognitoIdentityUser *user = [self.awsUserPool getUser:email];
    if (user) {
        __block BOOL didRespond = NO;
        AWSCancellationTokenSource *cancellationTokenSource = [AWSCancellationTokenSource cancellationTokenSource];
        [[user getSession:email password:pass validationData:nil] continueWithBlock:^id _Nullable(AWSTask<AWSCognitoIdentityUserSession *> * _Nonnull t) {
            if (t.error) {
                NSLog(@"ERROR: Failed to authenticate the user.");
                didRespond = YES;
                if (completion) {
                    completion(t.error);
                }
            } else {
                NSLog(@"Successfully authenticated the user.");
                didRespond = YES;
                if (completion) {
                    completion(error);
                }
            }
            return nil;
        } cancellationToken:cancellationTokenSource.token];
        // NOTE: Incase the service does not timeout in a timely manner, the authentication attempt should be cancelled
        // after a certain timeout period has elapsed.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MAX_AUTH_TIMEOUT_SEC * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!didRespond && completion) {
                NSLog(@"ERROR: Authentication of user timed out.");
                completion([NSError errorWithDomain:@"com.myfiziq" code:-3 userInfo:nil]);
            }
        });
    } else {
        // NOTE: This example uses the NSError parameter to flag that the authentication failed.
        NSLog(@"ERROR: User not found.");
        if (completion) {
            completion([NSError errorWithDomain:@"com.myfiziq" code:-2 userInfo:nil]);
        }
    }
}

/*
 OPTIONAL: AWS Cognito User Pool service will handle the generation and send of the registered user's password reset code.
 */
- (void)userPasswordResetRequestWithEmail:(NSString *)email completion:(void (^)(NSError *))completion {
    // NOTE: Make sure parameters are valid.
    kAuthValidation validation = [self validateEmail:email passwordA:@"dummy_password" passwordB:@"dummy_password"];
    if (validation != kAuthValidationIsValid) {
        NSLog(@"ERROR: Parameters are invalid for user password reset. Check with -validateEmail:passwordA:passwordB method first.");
        if (completion) {
            completion([NSError errorWithDomain:@"com.myfiziq" code:-4 userInfo:nil]);
        }
        return;
    }
    // NOTE: Attempt user authentication.
    AWSCognitoIdentityUser *user = [self.awsUserPool getUser:email];
    if (user) {
        __block BOOL didRespond = NO;
        AWSCancellationTokenSource *cancellationTokenSource = [AWSCancellationTokenSource cancellationTokenSource];
        [[user forgotPassword] continueWithBlock:^id _Nullable(AWSTask<AWSCognitoIdentityUserForgotPasswordResponse *> * _Nonnull t) {
            if (t.error) {
                NSLog(@"ERROR: Failed to send reset password code to the user.");
                if (completion) {
                    completion(t.error);
                }
            } else {
                NSLog(@"Successfully sent reset password code to the user.");
                if (completion) {
                    completion(nil);
                }
            }
            didRespond = YES;
            return nil;
        } cancellationToken:cancellationTokenSource.token];
        // NOTE: Incase the service does not timeout in a timely manner, the authentication attempt should be cancelled
        // after a certain timeout period has elapsed.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MAX_AUTH_TIMEOUT_SEC * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!didRespond && completion) {
                NSLog(@"ERROR: Submit of password reset code timed out.");
                completion([NSError errorWithDomain:@"com.myfiziq" code:-3 userInfo:nil]);
            }
        });
    } else {
        // NOTE: This example uses the NSError parameter to flag that the authentication failed.
        NSLog(@"ERROR: User not found.");
        if (completion) {
            completion([NSError errorWithDomain:@"com.myfiziq" code:-2 userInfo:nil]);
        }
    }
}

/*
 OPTIONAL: To reset the user password, the user must answer
 */
- (void)userPasswordResetConfirmWithEmail:(NSString *)email resetCode:(NSString *)code newPassword:(NSString *)pass completion:(void (^)(NSError *))completion {
    // NOTE: Make sure parameters are valid.
    kAuthValidation validation = [self validateEmail:email passwordA:pass passwordB:pass];
    if (validation != kAuthValidationIsValid || !code || [code isEqualToString:@""]) {
        NSLog(@"ERROR: Parameters are invalid for user password reset. Check with -validateEmail:passwordA:passwordB method first.");
        if (completion) {
            completion([NSError errorWithDomain:@"com.myfiziq" code:-4 userInfo:nil]);
        }
        return;
    }
    // NOTE: Attempt user password reset.
    AWSCognitoIdentityUser *user = [self.awsUserPool getUser:email];
    if (user) {
        __block BOOL didRespond = NO;
        AWSCancellationTokenSource *cancellationTokenSource = [AWSCancellationTokenSource cancellationTokenSource];
        [[user confirmForgotPassword:code password:pass] continueWithBlock:^id _Nullable(AWSTask<AWSCognitoIdentityUserConfirmForgotPasswordResponse *> * _Nonnull t) {
            if (t.error) {
                NSLog(@"ERROR: Failed to reset user password.");
                didRespond = YES;
                if (completion) {
                    completion(t.error);
                }
            } else {
                NSLog(@"Successfully reset user password.");
                // NOTE: Login the new user using the new password.
                [self userLoginWithEmail:email password:pass completion:^(NSError *loginErr) {
                    didRespond = YES;
                    if (completion) {
                        completion(nil);
                    }
                }];
            }
            return nil;
        } cancellationToken:cancellationTokenSource.token];
        // NOTE: Incase the service does not timeout in a timely manner, the authentication attempt should be cancelled
        // after a certain timeout period has elapsed.
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MAX_AUTH_TIMEOUT_SEC * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!didRespond && completion) {
                NSLog(@"ERROR: Password reset timed out.");
                completion([NSError errorWithDomain:@"com.myfiziq" code:-3 userInfo:nil]);
            }
        });
    } else {
        // NOTE: This example uses the NSError parameter to flag that the authentication failed.
        NSLog(@"ERROR: User not found.");
        if (completion) {
            completion([NSError errorWithDomain:@"com.myfiziq" code:-2 userInfo:nil]);
        }
    }
}

- (AWSTask *)userReauthenticate {
    if ([self userIsSignedIn]) {
        return [self.currentUser getSession];
    } else {
        // NOTE: Error to signify that there is no existing user session.
        return [AWSTask taskWithError:[NSError errorWithDomain:@"com.myfiziq" code:-1 userInfo:nil]];
    }
}

- (void)userLogoutWithCompletion:(void (^)(NSError *))completion {
    // NOTE: Check if there is a user to logout.
    if (self.userIsSignedIn) {
        [self.currentUser signOutAndClearLastKnownUser];
        if (completion) {
            completion(err);
        }
    } else if (completion) {
        // NOTE: To signify that there were no user session to logout of.
        completion([NSError errorWithDomain:@"com.myfiziq" code:2 userInfo:nil]);
    }
}

@end

