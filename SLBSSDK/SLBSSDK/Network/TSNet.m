 //
//  TSNet.m
//  SLBSSDK
//
//  Created by Regina on 2015. 8. 26..
//  Copyright (c) 2015년 ssg. All rights reserved.
//


#import "TSNet.h"
//#define GFDEBUG_ENABLE
#import "GFDebug.h"
#import "TSDebugLogManager.h"
 
typedef void (^netProgressBlock_t)(BOOL success, TSNet* netObject);

@interface TSNet () {
    __strong netProgressBlock_t progressBlock_t;
}

@property (nonatomic, strong) NSMutableURLRequest *request;
@property (nonatomic, assign) TSNetMethodType httpMethodType;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *receiveData;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *clientIP;
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) NSString *deviceToken;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, assign) TSNetResultType restype;

@property (nonatomic, assign) NSInteger errorCode;

@end

@implementation TSNet

- (id)init {
    self = [super init];
    if (self) {
        self.receiveData = [[NSMutableData alloc] init];
        self.request = [[NSMutableURLRequest alloc] init];
        self.timeoutInterval = 30;
        self.restype = TSNetErrorNotStarted;
        [self setURLRequestTimeoutInterval:self.timeoutInterval];
    }
    return self;
}

- (void)setURLRequestTimeoutInterval:(NSTimeInterval)timeoutInterval {
    //    GFLog(@"before timeoutInterval : %ld", (long)self.request.timeoutInterval);
    if (self.request == nil) {
        self.request = [[NSMutableURLRequest alloc] init];
    }
    [self.request setTimeoutInterval:timeoutInterval];
    //    GFLog(@"after timeoutInterval : %ld", (long)self.request.timeoutInterval);
}

- (NSString*)methodTypeString:(TSNetMethodType)type {
    switch (type) {
        case TSNetMethodTypeGET:    { return @"GET"; } break;
        case TSNetMethodTypePOST:   { return @"POST"; } break;
        case TSNetMethodTypePUT:    { return @"PUT"; } break;
        case TSNetMethodTypeDELETE: { return @"DELETE"; } break;
        default: { return nil; } break;
    }
    return nil;
}

- (void)setRequestWithAPI:(NSString*)apiURL URL:(NSString*)parameterURL {
    [self setRequestWithAPI:[NSString stringWithFormat:@"%@%@", apiURL, parameterURL] type:TSNetMethodTypeGET];
}

- (void)setRequestWithAPI:(NSString*)apiURL data:(NSDictionary*)requestObject {
    [self setRequestWithAPI:apiURL data:requestObject encode:NO];
}

