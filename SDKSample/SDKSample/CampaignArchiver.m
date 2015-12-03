//
//  CampaignArchiver.m
//  SDKSample
//
//  Created by Jeoungsoo on 9/24/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "CampaignArchiver.h"
#import "AppDefine.h"

@implementation CampaignArchiver

+ (NSString*)buildCampaignFileName:(int)campaignId {
    return [NSString stringWithFormat:@"%@%d%@", CAMPAIGN_ARCHIVER_FILENAME, campaignId, CAMPAIGN_ARCHIVER_EXT];
}

+ (void)archiveCampaign:(Campaign*)campaign campaignId:(int)campaignId {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *campaignFileName = [self buildCampaignFileName:campaignId];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:campaignFileName];
    
    [NSKeyedArchiver archiveRootObject:campaign toFile:appFile];
}

+ (NSArray*)unarchiveCampaignAll {
    NSMutableArray *unarchivedCampaignArray = [NSMutableArray array];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil];
    for (NSString *file in directoryContent) {
        if([[file stringByDeletingPathExtension] containsString:CAMPAIGN_ARCHIVER_FILENAME]) {
            NSString *composedFilePath = [documentsDirectory stringByAppendingPathComponent:file];
            Campaign *unarchivedCampaign = [NSKeyedUnarchiver unarchiveObjectWithFile:composedFilePath];
            if (unarchivedCampaign!=nil) {
                [unarchivedCampaignArray addObject:unarchivedCampaign];
            }
        }
    }
    
    return unarchivedCampaignArray;
}

+ (BOOL)removeAllCampaignFile {
    BOOL result = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil];
    for (NSString *file in directoryContent) {
        if([[file stringByDeletingPathExtension] containsString:CAMPAIGN_ARCHIVER_FILENAME]) {
            NSString *composedFilePath = [documentsDirectory stringByAppendingPathComponent:file];
            result = [fileManager removeItemAtPath:composedFilePath error:nil];
            if (result==NO) {
                break;
            }
        }
    }
    return result;
}

// @SSG added
+ (BOOL) removeCampaignFile:(int)campaignId {
    BOOL result = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:nil];
    for (NSString *file in directoryContent) {
        if([[file stringByDeletingPathExtension] containsString:[NSString stringWithFormat:@"%d", campaignId]]) {
            NSString *composedFilePath = [documentsDirectory stringByAppendingPathComponent:file];
            result = [fileManager removeItemAtPath:composedFilePath error:nil];
            if (result==YES) {
                return result;
            }
        }
    }
    return result;
}
//

@end
