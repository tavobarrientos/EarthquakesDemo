//
//  USGSClient.h
//  USGSDemo
//
//  Created by Gustavo Barrientos on 5/18/15.
//  Copyright (c) 2015 Gustavo Barrientos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RecentEarthQuakesBlock)(NSError *error, NSArray *results);

@interface USGSClient : NSObject
+ (id)sharedInstance;
- (void)GetRecentEarthquakes:(RecentEarthQuakesBlock)block;
- (void)Sync:(NSArray*)earthquakeInfo;
- (void)Sync;
- (BOOL) isSynced;
- (BOOL) HasInternetAccess;
- (NSArray*)GetRecentEarthquakes;
@end
