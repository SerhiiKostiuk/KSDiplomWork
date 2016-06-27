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


@end

@implementation KSLoginParentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);

    
    // Segmented control with scrolling
    HMSegmentedControl *segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Логин",@"Регистрация"]];
    segmentedControl1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl1.frame = CGRectMake(0, 130, viewWidth, 40);
    segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl1.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl1.verticalDividerEnabled = NO;
    segmentedControl1.verticalDividerColor = [UIColor blackColor];
    segmentedControl1.verticalDividerWidth = 1.0f;
    [segmentedControl1 setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor blueColor]}];
        return attString;
    }];
    [segmentedControl1 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl1];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
//    if (segmentedControl.selectedSegmentIndex == 0) {
//      KSSigninViewController *signinVC = [[KSSigninViewController alloc]init];
//    
//        [self presentViewController:signinVC animated:YES completion:nil];
//
//    } else {
//        KSSignupViewController *signupVC = [[KSSignupViewController alloc]init];
//        
//        [self presentViewController:signupVC animated:YES completion:nil];
//
//    }
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
}

@end
