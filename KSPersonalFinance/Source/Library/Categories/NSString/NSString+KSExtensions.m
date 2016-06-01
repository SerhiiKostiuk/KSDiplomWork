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

+ (NSString *)stringFromType:(transactionType)type {
    return type == transactionTypeExpense ? kKSExpenseTypeName : kKSIncomeTypeName;
}

@end
