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

/**
 *  Device ID/ AccessToken 관리하는 class
 */
@interface DeviceManager : NSObject

+ (DeviceManager*)sharedInstance;

/**
 * SLBS 시작시 AccessToken, DeviceID 요청
 */
- (void) initData;

/**
 *  T-OTP 기반의 OTP값 생성
 *
 *  @return OTP OTP String Value
 */
- (NSString*)generateOTP;

/**
 *  DeviceProfile 정보 생성
 *
 *  @return deviceprofile - 각 값들은 key/value 형태
 */
- (NSDictionary*)createDeviceProfile;

/**
 *  DeviceID 저장
 *  저장시 AES128 암호화하여 저장
 *
 *  @param deviceID 저장할 deviceID
 */
- (void)setDeviceID:(NSString *)deviceID;

/**
 *  AccessToken 저장
 *
 *  @param accessToken accessToken
 */
- (void) setAccessToken:(NSString*)accessToken;

/**
 *  DeviceID 값을 NSUserDefaults로 부터 가져오기
 *  복호화된 DeviceID 값 전달
 *
 *  @return DeviceID 저장되어 있는 DeviceID
 */
- (NSString*)deviceID;

/**
 *  AccessToken 값을 NSUserDefaults로 부터 가져오기
 *
 *  @return AccessToken accessToken
 */
- (NSString*)accessToken;

/**
 *  App Package Name 가져오기
 *
 *  @return App Package Name
 */
- (NSString*)appID;

/**
 * 서버에게 AccessToken 요청
 * deviceID를 알고 있는 경우에만 가능. 없는 경우에는 initData로 DeviceID부터 처음부터 요청
 *
 *  @param block block
 */
- (void)requestReAuthToServerWithBlock:(void (^)(BOOL successed))block;


@end
#endif
