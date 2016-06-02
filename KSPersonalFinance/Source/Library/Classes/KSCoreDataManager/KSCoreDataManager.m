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
#import "UIColor+KSExtensions.h"
#import "KSCategoryItem.h"

@implementation KSCoreDataManager

#pragma mark - 
#pragma Public Class Methods

+ (void)preloadTransactionsCategoriesWithType:(transactionType)type completion:(void(^)(BOOL success))completion {
    NSMutableArray *categories = [NSMutableArray arrayWithArray:[self categoriesWithType:transactionTypeExpense]];
    [categories addObjectsFromArray:[self categoriesWithType:transactionTypeIncome]];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        for (NSDictionary *inputItem in categories) {
            
            KSCategory *category = [KSCategory MR_createEntityInContext:localContext];
            category.title = inputItem[@"title"];
            category.imageName = inputItem[@"imageName"];
            category.transactionType = inputItem[@"transactionType"];
            category.color = inputItem[@"color"];
        }
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (contextDidSave) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kKSCompleteCategoriesPreload];
            [[NSNotificationCenter defaultCenter] postNotificationName:kKSCompleteCategoriesPreload object:self];
        }
        
        completion(contextDidSave);
        
    }];
}

+ (void)loadCategoriesTransactionSumWithType:(transactionType)type
                       withCompletionHandler:(fetchCompletionHandler)completionHandler
{
    float totalAmount = 0.f;
    
    NSNumber *typeOfTransaction = [NSNumber numberWithInteger:type];
    NSArray *fetchedCategories = [KSCategory MR_findByAttribute:kKSTransactionTypeKey withValue:typeOfTransaction];
    
    NSMutableArray *categoriesItems = [NSMutableArray array];
    
    for (KSCategory *category in fetchedCategories) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category.title = %@",category.title];
        
        NSNumber *transactionSum = [KSTransaction MR_aggregateOperation:@"sum:"
                                                            onAttribute:@"amount"
                                                          withPredicate:predicate];
        totalAmount +=[transactionSum floatValue];
        
        if (transactionSum.floatValue > kKSZeroSign) {
            KSCategoryItem *item = [[KSCategoryItem alloc]initWithTitle:category.title
                                                               iconName:category.imageName
                                                                   type:category.transactionType
                                                                  color:category.color
                                                              andAmount:@0];
            item.amount = transactionSum;
            
            [categoriesItems addObject:item];
        }
    }
    
    if (completionHandler) {
        completionHandler([categoriesItems copy], @(totalAmount));
    }
}

#pragma mark -
#pragma Private Class Methods

+ (NSArray *)categoriesWithType:(transactionType)type {
    NSString *fileName = type == transactionTypeExpense ? kKSExpenseCategoriesFileName : kKSIncomeCategoriesFileName;
    
    NSString *inputFile  = [[NSBundle mainBundle] pathForResource:fileName ofType:kKSFileType];
    
    return [NSArray arrayWithContentsOfFile:inputFile];
}

@end
