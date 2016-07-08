//
//  KSSigninViewController.m
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 23.06.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSSigninViewController.h"
#import "KSSignupViewController.h"
#import "KSMainViewController.h"
#import "UIViewController+KSExtensions.h"

@interface KSSigninViewController ()
@property (weak, nonatomic) IBOutlet UIButton    *signinButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (void)hideKeyboardForField:(UITextField *)field;

@end

@implementation KSSigninViewController

#pragma mark -
#pragma mark Interface Handling

- (IBAction)signin:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([self.userNameField.text isEqualToString:[defaults objectForKey:@"userName"]] && [self.passwordField.text isEqualToString:[defaults objectForKey:@"password"]]) {
        
        KSMainViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
        
        [self.navigationController pushViewController:VC animated:YES];

    } else {
        [self presentAlertViewWithMessage:@"Логин или пароль не верный"];
    }
}



- (IBAction)dismissKeyboard:(id)sender; {
    [self hideKeyboardForField:sender];
}

#pragma mark -
#pragma mark Private

- (void)hideKeyboardForField:(UITextField *)field {
    [field becomeFirstResponder];
    [field resignFirstResponder];
}


@end
