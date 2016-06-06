//
//  KSCoreDataManager.h
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 31.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSCategoryItem.h"

typedef void(^fetchCompletionHandler)(NSArray *categoriesItems, NSNumber *totalAmount);

@interface KSCoreDataManager : NSObject

+ (void)preloadTransactionsCategoriesWithType:(transactionType)type completion:(void(^)(BOOL success))completion;

+ (void)loadCategoriesTransactionSumWithType:(transactionType)type
                                betweenDates:(NSArray *)dates
                       withCompletionHandler:(fetchCompletionHandler)completionHandler;
@end
