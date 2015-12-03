//
//  TSNet.h
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 26..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TSNetResultType) {
    TSNetSuccess = 0,
    TSNetErrorNotStarted,
    TSNetErrorResultFail,
    TSNetErrorNetworkDisable,
    TSNetErrorConnection,
    TSNetErrorNotAllowed,
    TSNetErrorServiceNotFound,
    TSNetErrorWrongMessage,
    TSNetErrorTimeout,
    TSNetErrorBadURL,
};

typedef NS_ENUM(NSInteger, TSNetDataType) {
    TSNetDataUnknown = 0,
    TSNetDataDictionary,
TSNetDataArray,
    TSNetDataBinary,
    TSNetDataEmpty,
};

typedef NS_ENUM(NSInteger, TSNetMethodType) {
    TSNetMethodTypeGET = 0,
    TSNetMethodTypePOST,
    TSNetMethodTypePUT,
    TSNetMethodTypeDELETE,
};

@class TSNet;

@protocol TSNetDelegate <NSObject>

@optional
- (void)net:(TSNet*)netObject didStartProcess:(TSNetResultType)result;
- (void)net:(TSNet*)netObject didEndProcess:(TSNetResultType)result;
- (void)net:(TSNet*)netObject didFailWithError:(TSNetResultType)result;

@end

@interface TSNet : NSObject

@property (nonatomic, strong) id<TSNetDelegate> delegate;
@property (nonatomic, strong) NSString *domainURL;
@property (nonatomic, readonly) NSInteger tag;
@property (nonatomic, readonly) TSNetResultType restype;
@property (nonatomic, strong) NSObject *userData;
//@property (nonatomic, assign) BOOL ignoreServerError;
//@property (nonatomic, strong) NSString *customRootKey;
@property (readonly) NSInteger errorCode;
- (void)setErrorCode:(NSInteger)errorCode;

- (void)setTag:(NSInteger)tag;
- (void)setRequestWithAPI:(NSString*)api URL:(NSString*)parameterURL;
- (void)setRequestWithAPI:(NSString*)api data:(NSDictionary*)requestObject;
- (void)setRequestWithAPI:(NSString*)api data:(NSDictionary*)requestObject encode:(BOOL)encode;
- (void)setRequestWithAPI:(NSString*)apiURL jsonData:(NSDictionary*)requestObject;
- (void)setRequestWithAPI:(NSString*)apiURL type:(TSNetMethodType)methodType;

- (void)setHeaderField:(NSString*)headerField value:(NSString*)value;

- (void)start;
- (void)cancelWithClear:(BOOL)clear;
- (void)startWithBlock:(void (^)(BOOL success, TSNet* netObject))block;
- (void)setURLRequestTimeoutInterval:(NSTimeInterval)timeoutInterval;
- (NSData*)responseData;
- (TSNetResultType)checkResponseResultHeader:(NSDictionary*)responseObject dataType:(TSNetDataType)type;
- (BOOL)processResponseData:(id)responseObject dataType:(TSNetDataType)type;
+ (NSString*)stringForURLParameter:(NSDictionary*)params;

@end

