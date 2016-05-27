//
//  KSPreloadData.h
//  KSPersonalFinance
//
//  Created by Serg Bla on 23.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSCategoryItem.h"


@interface KSPreloadData : NSObject

+ (void)preloadTransactionsCategoriesWithType:(TransactionType)type completion:(void(^)(BOOL success))completion;

@end
