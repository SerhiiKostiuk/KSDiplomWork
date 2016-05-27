//
//  KSPreloadData.m
//  KSPersonalFinance
//
//  Created by Serg Bla on 23.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSPreloadData.h"
#import "KSCategory.h"
#import "KSMacro.h"

KSConstString(kKSExpenseCategoriesFileName, @"expense");
KSConstString(kKSIncomeCategoriesFileName, @"income");

@implementation KSPreloadData

+ (void)preloadTransactionsCategoriesWithType:(TransactionType)type completion:(void(^)(BOOL success))completion {
    NSMutableArray *categories = [NSMutableArray arrayWithArray:[self categoriesWithType:TransactionTypeExpense]];
    [categories addObjectsFromArray:[self categoriesWithType:TransactionTypeIncome]];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        for (NSDictionary *inputItem in categories) {
            KSCategory *category = [KSCategory MR_createEntityInContext:localContext];
            category.categoryName = inputItem[@"categoryName"];
            category.categoryImage = inputItem[@"itemImage"];
        }
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        if (contextDidSave) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"KSPreloadCompleted"];
        }
        
        completion(contextDidSave);
        
    }];
}

+(NSArray *)categoriesWithType:(TransactionType)type{
    NSString *fileName = type == TransactionTypeExpense ? kKSExpenseCategoriesFileName : kKSIncomeCategoriesFileName;
    NSString *inputFile  = [[NSBundle mainBundle] pathForResource:fileName
                                                           ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:inputFile];
}

@end
