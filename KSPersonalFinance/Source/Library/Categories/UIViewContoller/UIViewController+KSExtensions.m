//
//  UIViewController+KSExtensions.m
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 01.06.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "UIViewController+KSExtensions.h"
#import "KSConstants.h"

@implementation UIViewController (KSExtensions)

#pragma mark - 
#pragma mark Public

- (void)presentAlertView {
    UIAlertController * alert= [UIAlertController alertControllerWithTitle:nil
                                                                   message:kKSAlertMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:kKSAlertOkTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    [alert addAction:okAction];
}


@end
