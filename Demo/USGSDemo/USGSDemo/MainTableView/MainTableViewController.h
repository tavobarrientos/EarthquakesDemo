//
//  MainTableViewController.h
//  USGSDemo
//
//  Created by Gustavo Barrientos on 5/18/15.
//  Copyright (c) 2015 Gustavo Barrientos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewController : UITableViewController
{
    __block NSArray *earthquakes;
    NSNumberFormatter *numberFormatter;
}
@end
