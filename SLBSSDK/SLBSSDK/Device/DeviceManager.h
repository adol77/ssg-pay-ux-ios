//
//  DeviceManager.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#ifndef SLBSKit_DeviceManager_h
#define SLBSKit_DeviceManager_h

@class DeviceManager;
@interface DeviceManager : NSObject

@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSString* deviceID;

+ (DeviceManager*)sharedInstance;

/**
 초기화시 OTP 생성, DeviceProfile 생성하여 JWT 생성,
 AppID는 App의 PackageName
 */
- (NSString*)generateOTP;
- (NSDictionary*)createDeviceProfile;
- (NSString*)getAppID;
- (NSString*)createJWT:(NSString*) otp deviceInfo:(NSDictionary*)deviceInfo appID:(NSString*)appID;

/**
 서버에게 DeviceID 요청
*/
- (void)requestDeviceIDToServerWithBlock:(void (^)(BOOL successed))block;


@end
#endif
