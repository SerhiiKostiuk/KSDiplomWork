//
//  KSCategoryItem.h
//  KSPersonalFinance
//
//  Created by Serg Bla on 18.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TransactionType) {
    transactionTypeExpense = 1,
    transactionTypeIncome
};

@interface KSCategoryItem : NSObject
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *transactionType;

- (instancetype)initWithTitle:(NSString *)title
                     iconName:(NSString *)iconName
                         type:(NSNumber *)type
                    andAmount:(NSNumber *)amount;

@end
