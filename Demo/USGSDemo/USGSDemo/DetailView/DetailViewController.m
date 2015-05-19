//
//  DetailViewController.m
//  USGSDemo
//
//  Created by Gustavo Barrientos on 5/18/15.
//  Copyright (c) 2015 Gustavo Barrientos. All rights reserved.
//
#import "EarthquakeAnnotation.h"
#import "DetailViewController.h"

#define METERS_PER_MILE 1609.344
#define kReuseIdentifierPin @"EarthquakePin"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setPaddingPosition:NSNumberFormatterPadAfterSuffix];
    [numberFormatter setFormatWidth:2];
    
    self.title = @"Earthquake";
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(self.earthquake) {
        //NSDictionary *properties = self.earthquake[@"properties"];
        //NSArray *geometry = self.earthquake[@"geometry"][@"coordinates"];
        NSNumber *depth = [self.earthquake valueForKey:@"depth"];
        
        PlaceLabel.text = [self.earthquake valueForKey:@"place"];
        MagnitudeLabel.text = [[self.earthquake valueForKey:@"magnitude"] stringValue];
        
        DepthLabel.text = [NSString stringWithFormat:@"%@ Km.", [numberFormatter stringFromNumber:depth]];
        
        //NSTimeInterval interval = [[self.earthquake valueForKey:@"date" ] longValue] /1000.0; // Convert Milliseconds to Seconds
        NSDate *date = [self.earthquake valueForKey:@"date"]; //[NSDate dateWithTimeIntervalSince1970:interval];
        NSString *dateStr = [dateFormatter stringFromDate:date];
        DateLabel.text = dateStr;
        
        double latitude = [[self.earthquake valueForKey:@"latitude"] doubleValue];
        double longitude = [[self.earthquake valueForKey:@"longitude"] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        // Set Annotation
        EarthquakeAnnotation *annotation = [[EarthquakeAnnotation alloc] initWithCoordinates:coordinate Magnitude:[[self.earthquake valueForKey:@"magnitude"] doubleValue] andTitle:[self.earthquake valueForKey:@"place"]];
        
        [EarthquakeMap addAnnotation:annotation];
        
        // Zoom to Annotation
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 7.5*METERS_PER_MILE,7.5*METERS_PER_MILE);
        [EarthquakeMap setRegion:viewRegion animated:YES];
        [EarthquakeMap regionThatFits:viewRegion];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate
- (MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    EarthquakeAnnotation *point = annotation;
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:kReuseIdentifierPin];
    
    if(!pinAnnotationView) {
        pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:point reuseIdentifier:kReuseIdentifierPin];
        pinAnnotationView.pinColor = MKPinAnnotationColorGreen;
        
        if(point.magnitude >= 0.0 && point.magnitude <= 0.9){
            pinAnnotationView.pinColor = MKPinAnnotationColorGreen;
        } else if(point.magnitude > 0.9 && point.magnitude < 9.9) {
           pinAnnotationView.pinColor = MKPinAnnotationColorRed;
        }
    }
    return pinAnnotationView;
}


@end
