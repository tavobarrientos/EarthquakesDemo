//
//  DetailViewController.h
//  USGSDemo
//
//  Created by Gustavo Barrientos on 5/18/15.
//  Copyright (c) 2015 Gustavo Barrientos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>

@interface DetailViewController : UITableViewController<MKMapViewDelegate> {
    __weak IBOutlet UILabel *DateLabel;
    __weak IBOutlet UILabel *PlaceLabel;
    __weak IBOutlet UILabel *MagnitudeLabel;
    __weak IBOutlet MKMapView *EarthquakeMap;
    __weak IBOutlet UILabel *DepthLabel;
    
    NSDateFormatter *dateFormatter;
    NSNumberFormatter *numberFormatter;
}
@property(nonatomic, strong) NSManagedObject *earthquake;
@end
