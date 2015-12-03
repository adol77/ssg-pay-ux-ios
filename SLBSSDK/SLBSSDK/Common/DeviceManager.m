//
//  DeviceManager.m
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceManager.h"
#import "AESExtention.h"
#import "DeviceNet.h"
#import "SLBSKit.h"
#import "TSDebugLogManager.h"
#import "LogManager.h"
#import "ZoneNet.h"

@import UIKit;

//#define TEST_CODE 1

@implementation DeviceManager : NSObject



+ (DeviceManager*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static DeviceManager *sharedDeviceManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedDeviceManager = [[DeviceManager alloc] init];
    });
    return sharedDeviceManager;
}


- (void) initData {
    TSGLog(TSLogGroupDevice, @"initData");
    
    NSString* otp = [self generateOTP];
    if( [self deviceID] == nil ) {
        if([self accessToken] == nil) {
            NSDictionary* deviceInfo = [self createDeviceProfile];
            //1. Auth
            [DeviceNet requestAuthWithOTP:otp deviceInfo:deviceInfo block:^(DeviceNet* net) {
                if(net.accessToken) {
                    //임시 AccessToken, expire time 5분
                    [self setAccessToken:net.accessToken];
                    
                    //2. DeviceID
                    [DeviceNet requestDeviceIDWithAccessToken:[self accessToken] deviceInfo:deviceInfo block:^(DeviceNet* net) {
                        if(net.deviceID) {
                            [self setDeviceID:net.deviceID];
                            [self saveDeviceIDLogWithType:SLBSLogEventAdd];
                            //3. ReAuth
                            //DeviceID와 함께 Auth시 expire time 1시간
                            [DeviceNet requestReAuthWithOTP:otp deviceInfo:deviceInfo deviceID:self.deviceID block:^(DeviceNet* net) {
                                if(net.accessToken) {
                                    [self setAccessToken:net.accessToken];
                                    
                                    [ZoneNet requestZoneListWithAccessToken:net.accessToken block:^(ZoneNet* net){
                                        if(net.returnCode == 0) {
                                            NSLog(@"%s requestZoneListWithBlock success", __PRETTY_FUNCTION__);
                                    
                                            [[SLBSKit sharedInstance] setHasAlreadyAccessToken:YES];
                                            [[SLBSKit sharedInstance] readyToAccessToken];
                                            [[SLBSKit sharedInstance] startService:SLBSServiceData];
                                        }
                                        else {
                                            [self setAccessToken:nil];
                                            [self setDeviceID:nil];
                                        }
                                    }];
                                }
                                else {
                                    [self setAccessToken:nil];
                                    [self setDeviceID:nil];
                                }
                            }];
                        }
                        else {
                            [self setAccessToken:nil];
                        }
                    }];
                }
                else {
                    //accessToken 저장
                }
            }];
          
        //4. App Tracking - Install
        [self saveAppTrackerLogWithType:SLBSLogEventAdd];
        
        }
    }
    else { //DeviceID 존재하는 경우
        NSDictionary* deviceInfo = [self createDeviceProfile];
        [DeviceNet requestReAuthWithOTP:otp deviceInfo:deviceInfo deviceID:self.deviceID block:^(DeviceNet* net) {
            if(net.accessToken) {
                [self setAccessToken:net.accessToken];
                
                [ZoneNet requestZoneListWithAccessToken:net.accessToken block:^(ZoneNet* net){
                    if(net.returnCode == 0) {
                        NSLog(@"%s requestZoneListWithBlock success", __PRETTY_FUNCTION__);
                        
                        [[SLBSKit sharedInstance] setHasAlreadyAccessToken:YES];
                        [[SLBSKit sharedInstance] readyToAccessToken];
                        [[SLBSKit sharedInstance] startService:SLBSServiceData];
                    }
                }];

            }
        }];

    }

}

