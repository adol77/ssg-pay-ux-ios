//
//  DeviceNet.h
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 17..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "INNet.h"

/**
 *  Device 관련 서버 통신 담당
 */
@interface DeviceNet : INNet

@property (readonly) NSString* accessToken;
@property (readonly) NSString* deviceID;
@property (readonly) NSDictionary* policyInfo;

/**
 *  OTP 값으로 최초 인증 요청 함수
 *
 *  @param otp       OTP
 *  @param deviceDic Device Profile
 *  @param block     block
 */
+(void)requestAuthWithOTP:(NSString *)otp deviceInfo:(NSDictionary *)deviceDic block:(void (^)(DeviceNet *netObject))block;

/**
 *  OTP 값과 Device ID로 재 인증 요청함수
 *
 *  @param otp       OTP
 *  @param deviceDic Device Profile
 *  @param deviceID  Device ID
 *  @param block     block
 */
+(void)requestReAuthWithOTP:(NSString *)otp deviceInfo:(NSDictionary *)deviceDic deviceID:(NSString*) deviceID block:(void (^)(DeviceNet *netObject))block;

/**
 *  Device ID 요청 함수
 *
 *  @param token     access token
 *  @param deviceDic Device Profile
 *  @param block     block
 */
+(void)requestDeviceIDWithAccessToken:(NSString*)token deviceInfo:(NSDictionary *)deviceDic block:(void (^)(DeviceNet *netObject))block;

/**
 *  Policy 요청 함수
 *
 *  @param accessToken access token
 *  @param deviceID    Device ID
 *  @param block       block
 */
+(void)requestPolicyWithAccessToken:(NSString *)accessToken deviceID:(NSString*)deviceID block:(void (^)(DeviceNet *netObject))block;
@end

