//
//  DataManager.h
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 14..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (DataManager*)sharedInstance;

#pragma Company
- (void)setCompanies:(NSArray*)companies;
- (NSArray*)companies;

#pragma Brand
- (void)setBrands:(NSArray*)brands;
- (NSArray*)brands;

#pragma Branch
- (void)setBranches:(NSArray*)branches;
- (NSArray*)branches;

#pragma Floor
- (void)setFloors:(NSArray*)floors;
- (NSArray*)floors;

#pragma AccountName
- (void)setAccountName:(NSString*)accountName;
- (NSString*)accountName;

#pragma LocationUsageAgreement
- (void)setLocationLocationUsageAgreement:(BOOL)locationUsageAgreement;
- (BOOL)locationUsageAgreement;
@end
