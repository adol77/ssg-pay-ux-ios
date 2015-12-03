//
//  PolicyManager.h
//  SLBSKit
//
//  Created by Regina on 2015. 8. 19..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#ifndef SLBSKit_PolicyManager_h
#define SLBSKit_PolicyManager_h

#import "Policy.h"

/**
 Policy 정책에 대한 서버와의 통신 및 데이터 관리,
 그리고 정책 변경된 경우 observer 등록한 매니저들에게 알림 서비스 제공
 
 iOS는 기본 업데이트 주기는 앱 실행시이며,
 주기적인 background 등록이 어렵기 때문에 background fetch에서 policy manager의 데이터 업데이트 기능 수행
 */
@interface PolicyManager : NSObject

+ (PolicyManager*)sharedInstance;

- (void)requestPolicyToServerWithBlock:(void (^)(BOOL succeess, Policy* policyData ))block;

@end

#endif
