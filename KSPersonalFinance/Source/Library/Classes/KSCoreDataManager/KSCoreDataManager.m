//
//  KSCoreDataManager.m
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 31.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSCoreDataManager.h"
#import "KSConstants.h"
#import "KSCategory.h"

@implementation KSCoreDataManager

#pragma mark - 
#pragma Public Class Methods

+ (void)preloadTransactionsCategoriesWithType:(TransactionType)type completion:(void(^)(BOOL success))completion {
    NSMutableArray *categories = [NSMutableArray arrayWithArray:[self categoriesWithType:TransactionTypeExpense]];
    [categories addObjectsFromArray:[self categoriesWithType:TransactionTypeIncome]];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        for (NSDictionary *inputItem in categories) {
            
            KSCategory *category = [KSCategory MR_createEntityInContext:localContext];
            category.categoryName = inputItem[@"categoryName"];
            category.categoryImage = inputItem[@"categoryImage"];
            category.categoryType = inputItem[@"categoryType"];
        }
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (contextDidSave) {
#warning change Key                                       ----       ----\/
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"KSPreloadCompleted"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KSPreloadCompleted" object:self];
        }
        
        completion(contextDidSave);
        
    }];
}

#pragma mark -
#pragma Private Class Methods

+ (NSArray *)categoriesWithType:(TransactionType)type {
    NSString *fileName = type == TransactionTypeExpense ? kKSExpenseCategoriesFileName : kKSIncomeCategoriesFileName;
    
    NSString *inputFile  = [[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    
    return [NSArray arrayWithContentsOfFile:inputFile];
}

@end