- (void)setRequestWithAPI:(NSString*)apiURL data:(NSDictionary*)requestObject encode:(BOOL)encode {
    [self setRequestWithAPI:apiURL type:TSNetMethodTypePOST];
    NSString *httpBodyString = [TSNet stringForURLParameter:requestObject];
    if (encode) {
        httpBodyString = [httpBodyString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        GFLog(@"encodeded httpBodyString string :\n%@", httpBodyString);
    }
    NSData *postData =  [httpBodyString dataUsingEncoding:NSUTF8StringEncoding];
    GFLog(@"POSTJSON : %@", [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
    [self.request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    [self.request setHTTPBody:postData];
}

- (void)setRequestWithAPI:(NSString*)apiURL jsonData:(NSDictionary*)requestObject {
    
    [self setRequestWithAPI:apiURL type:TSNetMethodTypePOST];
    NSError *error = nil;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:requestObject options:NSJSONWritingPrettyPrinted error:&error];
    GFLog(@"POSTJSON : %@", [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
    NSAssert(!error, [error localizedDescription]);
    [self.request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    [self.request setHTTPBody:postData];
}

- (void)setRequestWithAPI:(NSString*)apiURL type:(TSNetMethodType)methodType {
    self.httpMethodType = methodType;
    [self.request setHTTPMethod:[self methodTypeString:self.httpMethodType]];
    [self.request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.domainURL, apiURL]]];
    GFLog(@"request url : %@",[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", self.domainURL, apiURL]] );
}

- (void)setHeaderField:(NSString*)headerField value:(NSString*)value {
    [self.request setValue:value forHTTPHeaderField:headerField];
}

- (void)cancelWithClear:(BOOL)clear {
    [self.connection cancel];
    if (clear) {
        self.receiveData = nil;
        self.request = nil;
        self.connection = nil;
        self.errorCode = 0;
        self.httpMethodType = TSNetMethodTypeGET;
        self.restype = TSNetSuccess;
    }
}

- (void)start {
    //    GFLog(@"before start timeoutInterval : %ld", (long)self.request.timeoutInterval);
    self.startDate = [NSDate date];
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(net:didStartProcess:)]) {
        [self.delegate net:self didStartProcess:TSNetSuccess];
    }
    //    GFLog(@"after start timeoutInterval : %ld", (long)self.request.timeoutInterval);
}

- (void)startWithBlock:(void (^)(BOOL success, TSNet* netObject))block {
    progressBlock_t = block;
    [self start];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.restype = TSNetErrorConnection;
    if (error.code == NSURLErrorTimedOut) {
        self.restype = TSNetErrorTimeout;
    }
    self.errorCode = self.restype;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(net:didFailWithError:)]) {
        [self.delegate net:self didFailWithError:self.restype];
    }
    [self checkResponseResultHeader:@{@"error":error} dataType:([self.receiveData length] > 0)?TSNetDataUnknown:TSNetDataEmpty];
    if(progressBlock_t) {
        progressBlock_t(NO, self);
        progressBlock_t = nil;
    }
}

//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    self.errorCode = [(NSHTTPURLResponse *)response statusCode];
//    GFLog(@"NET: httpCode(%ld)\n%@\n%@", (long)self.errorCode, [self description], response);
//    if (self.errorCode < 400) {
//        self.errorCode = 0;
//    }
//}
//
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error = nil;
//    NSString *responseJson = [[NSString alloc] initWithData:self.receiveData encoding:NSUTF8StringEncoding];
//    if ([responseJson containsString:@"floor_list"]) {
//        NSLog(@"floor_list contained");
//    }
    //NSLog(@"RESPONCEJSON : \n%@", responseJson);
    id responseObject = [NSJSONSerialization JSONObjectWithData:self.receiveData options:NSJSONReadingAllowFragments error:&error];
    self.restype = TSNetErrorResultFail;
    if (!responseObject) {
      //  [self checkResponseResultHeader:@{@"error":error} dataType:([self.receiveData length] > 0)?TSNetDataUnknown:TSNetDataEmpty];
        if (self.delegate && [self.delegate respondsToSelector:@selector(net:didEndProcess:)]) {
            [self.delegate net:self didEndProcess:self.restype];
        }
        if(progressBlock_t) {
            progressBlock_t(NO, self);
            progressBlock_t = nil;
            return;
        }
        //        NSAssert(!error, @"JSON Object Null!!!\nERROR : %@", [error localizedDescription]);
    }
    
    TSNetDataType type = TSNetDataDictionary;
    if ([responseObject isKindOfClass:[NSArray class]]) {
        type = TSNetDataArray;
    }
    
    BOOL result = [self processResponseData:responseObject dataType:type];
   
    if (result) {
        self.restype = TSNetSuccess;
    } else {
        self.restype = TSNetErrorResultFail;
        self.errorCode = 10;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(net:didEndProcess:)]) {
        [self.delegate net:self didEndProcess:self.restype];
    }
    if(progressBlock_t) {
        NSLog(@"%s, processBlock_t %@", __PRETTY_FUNCTION__, self);
        BOOL result = YES;
        if (self.restype != TSNetSuccess) {
            result = NO;
        }
        progressBlock_t(result, self);
        progressBlock_t = nil;
    }
}

- (void)setTag:(NSInteger)tag {
    _tag = tag;
}

+ (NSString*)stringForURLParameter:(NSDictionary*)params {
    NSString *parameterURL = @"";
    NSEnumerator *enumerator = [params keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        NSString *value = [params valueForKey:key];
        parameterURL = [parameterURL stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", key, value]];
    }
    return [parameterURL substringToIndex:[parameterURL length]-1];
}

- (NSData*)responseData {
    return [NSData dataWithData:self.receiveData];
}

- (TSNetResultType)checkResponseResultHeader:(NSDictionary*)responseObject dataType:(TSNetDataType)type { return TSNetSuccess; }

- (BOOL)processResponseData:(id)responseObject dataType:(TSNetDataType)type { return YES; }

- (NSString*)description {
    NSString *description = [NSString stringWithFormat:@"{\n\tURL: %@", [self.request.URL absoluteString]];
    
    if (self.request.allHTTPHeaderFields) {
        description = [description stringByAppendingFormat:@"\n\tHTTPHeader: %@", self.request.allHTTPHeaderFields];
    }
    NSData *body = self.request.HTTPBody;
    if ([body length]) {
        description = [description stringByAppendingFormat:@"\n\tHTTPBody: %@", [[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding]];
    }
    
    description = [description stringByAppendingString:@"\n}"];
    return description;
}

@end
