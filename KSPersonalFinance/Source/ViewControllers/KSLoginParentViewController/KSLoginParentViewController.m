//
//  KSLoginViewController.m
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 23.06.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSLoginParentViewController.h"
#import "HMSegmentedControl.h"
#import "KSSigninViewController.h"
#import "KSSignupViewController.h"

@interface KSLoginParentViewController ()
@property (weak, nonatomic) IBOutlet UIView  *containerView;
@property (weak, nonatomic) UIViewController *currentViewController;

- (void)startWithDefaultSegment;
- (void)presentSegmentedControl;
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl;
- (void)presentNewVCWithIdentifier:(NSString *)identifier;
- (void)addSubview:(UIView *)subView toView:(UIView*)parentView;
- (void)cycleFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController;

@end

@implementation KSLoginParentViewController

#pragma mark -
#pragma mark ViewController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self presentSegmentedControl];
    
    [self startWithDefaultSegment];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark -
#pragma mark Private

- (void)startWithDefaultSegment {
    KSSigninViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"signinVC"];
    
    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.containerView];
    
    self.currentViewController = newViewController;
}

- (void)presentSegmentedControl {
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    
    UIColor *segmentedControlColor = [UIColor colorWithRed:159/255.f green:232/255.f blue:53/255.f alpha:1.f];
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Логин",@"Регистрация"]];
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl.frame = CGRectMake(0, 165, viewWidth, 40);
    segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionIndicatorColor = segmentedControlColor;

    [segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl,
                                                              NSString *title,
                                                              NSUInteger index,
                                                              BOOL selected)
    {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title
                                                                        attributes:@{NSForegroundColorAttributeName :
                                                                                         segmentedControlColor}];
        return attString;
    }];
    
    [segmentedControl addTarget:self
                         action:@selector(segmentedControlChangedValue:)
               forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmentedControl];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self presentNewVCWithIdentifier:@"signinVC"];
    } else {
        [self presentNewVCWithIdentifier:@"signupVC"];
    }
}

- (void)presentNewVCWithIdentifier:(NSString *)identifier {
    UIViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [VC.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self cycleFromViewController:self.currentViewController toViewController:VC];
    self.currentViewController = VC;
}


- (void)addSubview:(UIView *)subView toView:(UIView*)parentView {
    [parentView addSubview:subView];
    
    NSDictionary * views = @{@"subView" : subView,};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
                                                                   options:0
                                                                   metrics:0
                                                                     views:views];
    [parentView addConstraints:constraints];
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|"
                                                          options:0
                                                          metrics:0
                                                            views:views];
    [parentView addConstraints:constraints];
}

- (void)cycleFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController
{
    [oldViewController willMoveToParentViewController:nil];
    
    [self addChildViewController:newViewController];
    [self addSubview:newViewController.view toView:self.containerView];
    
    [newViewController.view layoutIfNeeded];
    
    newViewController.view.alpha = 0;
    
    [UIView animateWithDuration:0.1
                     animations:^{
                         newViewController.view.alpha = 1;
                         oldViewController.view.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [oldViewController.view removeFromSuperview];
                         [oldViewController removeFromParentViewController];
                         [newViewController didMoveToParentViewController:self];
                     }];
}

@end
