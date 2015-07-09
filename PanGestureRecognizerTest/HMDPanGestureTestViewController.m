//
//  HMDPanGestureTestViewController.m
//  PanGestureRecognizerTest
//
//  Created by Trent You on 7/8/15.
//  Copyright (c) 2015 Trent You. All rights reserved.
//

#import "HMDPanGestureTestViewController.h"

@interface HMDPanGestureTestViewController ()


@property (nonatomic, weak, nonnull) UIView *greySquare;
@property (nonatomic, weak, nonnull) UILabel *settingsInformationLabel;

@property (nonatomic) CGRect originalFrame;

// Animation and Pan Gesture translation settings

@property (nonatomic) CGFloat xTranslationMultiplier;
@property (nonatomic) CGFloat yTranslationMultiplier;

@property (nonatomic) CGFloat animationDuration;
@property (nonatomic) CGFloat springDampening;
@property (nonatomic) CGFloat initialSpringVelocity;

@end

@implementation HMDPanGestureTestViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _xTranslationMultiplier = 0.5;
        _yTranslationMultiplier = 0.5;
        
        _animationDuration = 0.5;
        _springDampening = 0.6;
        _initialSpringVelocity = 3.0;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self makeSquareInView];
    [self formatSettingsInformationLabel];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - View setup

- (void)makeSquareInView
{
    CGFloat topOffset = 40.0;
    CGFloat sideOffset = 25.0;
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height - (topOffset * 2.0);
    CGFloat width = [UIScreen mainScreen].bounds.size.width - (sideOffset * 2.0);
    
    CGRect squareFrame = CGRectMake(sideOffset, topOffset, width, height);
    self.originalFrame = squareFrame;
    
    UIView *greySquare = [[UIView alloc] initWithFrame:squareFrame];
    greySquare.backgroundColor = [UIColor darkGrayColor];
    
    [self addPanGestureRecognizerToView:greySquare];
    
    UILabel *settingsInformationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
    settingsInformationLabel.numberOfLines = 10;
    settingsInformationLabel.textColor = [UIColor whiteColor];
    settingsInformationLabel.textAlignment = NSTextAlignmentCenter;

    self.settingsInformationLabel = settingsInformationLabel;
    
    [greySquare addSubview:settingsInformationLabel];
    
    self.greySquare = greySquare;
    [self.view addSubview:greySquare];
}

- (void)formatSettingsInformationLabel
{
    self.settingsInformationLabel.text = [NSString stringWithFormat:@"x Translation Multiplier: %0.2f \ny Translation Multiplier: %0.2f \n\nAnimation Duration: %0.2f \nSpring Dampening: %.2f \nInitial Spring Velocity: %0.2f", self.xTranslationMultiplier, self.yTranslationMultiplier, self.animationDuration, self.springDampening, self.initialSpringVelocity];
}


- (void)addPanGestureRecognizerToView:(UIView *)view
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [view addGestureRecognizer:panGesture];
}



- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint center = gesture.view.center;
        CGPoint translation = [gesture translationInView:gesture.view];
        
        CGPoint newCenter = CGPointMake(center.x + (translation.x * self.xTranslationMultiplier), center.y + (translation.y * self.yTranslationMultiplier));
        gesture.view.center = newCenter;
        
        [gesture setTranslation:CGPointZero inView:gesture.view];
        NSLog(@"%@", NSStringFromCGPoint(translation));
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"gesture ended");
        
        [UIView animateWithDuration:self.animationDuration delay:0.0 usingSpringWithDamping:self.springDampening initialSpringVelocity:self.initialSpringVelocity options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.greySquare.frame = self.originalFrame;
        } completion:^(BOOL finished) {
            
        }];
    }
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
