//
//  DeviceNet.m
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 17..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import "DeviceNet.h"
#import "DeviceManager.h"
#import "TSDebugLogManager.h"


@interface DeviceNet()
@property (nonatomic, strong) NSString* accessToken;
@property (nonatomic, strong) NSString* deviceID;
@property (nonatomic, strong) NSDictionary* policyInfo;
@end

@implementation DeviceNet

const NSString *deviceApiVersion         = @"/v1";
const NSString *deviceApiGroup           = @"/devms";

- (instancetype)initWithAccessToken:(NSString *)token {
    self = [super init];
    if (self) {
        if ([token length] > 0) {
            [self setHeaderField:@"access_token" value:token];
        }
    }
    return self;
}

-(BOOL)processResponseData:(id)responseObject dataType:(TSNetDataType)type {
    if ( type != TSNetDataDictionary ) return NO;
    
    NSString* accessToken = [responseObject valueForKey:@"access_token"];
    if (accessToken) {
        self.accessToken = accessToken;
        return YES;
    }
    
   // NSString* deviceID = [responseObject valueForKey:@"device"];
    NSDictionary* deviceInfo = [responseObject valueForKey:@"device"];
    NSString* deviceID = [deviceInfo objectForKey:@"device_id"];
    if (deviceID) {
        self.deviceID = deviceID;
        return YES;
    }
    
    NSDictionary* policyInfo = [responseObject valueForKey:@"sdk_policy"];
    if (policyInfo) {
        self.policyInfo = [policyInfo copy];
        return YES;
    }
    
    return NO;
}

+(void)requestAuthWithOTP:(NSString *)otp deviceInfo:(NSDictionary *)deviceDic block:(void (^)(DeviceNet *))block {
    TSGLog(TSLogGroupNetwork, @"Request Auth API");
    DeviceNet *net = [[DeviceNet alloc] initWithAccessToken:otp];
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", deviceApiVersion, deviceApiGroup, @"/auth.do"] jsonData:deviceDic];
    
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if(success) {
            NSLog(@"Request auth result: %d", success);
            TSGLog(TSLogGroupNetwork, @"Request auth result: success");
            block(net);
        }
        else {
            NSLog(@"Request auth result: %d", success);
            TSGLog(TSLogGroupNetwork, @"Request auth result: fail");
            block(net);
        }
        
    }];
}

+(void)requestReAuthWithOTP:(NSString *)otp deviceInfo:(NSDictionary *)deviceDic deviceID:(NSString*)deviceID block:(void (^)(DeviceNet *))block {
    TSGLog(TSLogGroupNetwork, @"Request ReAuth API");
    
    DeviceNet *net = [[DeviceNet alloc] initWithAccessToken:otp];
    NSMutableDictionary* deviceObject = [[NSMutableDictionary alloc] init];
    deviceObject = [deviceDic mutableCopy];
    [deviceObject setObject:deviceID forKey:@"device_id"];
    
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", deviceApiVersion, deviceApiGroup, @"/reauth.do"] jsonData:deviceObject];
    
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if(success) {
            NSLog(@"Request ReAuth result success");
            TSGLog(TSLogGroupNetwork, @"Request ReAuth result: success");
            block(net);
        }
        else {
            NSLog(@"Request ReAuth result fail");
            TSGLog(TSLogGroupNetwork, @"Request ReAuth result: fail");
            block(net);
        }
        
    }];
}

+(void)requestDeviceIDWithAccessToken:(NSString*)token deviceInfo:(NSDictionary *)deviceDic block:(void (^)(DeviceNet *netObject))block {
    TSGLog(TSLogGroupNetwork, @"Request DeviceID API");
    
    DeviceNet *net = [[DeviceNet alloc] initWithAccessToken:token];
    
    NSMutableDictionary* requestObject = [[NSMutableDictionary alloc] init];
    requestObject = (NSMutableDictionary*)deviceDic;
    
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", deviceApiVersion, deviceApiGroup, @"/device.do"] jsonData:deviceDic];
    
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if(success) {
            NSLog(@"Request deviceID result: %d", success);
            TSGLog(TSLogGroupNetwork, @"Request deviceID result: %d", success);
            block(net);
        }
        else {
            NSLog(@"Request deviceID result : %d", success);
            TSGLog(TSLogGroupNetwork, @"Request deviceID result: %d", success);
            block(net);
        }
        
    }];

}

+(void)requestPolicyWithAccessToken:(NSString *)accessToken deviceID:(NSString *)deviceID block:(void (^)(DeviceNet *))block {
    TSGLog(TSLogGroupNetwork, @"Request Policy API deviceID: %@", deviceID);
    
    DeviceNet *net = [[DeviceNet alloc] initWithAccessToken:accessToken];
    
    [net setRequestWithAPI:[NSString stringWithFormat:@"%@%@%@", deviceApiVersion, deviceApiGroup, @"/policy.do"] URL:[NSString stringWithFormat:@"?device_id=%@", deviceID]];
    
    [net startWithBlock:^(BOOL success, TSNet *netObject) {
        if(success) {
            NSLog(@"Request policy result: %d", success);
            TSGLog(TSLogGroupNetwork, @"Request Policy result: %d", success);
            block(net);
        }
        else {
            NSLog(@"Request policy result : %d", success);
            TSGLog(TSLogGroupNetwork, @"Request Policy result: %d", success);
            block(net);
        }
        
    }];
}

@end
