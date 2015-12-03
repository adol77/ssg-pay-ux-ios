//
//  DataManager.m
//  SLBSSDK
//
//  Created by Regina on 2015. 10. 14..
//  Copyright © 2015년 nemustech. All rights reserved.
//

#import "DataManager.h"
#import "AESExtention.h"
@implementation DataManager

+ (DataManager*) sharedInstance {
    static dispatch_once_t oncePredicate;
    static DataManager *sharedDataManager = nil;
    dispatch_once(&oncePredicate, ^{
        sharedDataManager = [[DataManager alloc] init];
    });
    return sharedDataManager;
}

#pragma Company
- (void)setCompanies:(NSArray*)companies {
    if (companies) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"companies"];
        NSData *raw = [NSKeyedArchiver archivedDataWithRootObject:companies];
        [[NSUserDefaults standardUserDefaults] setObject:raw forKey:@"companies"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"companies"];
    }

}

- (NSArray*)companies {
    NSData *raw = [[NSUserDefaults standardUserDefaults] objectForKey:@"companies"];
    if (raw) {
        NSArray* ret = [NSKeyedUnarchiver unarchiveObjectWithData:raw];
        return ret;
    }
    return nil;
}

#pragma Brand
- (void)setBrands:(NSArray*)brands {
    if (brands) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"brands"];
        NSData *raw = [NSKeyedArchiver archivedDataWithRootObject:brands];
        [[NSUserDefaults standardUserDefaults] setObject:raw forKey:@"brands"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"brands"];
    }
}

- (NSArray*)brands {
    NSData *raw = [[NSUserDefaults standardUserDefaults] objectForKey:@"brands"];
    if (raw) {
        NSArray* ret = [NSKeyedUnarchiver unarchiveObjectWithData:raw];
        return ret;
    }
    return nil;
}

#pragma Branch
- (void)setBranches:(NSArray*)branches {
    if (branches) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"branches"];
        NSData *raw = [NSKeyedArchiver archivedDataWithRootObject:branches];
        [[NSUserDefaults standardUserDefaults] setObject:raw forKey:@"branches"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"branches"];
    }
}

- (NSArray*)branches {
    NSData *raw = [[NSUserDefaults standardUserDefaults] objectForKey:@"branches"];
    if (raw) {
        NSArray* ret = [NSKeyedUnarchiver unarchiveObjectWithData:raw];
        return ret;
    }
    return nil;
}

#pragma Floor
- (void)setFloors:(NSArray*)floors {
    if (floors) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"floors"];
        NSData *raw = [NSKeyedArchiver archivedDataWithRootObject:floors];
        [[NSUserDefaults standardUserDefaults] setObject:raw forKey:@"floors"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"floors"];
    }
}

- (NSArray*)floors {
    NSData *raw = [[NSUserDefaults standardUserDefaults] objectForKey:@"floors"];
    if (raw) {
        NSArray* ret = [NSKeyedUnarchiver unarchiveObjectWithData:raw];
        return ret;
    }
    return nil;
}

#pragma AccountName
- (void)setAccountName:(NSString*)accountName {
    if (accountName) {
        NSLog(@"setAccountName %@", accountName);
        
        AESExtention *aes = [[AESExtention alloc] init];
        NSString *encryptAccountName = [NSString stringWithFormat:@"%@", [aes aesEncryptString:accountName useKey:YES]];
        
        NSLog(@"set encryptAccountName %@", encryptAccountName);
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account_name"];
        [[NSUserDefaults standardUserDefaults] setObject:encryptAccountName forKey:@"account_name"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"account_name"];
    }
}

- (NSString*)accountName {
    NSString* encAccountName = [[NSUserDefaults standardUserDefaults] stringForKey:@"account_name"];
    
    if(encAccountName == nil)
        return nil;
    NSLog(@"encAccountName %@", encAccountName);
    AESExtention *aes = [[AESExtention alloc] init];
    NSString *decryptAccountName = [NSString stringWithFormat:@"%@", [aes aesDecryptString:encAccountName useKey:YES]];
    
    NSLog(@"get decryptAccountName %@", decryptAccountName);
    return decryptAccountName;
}

#pragma LocationUsageAgreement
- (void)setLocationLocationUsageAgreement:(BOOL)locationUsageAgreement {
    if (locationUsageAgreement) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"location_usage_agreement"];
        [[NSUserDefaults standardUserDefaults] setBool:locationUsageAgreement forKey:@"location_usage_agreement"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"location_usage_agreement"];
    }
}

- (BOOL)locationUsageAgreement {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"location_usage_agreement"];
}

@end
