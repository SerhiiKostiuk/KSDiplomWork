//
//  NSString+KSExtensions.m
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 01.06.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "NSString+KSExtensions.h"
#import "KSConstants.h"


@implementation NSString (KSExtensions)

#pragma mark -
#pragma mark Public Class Methods

+ (NSString *)stringFromType:(TransactionType)type {
    return type == transactionTypeExpense ? kKSExpenseTypeName : kKSIncomeTypeName;
}

+ (NSString *)hexStringForColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hexString;
}

@end
