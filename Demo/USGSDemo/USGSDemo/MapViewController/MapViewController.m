//
//  MapViewController.m
//  USGSDemo
//
//  Created by Gustavo Barrientos on 5/19/15.
//  Copyright (c) 2015 Gustavo Barrientos. All rights reserved.
//

#import "MapViewController.h"
#import "EarthquakeAnnotation.h"
#import "DetailViewController.h"

#define kReuseIdentifierPin @"EarthquakePin"

@implementation MapViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Earthquakes";
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [DetailMap removeAnnotations:DetailMap.annotations];
    [self BuildAnnotations];
    
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
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        button.frame = CGRectMake(0, 0, 23, 23);
        button.tag = point.index;
        [button addTarget:self action:@selector(annotationSeeDetail:) forControlEvents:UIControlEventTouchDown];
        
        pinAnnotationView.rightCalloutAccessoryView = button;
        
        pinAnnotationView.canShowCallout = YES;
        pinAnnotationView.animatesDrop = YES;
    }
    return pinAnnotationView;
}

#pragma mark - Private Methods
- (void) BuildAnnotations {
    if(self.earthquakes) {
        NSMutableArray *annotations = [NSMutableArray array];
        
        [self.earthquakes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // NSDictionary *properties = obj[@"properties"];
            //NSArray *geometry = obj[@"geometry"][@"coordinates"];
            double latitude = [[obj valueForKey:@"latitude"] doubleValue];
            double longitude = [[obj valueForKey:@"longitude"] doubleValue];
            double magnitude = [[obj valueForKey:@"magnitude"] doubleValue];
            NSString *place = [obj valueForKey:@"place"];
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude); //CLLocationCoordinate2DMake([obj[1] doubleValue], [geometry[0] doubleValue]);
            
            EarthquakeAnnotation *annotation = [[EarthquakeAnnotation alloc] initWithCoordinates:coordinate Magnitude:magnitude andTitle:place];
            annotation.index = idx;
            
            [annotations addObject:annotation];
            
        }];
        
        [DetailMap addAnnotations:annotations];
    }
}

- (IBAction)annotationSeeDetail:(UIButton*)sender {
    NSDictionary *earthquake = self.earthquakes[sender.tag];
    
    DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
    detail.earthquake = earthquake;
    
    [self.navigationController pushViewController:detail animated:YES];
}
@end
