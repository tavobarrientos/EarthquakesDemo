//
//  EarthquakeAnnotation.m
//  USGSDemo
//
//  Created by Gustavo Barrientos on 5/19/15.
//  Copyright (c) 2015 Gustavo Barrientos. All rights reserved.
//

#import "EarthquakeAnnotation.h"

@implementation EarthquakeAnnotation

- (instancetype) initWithCoordinates:(CLLocationCoordinate2D)coordinate Magnitude:(double)magnitude andTitle:(NSString*)title {
    self = [super init];
    
    if(self) {
        self.coordinate = coordinate;
        self.magnitude = magnitude;
        self.title = title;
    }
    
    return self;
}

@end
