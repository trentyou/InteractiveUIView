//
//  HMDEdgeMenuTableViewController.h
//  PanGestureRecognizerTest
//
//  Created by Trent You on 7/9/15.
//  Copyright (c) 2015 Trent You. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMDPanGestureTestViewController.h"

@interface HMDEdgeMenuTableViewController : UITableViewController

@property (nonatomic, weak, nonnull) HMDPanGestureTestViewController *parent;

@end
