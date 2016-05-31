//
//  KSCoreDataManager.h
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 31.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSCategoryItem.h"

@interface KSCoreDataManager : NSObject

+ (void)preloadTransactionsCategoriesWithType:(TransactionType)type completion:(void(^)(BOOL success))completion;

@end
