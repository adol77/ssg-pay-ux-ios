//
//  AppDefine.h
//  SDKSample
//
//  Created by Jeoungsoo on 9/23/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#ifndef AppDefine_h
#define AppDefine_h

#pragma mark - Debugging

//#define CAMPAIGN_TEST 1
//#define CAMPAIGN_POPUP_SHOW_ONLY_ONE    1

#pragma mark - SERVER IP

//#define NEMUS_EXTERNAL 1
//#define SINSEGE 1
#ifdef NEMUS_EXTERNAL
#define SERVER_IP_HEAD               @"http://115.71.237.123:7008"
#elseif SINSEGE
#define SERVER_IP_HEAD               @"http://202.3.20.82"
#else
#define SERVER_IP_HEAD               @"http://112.217.207.164:20080"
#endif

#pragma mark - Campaign

#define CAMPAIGN_ARCHIVER_FILENAME @"campaign_archive"
#define CAMPAIGN_ARCHIVER_EXT @".txt"

#pragma mark - ZoneType

#define ZONE_TYPE_BASIC 1
#define ZONE_TYPE_OBJECT 2
#define ZONE_TYPE_POI 3
#define ZONE_TYPE_STORE 4

// @SSG
#pragma mark - Company

#define SHINSEGAE_DEPARTMENT_STORE  1
#define SHINSEGAE_INC               1090

#pragma mark - New Address Architecture

//#define USE_NEW_ADDR_ARCH    1
#ifdef USE_NEW_ADDR_ARCH
#define DEFAULT_COMPANY_ID  55
#define DEFAULT_BRANCH_ID   11  // DEFAULT_COMPANY_ID를 사용할 수 밖에 없는 이유는, DEFAULT_COMPANY_ID가 2개의 branch를 가지고 있기 때문
#endif

#endif
