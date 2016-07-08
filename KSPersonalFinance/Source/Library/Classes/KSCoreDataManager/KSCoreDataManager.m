//
//  KSCoreDataManager.m
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 31.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSCoreDataManager.h"
#import "KSTransaction.h"
#import "KSConstants.h"
#import "KSCategory.h"
#import "KSCategoryItem.h"

@implementation KSCoreDataManager

#pragma mark - 
#pragma mark Public Class Methods

+ (void)preloadTransactionsCategoriesWithType:(TransactionType)type completion:(void(^)(BOOL success))completion {
    NSMutableArray *categories = [NSMutableArray arrayWithArray:[self categoriesWithType:transactionTypeExpense]];
    [categories addObjectsFromArray:[self categoriesWithType:transactionTypeIncome]];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        for (NSDictionary *inputItem in categories) {
            
            KSCategory *category = [KSCategory MR_createEntityInContext:localContext];
            category.title = inputItem[kKSTitleNameKey];
            category.imageName = inputItem[kKSImageNameKey];
            category.transactionType = inputItem[kKSTransactionTypeKey];
            category.order = inputItem[kKSOrderKey];
        }
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (contextDidSave) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kKSCompleteCategoriesPreload];
            [[NSNotificationCenter defaultCenter] postNotificationName:kKSCompleteCategoriesPreload object:self];
        }
        completion(contextDidSave);
    }];
}

+ (void)loadCategoriesTransactionSumWithType:(TransactionType)type
                                betweenDates:(NSArray *)dates
                       withCompletionHandler:(fetchCompletionHandler)completionHandler
{
    float totalAmount = 0.f;
    
    NSNumber *typeOfTransaction = [NSNumber numberWithInteger:type];
    NSArray *fetchedCategories = [KSCategory MR_findByAttribute:kKSTransactionTypeKey withValue:typeOfTransaction];
    NSMutableArray *categoriesItems = [NSMutableArray array];

    for (KSCategory *category in fetchedCategories) {
        NSPredicate *datePredicate = [NSPredicate predicateWithFormat:@"(time >= %@) AND (time <= %@) AND (category.title = %@)", [dates firstObject], [dates lastObject], category.title];
        
        NSArray *transactionsArray = [KSTransaction MR_findAllWithPredicate:datePredicate];
        NSNumber *sum  = [transactionsArray valueForKeyPath:@"@sum.amount"];

        if (sum.floatValue > kKSZeroSign) {
            KSCategoryItem *item = [[KSCategoryItem alloc]initWithTitle:category.title
                                                               iconName:category.imageName
                                                                   type:category.transactionType
                                                              andAmount:@0];
            item.amount = sum;
            totalAmount +=[sum floatValue];
            
            [categoriesItems addObject:item];
        }
    }
    if (completionHandler) {
        completionHandler([categoriesItems copy], @(totalAmount));
    }
}

#pragma mark -
#pragma mark Private Class Methods

+ (NSArray *)categoriesWithType:(TransactionType)type {
    NSString *fileName = type == transactionTypeExpense ? kKSExpenseCategoriesFileName : kKSIncomeCategoriesFileName;
    
    NSString *inputFile  = [[NSBundle mainBundle] pathForResource:fileName ofType:kKSFileType];
    
    return [NSArray arrayWithContentsOfFile:inputFile];
}

@end
