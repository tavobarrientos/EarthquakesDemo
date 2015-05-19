//
//  MapViewController.h
//  USGSDemo
//
//  Created by Gustavo Barrientos on 5/19/15.
//  Copyright (c) 2015 Gustavo Barrientos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate> {
    
    __weak IBOutlet MKMapView *DetailMap;
}
@property(nonatomic) NSArray *earthquakes;
@end
