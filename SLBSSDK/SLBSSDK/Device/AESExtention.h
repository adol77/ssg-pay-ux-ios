//
//  AESExtention.h
//  SLBSSDK
//
//  Created by Regina on 2015. 9. 10..
//  Copyright (c) 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>


@interface AESExtention : NSObject
- (NSString*) aesEncryptString:(NSString*)textString useKey:(BOOL)useKey;
- (NSString*) aesDecryptString:(NSString*)textString useKey:(BOOL)useKey;
//- (NSData *)AES128EncryptWithKey:(NSString *)key theData:(NSData *)Data;
//- (NSData *)AES128DecryptWithKey:(NSString *)key theData:(NSData *)Data;
//-(NSString *)hexEncode:(NSData *)data;
//- (NSData*) decodeHexString : (NSString *)hexString;
@end
