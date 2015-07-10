//
//  HMDEdgeMenuTableViewController.m
//  PanGestureRecognizerTest
//
//  Created by Trent You on 7/9/15.
//  Copyright (c) 2015 Trent You. All rights reserved.
//

#import "HMDEdgeMenuTableViewController.h"

#import "UIColor+Extensions.h"

@interface HMDEdgeMenuTableViewController ()

@end

@implementation HMDEdgeMenuTableViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self registerTableViewCells];
    self.tableView.backgroundColor = [UIColor lightGrayColor];
}

#pragma mark - Table view setup

- (void)registerTableViewCells
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%0.2f", self.parent.xTranslationMultiplier];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"%0.2f", self.parent.yTranslationMultiplier];
    } else if (indexPath.section == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"%0.2f seconds", self.parent.animationDuration];
    } else if (indexPath.section == 3) {
        cell.textLabel.text = [NSString stringWithFormat:@"%0.2f", self.parent.springDampening];
    } else if (indexPath.section == 4) {
        cell.textLabel.text = [NSString stringWithFormat:@"%0.2f", self.parent.initialSpringVelocity];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 125.0f;
    } else {
        return 20.0f;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"x Translation Multiplier";
            break;
            
        case 1:
            return @"y Translation Multiplier";
            break;
            
        case 2:
            return @"Animation Duration";
            break;
            
        case 3:
            return @"Spring Dampening";
            break;
            
        case 4:
            return @"Initial Spring Velocity";
            break;
            
        default:
            return @"N/A";
            break;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
