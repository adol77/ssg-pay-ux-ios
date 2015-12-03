//
//  SLBSKitDefine.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//



#ifndef SLBSKit_SLBSKitDefine_h
#define SLBSKit_SLBSKitDefine_h


/**
 *  SLBS 위치 관련 Session Type을 나타낸다.
 */
typedef NS_ENUM(NSInteger, SLBSSessionType) {
    /**
     *  진입
     */
    SLBSSessionEnter = 1,
    /**
     *  진출
     */
    SLBSSessionExit,
    /**
     *  머무름
     */
    SLBSSessionDwell,
};

/**
 *  SLBS 제공하는 Service 종류
 */
typedef NS_ENUM(NSInteger, SLBSServiceCategory) {
    /**
     *  위치 서비스
     */
    SLBSServiceLocation = 0,
    /**
     *  Zone Campaign 알림 서비스
     */
    SLBSServiceZoneCampaign,
    /**
     *  Map 정보 서비스
     */
    SLBSServiceMap,
    /**
     *  서버와의 통신 및 사용자 정보 관리 서비스
     */
    SLBSServiceData,
};


/**
 *  SLBS SDK가 관리하고 있는 Log Type을 나타낸다.
 */
typedef NS_ENUM(NSInteger, SLBSLogType) {
    /**
     *  위치정보 로그
     */
    SLBSLogApp = 1,
    /**
     *  Zone 인식정보 로그
     */
    SLBSLogZone,
    /**
     *  Beacon 정보
     */
    SLBSLogBeacon,
    /**
     *  App Tracking 정보
     */
    SLBSLogAdminAccount,
    /**
     *  Device ID 정보.
     */
    SLBSLogDeviceID,
    /**
     *  Zone Campaign 정보
     */
    SLBSLogZoneCampaign,
};

/**
 *  DeviceID, AppTracking 관련 Log Type 정의
 */
typedef NS_ENUM(NSInteger, SLBSLogEventType) {
    /**
     *  DeviceID, App 추가
     */
    SLBSLogEventAdd = 1,
    /**
     *  DeviceID, App 수정
     */
    SLBSLogEventModify = 2,
    /**
     *  DeviceID, App 삭제
     */
    SLBSLogEventDelete = 9,
};

/**
 *  Server와의 통신 결과 값 정의
 */
typedef NS_ENUM(NSInteger, SLBSServiceResult) {
    /**
     *  처리 성공
     */
    SLBSSuccess   = 0,
    /**
     *  알 수 없는 오류
     */
    SLBSError     = 1,
    /**
     *  서버 연결을 실패하였음.
     */
    SLBSNETConnectionError    = 4,
    /**
     *  API 요청 시 설정된 timeout 시간 내에 완료 되지 않음.
     */
    SLBSNETClientTimeOut      = 8,
    /**
     *  처리는 완료 되었으나 서버에서 어떠한 값도 전달되지 않음.
     */
    SLBSNETEmptyData          = 9,
    /**
     *  처리는 완료 되었으나 전달된 값이 올바르지 않음.
     */
    SLBSNETInvalidData        = 10,
    /**
     *  Server Request 성공
     */
    SLBSServerRequestSuccess     = 200,
    /**
     *  Bad Request
     */
    SLBSServerBadRequest = 400,
    /**
     *  AccessToken UnAuthrized
     */
    SLBSServerUnauthrized = 401,
    /**
     *  Internal Server Error
     */
    SLBSServerInteralServiceError = 500,
    /**
     *  Parameter Value Error - Invalid Coordination
     */
    SLBSServerInvalidCoordinate = 601,
    /**
     *  Parameter Value Error - Invalid ZoneInfo
     */
    SLBSServerInvalidZoneInfo = 602,
    /**
     *  Parameter Value Error - Invalid DeviceID
     */
    SLBSServerDeviceIDInvalid = 603,
    /**
     *  Map Server TimeOut
     */
    SLBSServerMMSTimeout = 701,
    /**
     *  Zone Server TimeOut
     */
    SLBSServerZMSTimeout = 702,
    /**
     *  DB Server Transaction Error
     */
    SLBSServerDBServerTransactionError = 703,
    /**
     *  Zone Campaign Server TimeOut
     */
    SLBSServerZCMSTimeout = 704,
  
    SLBSServiceOperationMax      = 1999,
};


#pragma Beacon
/**
 *  Beacon Type 정보
 */
typedef NS_ENUM(NSInteger, SLBSBeaconType) {
    /**
     *  Proximity Beacon
     */
    SLBSBeaconProximity = 0,
    /**
     *  Positioning Beacon
     */
    SLBSBeaconPositioning,
};

#pragma ZoneType 
/**
 *  Zone Type 정보
 */
typedef NS_ENUM(NSInteger, SLBSZoneType) {
    /**
     *  기본 타입
     */
    SLBSZoneTypeBasic = 1,
    /**
     *  Object Type
     */
    SLBSZoneTypeObject,
    /**
     *  POI Type
     */
    SLBSZoneTypePOI,
    /**
     *  Store Type
     */
    SLBSZoneTypeStore,
};



#define SERVER_IP_SSG           @"202.3.20.82"
#define SERVER_IP_INTERNAL      @"112.217.207.164:20080"
//#define NEMUS_EXTERNAL 1
#ifdef NEMUS_EXTERNAL
#define SERVER_IP               @"115.71.237.123:7008"
#else
#define SERVER_IP               SERVER_IP_INTERNAL
#endif

#endif
