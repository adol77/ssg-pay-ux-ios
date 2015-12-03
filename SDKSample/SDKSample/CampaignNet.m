//
//  CampaignNet.m
//  SDKSample
//
//  Created by Jeoungsoo on 9/22/15.
//  Copyright © 2015 Regina. All rights reserved.
//

#import "Campaign.h"
#import "CampaignNet.h"
#import "NetworkDataRequester.h"


typedef void (^netProgressBlock_t)(BOOL success, CampaignNet* netObject);

@interface CampaignNet (){
    __strong netProgressBlock_t progressBlock_t;
}
    @property (nonatomic, strong) NSArray *campaignList;
    @property NSMutableData* receiveData;
@end

@implementation CampaignNet

-(BOOL)processResponseData:(id)responseObject {
    NSArray* campaignList = [responseObject valueForKey:@"event_list"];
    if (campaignList) {
        self.campaignList = campaignList;
        return YES;
    }
    return NO;
}

+ (NSArray*)convertCampaignListToCampaignArray:(NSArray*)campaignList {
    NSMutableArray * campaignListArray = [NSMutableArray arrayWithCapacity:campaignList.count];
    for(NSDictionary *dict in campaignList) {
        Campaign *campaign = [Campaign campaignWithDictionary:dict];
        [campaignListArray addObject:campaign];
    }
    return campaignListArray;
}

- (void)requestCampaignListWithAccessToken:(NSString*)token
                                  campaignId:(int)campaignId
                                       url: (NSString*)url
                                       block:(void (^)(BOOL success, CampaignNet *netObject))block {
    
    progressBlock_t = block;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/campaign/events.do?campaign_id=%d", url, campaignId]]];
    [request setValue:token forHTTPHeaderField:@"access_token"];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:15.0f];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    [NSURLConnection connectionWithRequest : request
                                                                delegate : self];
}



// Receive Start to Submit
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *) aResponse {
    NSLog(@" Receive Start ");
    self.receiveData = [[NSMutableData alloc] init];
}

// Connection Error Event
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *) error {
    NSLog(@" Receive Error ");
}

// Connection Receive Event
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *) data {
    NSLog(@" Receiving............ ");
    [self.receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error = nil;
    
    id responseObject = [NSJSONSerialization JSONObjectWithData:self.receiveData options:NSJSONReadingAllowFragments error:&error];
    
    if (!responseObject) {
        
        if(progressBlock_t) {
            progressBlock_t(NO, self);
            progressBlock_t = nil;
            return;
        }
    }
    
    [self processResponseData:responseObject];
    
    if(progressBlock_t) {
        NSLog(@"%s, processBlock_t %@", __PRETTY_FUNCTION__, self);
        BOOL result = YES;

        progressBlock_t(result, self);
        progressBlock_t = nil;
    }
    
    
    
}

@end
