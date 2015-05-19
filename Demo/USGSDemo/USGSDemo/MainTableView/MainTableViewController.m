//
//  MainTableViewController.m
//  USGSDemo
//
//  Created by Gustavo Barrientos on 5/18/15.
//  Copyright (c) 2015 Gustavo Barrientos. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "MainTableViewController.h"
#import "DetailViewController.h"
#import "MapViewController.h"

#import "USGSClient.h"
#import "UIColor+Flat.h"

@interface MainTableViewController ()
@property(nonatomic, strong) USGSClient *client;
- (void) GetAllEarthquakeInfo;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.client = [USGSClient sharedInstance];
    earthquakes = [NSArray array];
    self.title = @"Earthquakes";
    
    numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setPaddingPosition:NSNumberFormatterPadAfterSuffix];
    [numberFormatter setFormatWidth:2];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor WetAsphalt];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(GetAllEarthquakeInfo) forControlEvents:UIControlEventValueChanged];
    
    [self GetAllEarthquakeInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return earthquakes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"earthquakeCell" forIndexPath:indexPath];
    
    NSManagedObject *model = earthquakes[indexPath.row];
    
    //NSDictionary *earthquake = earthquakes[indexPath.row];
    //NSDictionary *properties = earthquake[@"properties"];
    
    NSNumber *magnitude = [model valueForKey:@"magnitude"]; //[properties[@"mag"] doubleValue];
    NSNumber *depth = [model valueForKey:@"depth"]; //earthquake[@"geometry"][@"coordinates"][2];
    NSString *place = [model valueForKey:@"place"]; //properties[@"place"];
    
    NSString *magnitudeText = [NSString stringWithFormat:@"Magnitude: %@, Depth: %@", [numberFormatter stringFromNumber:magnitude], [numberFormatter stringFromNumber:depth]];
    
    cell.textLabel.text = place;
    cell.detailTextLabel.text = magnitudeText;
    
    if([magnitude doubleValue] >= 0.0 && [magnitude doubleValue] <= 0.9){
        cell.backgroundColor = [UIColor Turquoise];
    } else if([magnitude doubleValue] > 0.9 && [magnitude doubleValue] <= 9.9) {
        cell.backgroundColor = [UIColor Alizarin];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"earthquakeSegue"]){
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        
        if(selectedIndexPath) {
            NSManagedObject *model = earthquakes[selectedIndexPath.row];
            //NSDictionary *earthquake = earthquakes[selectedIndexPath.row];
            DetailViewController *detail = [segue destinationViewController];
            detail.earthquake = model;
        }
    } else if([segue.identifier isEqualToString:@"mapView"]){
        MapViewController *mapView = [segue destinationViewController];
        mapView.earthquakes = earthquakes;
    }
}

- (void) GetAllEarthquakeInfo {
    if([self.client HasInternetAccess]) {
        if(![self.client isSynced]) {
            [self.client Sync];
        } else {
            earthquakes = [self.client GetRecentEarthquakes];
        }
    } else {
        if(![self.client isSynced]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Info" message:@"You don't have Internet access, also you don't have any Earthquake Data synced, Sorry." delegate:nil cancelButtonTitle:@"Ok :(" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            earthquakes = [self.client GetRecentEarthquakes];
        }
    }
    
    if (self.refreshControl) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        [self.refreshControl endRefreshing];
    }
}
@end
