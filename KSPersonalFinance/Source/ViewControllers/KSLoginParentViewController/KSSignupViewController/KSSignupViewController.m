//
//  KSSignupViewController.m
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 23.06.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSSignupViewController.h"
#import "UIViewController+KSExtensions.h"

@interface KSSignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *reEnterPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

- (void)checkPasswordsMatch;
- (void)hideKeyboardForField:(UITextField *)field;
- (void)registerNewUser;

@end

@implementation KSSignupViewController

#pragma mark -
#pragma mark Interface Handling

- (IBAction)registerUser:(id)sender {
    if ([_userNameField.text isEqualToString:@""] ||
        [_passwordField.text isEqualToString:@""] ||
        [_reEnterPasswordField.text isEqualToString:@""])
    {
        [self presentAlertViewWithMessage:@"Нужно заполнить все поля"];
    } else {
        [self checkPasswordsMatch];
        [self registerNewUser];
    }
    
}

- (IBAction)dismissKeyboard:(id)sender; {
    [self hideKeyboardForField:sender];
}

#pragma mark -
#pragma mark Private

- (void)checkPasswordsMatch {
    if ([_passwordField.text isEqualToString:_reEnterPasswordField.text]) {
        NSLog(@"password match !");
    } else {
        [self presentAlertViewWithMessage:@"password don't match !"];
    }
    
}

- (void)hideKeyboardForField:(UITextField *)field {
    [field becomeFirstResponder];
    [field resignFirstResponder];
}

- (void)registerNewUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:_userNameField.text forKey:@"userName"];
    [defaults setObject:_passwordField.text forKey:@"password"];
    [defaults synchronize];
}

@end
