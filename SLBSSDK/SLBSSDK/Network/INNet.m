//
//  INNet.m
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 26..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import "INNet.h"
#import "SLBSKitDefine.h"
#import "TSDebugLogManager.h"
#import "DeviceNet.h"
#import "DeviceManager.h"

@interface INNet ()

@property (nonatomic, assign) NSInteger returnCode;
//@property (nonatomic, strong) NSString *returnMessage;

@end

@implementation INNet

- (instancetype)init {
    self = [super init];
    if (self) {
        //self.domainURL = [[INStorageManager sharedInstance] serverURL];
        self.domainURL = (@"http://" SERVER_IP);
        if ([self.domainURL length] <= 0) {
            NSLog(@"Empty Domain Name!!!!");
        }
    }
    return self;
}

- (void)start {
    [self setHeaderField:@"Content-Type" value:@"application/json"];
    [self setHeaderField:@"request_type" value:@"1"]; //For SSG
    [super start];
}

- (TSNetResultType)checkResponseResultHeader:(NSDictionary*)responseObject dataType:(TSNetDataType)type {
    TSNetResultType resultType = TSNetErrorResultFail;
    switch (type) {
        case TSNetDataUnknown: {
            if(self.errorCode == 0) {
                [self setErrorCode:SLBSNETInvalidData];
            }
            NSLog(@"NET ERROR(%ld) : irregular data format\n%@\n%@\n\treceiveData: {\n%@\n}", (long)self.errorCode, [responseObject objectForKey:@"error"], [self description],
                   ([[self responseData] length] > 0)?[[NSString alloc] initWithData:[self responseData] encoding:NSUTF8StringEncoding]:@"data empty");
            return -1;
        } break;
        case TSNetDataEmpty: {
            if(self.errorCode == 0) {
                [self setErrorCode:SLBSNETEmptyData];
            }
            TSELog(@"NET ERROR(%ld) : empty data\n%@\n%@", (long)self.errorCode, [responseObject objectForKey:@"error"], [self description]);
            return -1;
        } break;
            //        case TSNetDataArray:
            //        case TSNetDataBinary:
            //        case TSNetDataDictionary: {
            //        } break;
        default: {
//            self.returnCode = [[responseObject valueForKey:@"r_cde"] integerValue];
//            self.returnMessage = [responseObject valueForKey:@"r_msg"];
            if (!self.returnCode) {
                return TSNetSuccess;
            }
            if ([[self responseData] length] > 0) {
                if([responseObject valueForKey:@"r_cde"] == nil) {
                    if(self.errorCode == 0) {
                        [self setErrorCode:SLBSNETInvalidData];
                    }
                } else {
                    //[self setErrorCode:SLBSServiceOperationMin+self.returnCode];
                }
            } else {
                if(self.errorCode == 0) {
                    [self setErrorCode:SLBSNETEmptyData];
                }
            }
            TSELog(@"NET ERROR(%ld) : r_cde:%ld(r_msg:%@)\n%@", (long)self.errorCode, (long)self.returnCode, self.returnMessage, [self description]);
        } break;
    }
    return resultType;
}

+ (NSString*)stringForInvalidURL:(NSString*)url {
    if ([url isKindOfClass:[NSNull class]] == YES) {
        return @"";
    }
    
    if ([url length] <= 0) {
        return url;
    }
    
    if ([url hasPrefix:@"http://"]) {
        return url;
    }
    
    if ([url hasPrefix:@"https://"]) {
        return url;
    }
    
    //return [NSString stringWithFormat:@"%@%@", [[NetworkManager sharedInstance] serverURL], url];
    return (@"http://" SERVER_IP);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.errorCode = [(NSHTTPURLResponse *)response statusCode];
    TSELog(@"NET: httpCode(%ld)\n%@\n%@", (long)self.errorCode, [self description], response);
    //NSLog(@"NET: httpCode(%ld)\n%@\n%@", (long)self.errorCode, [self description], response);
    switch (self.errorCode) {
        case SLBSServerRequestSuccess:
            self.errorCode = SLBSSuccess;
            self.returnCode = SLBSSuccess;
            break;
//        case SLBSServerBadRequest:
        case SLBSServerUnauthrized:{
            [self cancelWithClear:NO];
            NSString* deviceID = [[DeviceManager sharedInstance] deviceID];
            NSString* otp = [[DeviceManager sharedInstance] generateOTP];
            NSDictionary* deviceInfo = [[DeviceManager sharedInstance] createDeviceProfile];
            [DeviceNet requestReAuthWithOTP:otp deviceInfo:deviceInfo deviceID:deviceID block:^(DeviceNet* net) {
                if(net.accessToken) {
                    [[DeviceManager sharedInstance] setAccessToken:net.accessToken];
                    [self setHeaderField:@"access_token" value:net.accessToken];
                    [self start];
                }
            }]; }
            break;
        default:
            self.returnCode = self.errorCode;
            break;
    }
}
@end

