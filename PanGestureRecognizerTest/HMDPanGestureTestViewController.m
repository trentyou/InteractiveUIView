//
//  HMDPanGestureTestViewController.m
//  PanGestureRecognizerTest
//
//  Created by Trent You on 7/8/15.
//  Copyright (c) 2015 Trent You. All rights reserved.
//

#import "HMDPanGestureTestViewController.h"
#import "HMDEdgeMenuTableViewController.h"

@interface HMDPanGestureTestViewController ()


@property (nonatomic, weak, nonnull) UIView *greySquare;
@property (nonatomic, weak, nonnull) UILabel *settingsInformationLabel;

@property (nonatomic) CGRect originalFrame;


// Left edge menu

@property (nonatomic, weak, nonnull) HMDEdgeMenuTableViewController *edgeMenu;
@property (nonatomic) CGRect presentedFrame;
@property (nonatomic) CGRect dismissedFrame;

@property (nonatomic) CGFloat presentationDuration;
@property (nonatomic) CGFloat dismissalDuration;

// Dimming overlay view

@property (nonatomic, weak, nonnull) UIView *dimmingOverlay;
@property (nonatomic) CGFloat dimmingOverlayAlpha;

@end

@implementation HMDPanGestureTestViewController

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _xTranslationMultiplier = 0.5;
        _yTranslationMultiplier = 0.5;
        
        _animationDuration = 0.5;
        _springDampening = 0.6;
        _initialSpringVelocity = 3.0;
        
        _presentationDuration = 0.7;
        _dismissalDuration = 0.4;
        
        _dimmingOverlayAlpha = 0.6;
    }
    
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupEdgeMenu];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupEdgePanGestureRecognizer];
    [self makeSquareInView];
    [self setupDimmingOverlayView];
    [self formatSettingsInformationLabel];
    
}


#pragma mark - View setup

- (void)setupEdgeMenu
{
    HMDEdgeMenuTableViewController *edgeMenu = [[HMDEdgeMenuTableViewController alloc] init];
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.75;
    
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    
    CGRect edgeMenuFrame = CGRectMake(x, y, 0.0f, height);
    edgeMenu.view.frame = edgeMenuFrame;
    
    edgeMenu.view.layer.shadowColor = [UIColor blackColor].CGColor;
    edgeMenu.view.layer.shadowRadius = 3.0f;
    edgeMenu.view.layer.shadowOffset = CGSizeMake(-3.0f, 0.0f);
    edgeMenu.view.layer.shadowOpacity = 1.0f;
    
    
    self.dismissedFrame = edgeMenuFrame;
    self.presentedFrame = CGRectMake(0.0f, y, width, height);
    
    self.edgeMenu = edgeMenu;
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissLeftEdgeMenu)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.edgeMenu.view addGestureRecognizer:leftSwipe];
    
    [self addChildViewController:edgeMenu];
    edgeMenu.parent = self;
    
    [self.view addSubview:edgeMenu.view];
}

- (void)setupEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *leftEdgeSwipe = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgePanGesture:)];
    leftEdgeSwipe.edges = UIRectEdgeLeft;
    
    [self.view addGestureRecognizer:leftEdgeSwipe];
    
}

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
    greySquare.layer.borderColor = [UIColor blackColor].CGColor;
    greySquare.layer.borderWidth = 2.0f;
    
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


- (void)setupDimmingOverlayView
{
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    CGRect frame = CGRectMake(0.0f, 0.0f, width, height);
    
    UIView *dimmingOverlay = [[UIView alloc] initWithFrame:frame];
    dimmingOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    dimmingOverlay.userInteractionEnabled = NO;
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissLeftEdgeMenu)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    leftSwipe.enabled = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissLeftEdgeMenu)];
    tap.numberOfTapsRequired = 1;
    tap.enabled = NO;
    
    [dimmingOverlay addGestureRecognizer:leftSwipe];
    [dimmingOverlay addGestureRecognizer:tap];
    
    self.dimmingOverlay = dimmingOverlay;
    [self.view addSubview:dimmingOverlay];
    
    [self.view bringSubviewToFront:self.edgeMenu.view];

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

#pragma mark - Handle gesture recognizers

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint center = gesture.view.center;
        CGPoint translation = [gesture translationInView:gesture.view];
        
        CGPoint newCenter = CGPointMake(center.x + (translation.x * self.xTranslationMultiplier), center.y + (translation.y * self.yTranslationMultiplier));
        gesture.view.center = newCenter;
        
        [gesture setTranslation:CGPointZero inView:gesture.view];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"gesture ended");
        
        [UIView animateWithDuration:self.animationDuration delay:0.0 usingSpringWithDamping:self.springDampening initialSpringVelocity:self.initialSpringVelocity options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.greySquare.frame = self.originalFrame;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)handleEdgePanGesture:(UIScreenEdgePanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Began edge recognition");
        
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gesture translationInView:gesture.view];
        
        CGFloat height = self.edgeMenu.view.frame.size.height;
        CGFloat width = self.edgeMenu.view.frame.size.width + translation.x;
        CGFloat x = self.edgeMenu.view.frame.origin.x;
        CGFloat y = self.edgeMenu.view.frame.origin.y;
        
        CGRect newFrame = CGRectMake(x, y, width, height);
        
        self.edgeMenu.view.frame = newFrame;
        
        [gesture setTranslation:CGPointZero inView:gesture.view];
        
        CGFloat alpha = (self.edgeMenu.view.frame.size.width / self.presentedFrame.size.width) * self.dimmingOverlayAlpha;
        self.dimmingOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:alpha];

        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Edge recognition ended");
        
        CGFloat widthRemaining = fabs(self.presentedFrame.size.width - self.edgeMenu.view.frame.size.width);
        CGFloat duration = widthRemaining / self.presentedFrame.size.width;
        
        [self presentLeftEdgeMenuWithDuration:duration];

    }
}


#pragma mark - Edge menu methods

- (void)presentLeftEdgeMenuWithDuration:(CGFloat)duration
{
    if (duration < 0.3) duration = 0.3;
    
    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:0.4 initialSpringVelocity:0.0 options:0 animations:^{
        self.edgeMenu.view.frame = self.presentedFrame;
        self.dimmingOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
    } completion:^(BOOL finished) {
        self.dimmingOverlay.userInteractionEnabled = YES;
        [self enableDimmingOverlayGestureRecognizers];
    }];
    
    
}

- (void)dismissLeftEdgeMenuWithDuration:(CGFloat)duration
{
    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:0 animations:^{
        self.edgeMenu.view.frame = self.dismissedFrame;
        self.dimmingOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        
    } completion:^(BOOL finished) {
        self.dimmingOverlay.userInteractionEnabled = NO;
        [self disableDimmingOverlayGestureRecognizers];
    }];
}


- (void)dismissLeftEdgeMenu
{
    [UIView animateWithDuration:self.dismissalDuration delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:0.0 options:0 animations:^{
        self.edgeMenu.view.frame = self.dismissedFrame;
        self.dimmingOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        
    } completion:^(BOOL finished) {
        self.dimmingOverlay.userInteractionEnabled = NO;
        [self disableDimmingOverlayGestureRecognizers];
    }];
}

#pragma mark - Dimming overlay methods

- (void)disableDimmingOverlayGestureRecognizers
{
    for (UIGestureRecognizer *gesture in self.dimmingOverlay.gestureRecognizers) {
        gesture.enabled = NO;
    }
}

- (void)enableDimmingOverlayGestureRecognizers
{
    for (UIGestureRecognizer *gesture in self.dimmingOverlay.gestureRecognizers) {
        gesture.enabled = YES;
    }
}



@end