- (NSString*)generateOTP
{
    NSDateFormatter* today = [[NSDateFormatter alloc] init];
    [today setDateFormat:@"dd'--'MM'--'yyyy':':HH"];
    
    NSString* currentDate = [today stringFromDate:[NSDate date]];

    NSLog(@"%s generateOTP %@", __PRETTY_FUNCTION__, currentDate);
    
    AESExtention *aes = [[AESExtention alloc] init];
    NSString *otp = [NSString stringWithFormat:@"%@", [aes aesEncryptString:currentDate useKey:NO]];
    
    TSGLog(TSLogGroupDevice, @"generateOTP %@", otp);
    
    return otp;
}


- (NSDictionary*)createDeviceProfile
{
    //iOS OS Build Number가 없음.
    //OS Version 변경시 Device ID 변경 요건 가능한지 확인 필요.
    NSDictionary* deviceProfile = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"iOS", @"os",
                                   [UIDevice currentDevice].systemVersion,  @"os_version",
                                   [UIDevice currentDevice].model, @"model",
                                   nil];
    
    NSLog(@"%s createDeviceProfile %@", __PRETTY_FUNCTION__, deviceProfile);
    TSGLog(TSLogGroupDevice, @"createDeviceProfile %@", deviceProfile);
    
    return deviceProfile;
}


- (void)requestReAuthToServerWithBlock:(void (^)(BOOL))block {
    TSGLog(TSLogGroupDevice, @"requestReAuthToServerWithBlock");
    
    NSString* otp = [self generateOTP];
    NSDictionary* deviceInfo = [self createDeviceProfile];
    [DeviceNet requestReAuthWithOTP:otp deviceInfo:deviceInfo deviceID:self.deviceID block:^(DeviceNet* net) {
        if(net.accessToken) {
            [self setAccessToken:net.accessToken];
        }
    }];
}


- (void) setAccessToken:(NSString*)accessToken {
    if(accessToken) {
        TSGLog(TSLogGroupDevice, @"setAceessToken %@", accessToken);
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"access_token"];
    }
    else
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
        
}


- (NSString*)accessToken {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"access_token"];
}


- (void)setDeviceID:(NSString *)deviceID {
    if(deviceID) {
        TSGLog(TSLogGroupDevice, @"setDeviceID %@", deviceID);
        NSLog(@"setDeviceID %@", deviceID);
        
        AESExtention *aes = [[AESExtention alloc] init];
        NSString *encryptDeviceID = [NSString stringWithFormat:@"%@", [aes aesEncryptString:deviceID useKey:YES]];

        NSLog(@"set EncryptDeviceID %@", encryptDeviceID);
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"device_id"];
        [[NSUserDefaults standardUserDefaults] setObject:encryptDeviceID forKey:@"device_id"];
    }
    else
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"device_id"];
    
}


- (NSString*)deviceID {
    NSString* orgDeviceID = [[NSUserDefaults standardUserDefaults] stringForKey:@"device_id"];
    
    if(orgDeviceID == nil)
        return nil;
     NSLog(@"getDeviceID %@", orgDeviceID);
    AESExtention *aes = [[AESExtention alloc] init];
    NSString *decryptDeviceID = [NSString stringWithFormat:@"%@", [aes aesDecryptString:orgDeviceID useKey:YES]];
    
    NSLog(@"get decryptDeviceID %@", decryptDeviceID);
    //return [[NSUserDefaults standardUserDefaults] stringForKey:@"device_id"];
    return decryptDeviceID;
}

-(NSString*)appID {
    return [[NSBundle mainBundle] bundleIdentifier];
}

- (void)saveDeviceIDLogWithType:(SLBSLogEventType)type {
    NSString* deviceID = [self deviceID];
    NSString* appID = [self appID];
    
    [[LogManager sharedInstance] saveLogWithDeviceID:deviceID appID:appID eventType:[NSNumber numberWithInteger:type] logType:[NSNumber numberWithInteger:SLBSLogDeviceID]];
}

- (void)saveAppTrackerLogWithType:(SLBSLogEventType)type {
    NSString* deviceID = [self deviceID];
    NSString* appID = [[NSBundle mainBundle] bundleIdentifier];
    
    [[LogManager sharedInstance] saveLogWithDeviceID:deviceID appID:appID eventType:[NSNumber numberWithInteger:type] logType:[NSNumber numberWithInteger:SLBSLogApp]];
}

@end