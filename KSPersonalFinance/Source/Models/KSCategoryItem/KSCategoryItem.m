//
//  KSCategoryItem.m
//  KSPersonalFinance
//
//  Created by Serg Bla on 18.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSCategoryItem.h"
#import "KSMacro.h"

KSConstString(kKSExpenseTypeName, @"Expense");
KSConstString(kKSIncomeTypeName, @"Income");
KSConstString(kKSImageNameKey, @"categoryImage");

@implementation KSCategoryItem

+ (instancetype)KSCategoryItemWithDictionary:(NSDictionary *)dictionary {
    KSCategoryItem *item = [[KSCategoryItem alloc] init];
    
    item.categoryImage = dictionary[kKSImageNameKey];
    item.categoryName = dictionary[@"categoryName"];
    
    return item;
}

+ (NSString *)stringFromType:(TransactionType)type {
    return type == TransactionTypeExpense ? kKSExpenseTypeName : kKSIncomeTypeName;
}

@end
