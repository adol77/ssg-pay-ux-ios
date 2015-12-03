//
//  DeviceManager.m
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceManager.h"
#import "NetworkManager.h"
@import UIKit;

#define TEST_CODE 1

@implementation DeviceManager : NSObject

+ (DeviceManager*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static DeviceManager *sharedDeviceManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedDeviceManager = [[DeviceManager alloc] init];
    });
    return sharedDeviceManager;
}

/**
 *  T-OTP 기반의 OTP값 생성
 *
 *  @return OTP
 */
- (NSString*)generateOTP
{
    //Todo: SEED 값 정의 필요, 시간 Interval 결정 필요(10분, 30분 등..)
    NSDateFormatter* today = [[NSDateFormatter alloc] init];
    [today setDateFormat:@"yyyy-MM-dd-hh-mm"];
    
    NSString *currentDate = [today stringFromDate:[NSDate date]];
    
    NSLog(@"%s generateOTP %@", __PRETTY_FUNCTION__, currentDate);
    
    return currentDate;
}

/**
 *  DeviceProfile 정보 생성
 *
 *  @return deviceprofile - 각 값들은 key/value 형태
 */
- (NSDictionary*)createDeviceProfile
{
    //iOS OS Build Number가 없음.
    //OS Version 변경시 Device ID 변경 요건 가능한지 확인 필요.
    NSDictionary* deviceProfile = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIDevice currentDevice].systemVersion,  @"OS Version",
                                   [UIDevice currentDevice].model, @"H/W Model",
                                   nil];
    
    NSLog(@"%s createDeviceProfile %@", __PRETTY_FUNCTION__, deviceProfile);
    
    return deviceProfile;
}

/**
 *  Get AppID
 *
 *  @return Application Bundle Identifier
 */
- (NSString*)getAppID
{
    //NSString *appName = [[NSBundle bundleWithIdentifier:@"BundleIdentifier"] objectForInfoDictionaryKey:(id)kCFBundleExecutableKey];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *appName = [bundle bundleIdentifier];
    NSLog(@"%s getAppID %@", __PRETTY_FUNCTION__, appName);
    
    return appName;
}

/**
 *  Json Web Token 생성
 *  JWT Claim 내용을 parameter로 받음
 *
 *  @param otp        T-OTP 값
 *  @param deviceInfo device 정보 - OS Version, H/W Model
 *  @param appID      Application PackageName
 *
 *  @return json web token
 */
- (NSString *)createJWT:(NSString*)otp deviceInfo:(NSDictionary *)deviceInfo appID:(NSString *)appID
{
    //JWT 생성 방법
    //1. Signature 생성 - BASE64 Encode
    //2. Claim 생성 - payload : BASE64 Encode
    //3. Claim Signature - payload : SHA1-256 Encode
    NSDictionary* signatureDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"HS256", @"alg",
                                  @"JWT", @"type", nil];
    
    //Todo: Base64 Encoding
    NSString* signatureString = [self convertJsonFromNSDictionary:signatureDic];
    
    
    //Todo: OTP, deviceInfo, AppID 통합본의 json 생성, Base64 Encoding, SHA1-256 Encoding
    //현재는 deviceInfo만 적용
    NSString* claimString = [self convertJsonFromNSDictionary:deviceInfo];
    
    return [signatureString stringByAppendingString:claimString];
}

/**
 *  서버에게 DeviceID 요청
 *  성공시 전달받은 DeviceID, Token값 저장
 *
 */
- (void)requestDeviceIDToServerWithBlock:(void (^)(BOOL))block
{
    //DeviceID 유무 확인
    //Todo List: 공통 영역 DeviceID 검색 기능 추가
    NSString* deviceID = [self deviceID];
    
    if(deviceID)
        block(true);
    else
    {
        NSString* jsonWebToken = [self createJWT:[self generateOTP] deviceInfo:[self createDeviceProfile] appID:[self getAppID]];
        
        [NetworkManager requestDeviceIDWithBlock:jsonWebToken completion:^(BOOL successed, NSString* deviceID, NSString* accessToken)
         {
             if(successed)
             {
                 //Todo: NSUserDefaults 저장코드 추가
                 [self setDeviceID:deviceID];
                 [self setToken:accessToken];
                 block(true);
                 
             }
             else
                 block(false);
         }];
    }
    
#ifdef TEST_CODE
    block(true);
#endif
}

-(NSString*)convertJsonFromNSDictionary:(NSDictionary*)dictionaryData
{
    NSError *error;
    NSString *jsonString = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionaryData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (!jsonData) {
        NSLog(@"Error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}
@end