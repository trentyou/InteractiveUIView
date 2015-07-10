//
//  HMDPanGestureTestViewController.h
//  PanGestureRecognizerTest
//
//  Created by Trent You on 7/8/15.
//  Copyright (c) 2015 Trent You. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMDPanGestureTestViewController : UIViewController

// Animation and Pan Gesture translation settings

@property (nonatomic) CGFloat xTranslationMultiplier;
@property (nonatomic) CGFloat yTranslationMultiplier;

@property (nonatomic) CGFloat animationDuration;
@property (nonatomic) CGFloat springDampening;
@property (nonatomic) CGFloat initialSpringVelocity;

@end
