//
//  EarthquakeAnnotation.h
//  USGSDemo
//
//  Created by Gustavo Barrientos on 5/19/15.
//  Copyright (c) 2015 Gustavo Barrientos. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface EarthquakeAnnotation : NSObject<MKAnnotation>

@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic) double magnitude;
@property(nonatomic) NSInteger index;

- (instancetype) initWithCoordinates:(CLLocationCoordinate2D)coordinate Magnitude:(double)magnitude andTitle:(NSString*)title;
@end
