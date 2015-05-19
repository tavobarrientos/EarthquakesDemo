//
//  USGSClient.m
//  USGSDemo
//
//  Created by Gustavo Barrientos on 5/18/15.
//  Copyright (c) 2015 Gustavo Barrientos. All rights reserved.
//

#import "USGSClient.h"
#import "Reachability.h"
#import "AppDelegate.h"

#define kApiUri @"http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.geojson"

@implementation USGSClient
+ (id)sharedInstance {
    static USGSClient *sharedInstane = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstane = [[self alloc] init];
    });
    return sharedInstane;
}

- (void)GetRecentEarthquakes:(RecentEarthQuakesBlock)block {
    NSURL *uri = [NSURL URLWithString:kApiUri];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:uri completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(!error) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *features = json[@"features"];
            if(block) {
                block(error, features);
            }
        }
    }];
    
    [task resume];
}

- (void)Sync:(NSArray*)earthquakeInfo {
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    if(earthquakeInfo) {
        [earthquakeInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *properties = obj[@"properties"];
            NSArray *geometry = obj[@"geometry"][@"coordinates"];
            
            NSManagedObject *earthquakeEntity = [NSEntityDescription
                                               insertNewObjectForEntityForName:@"Earthquake"
                                               inManagedObjectContext:context];
            
            NSTimeInterval interval = [properties[@"time"] longValue] / 1000.0;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
            
            [earthquakeEntity setValue:date forKey:@"date"];
            [earthquakeEntity setValue:geometry[2] forKey:@"depth"];
            [earthquakeEntity setValue:geometry[1] forKey:@"latitude"];
            [earthquakeEntity setValue:geometry[0] forKey:@"longitude"];
            [earthquakeEntity setValue:properties[@"mag"] forKey:@"magnitude"];
            [earthquakeEntity setValue:properties[@"place"] forKey:@"place"];

            NSError *error;
            if (![context save:&error]) {
                NSLog(@"Could't Save: %@", [error localizedDescription]);
            }
        }];
    }
}

- (void)Sync{
    [self GetRecentEarthquakes:^(NSError *error, NSArray *results) {
        if(!error) {
            [self Sync:results];
        }
    }];
}

- (BOOL) isSynced {
    NSArray *earthquakes = [self GetRecentEarthquakes];
    return earthquakes.count > 0;
}

- (BOOL) HasInternetAccess {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    return status != NotReachable;
}

- (NSArray*)GetRecentEarthquakes {
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"Earthquake" inManagedObjectContext:context];
    [request setEntity:description];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    return result;
}
@end
