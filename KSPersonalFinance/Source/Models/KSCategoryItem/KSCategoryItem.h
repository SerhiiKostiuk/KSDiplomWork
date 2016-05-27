//
//  KSCategoryItem.h
//  KSPersonalFinance
//
//  Created by Serg Bla on 18.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TransactionType) {
    TransactionTypeExpense,
    TransactionTypeIncome
};

@interface KSCategoryItem : NSObject
@property (nonatomic, strong) NSString          *itemImage;
@property (nonatomic, strong) NSString          *categoryName;
@property (nonatomic, assign) TransactionType   categoryType;

+ (instancetype)KSCategoryItemWithDictionary:(NSDictionary *)dictionary;

+ (NSString *)stringFromType:(TransactionType)type;


@end
