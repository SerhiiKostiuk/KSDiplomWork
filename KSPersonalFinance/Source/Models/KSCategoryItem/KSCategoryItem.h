//
//  KSCategoryItem.h
//  KSPersonalFinance
//
//  Created by Serg Bla on 18.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, transactionType) {
    transactionTypeExpense = 1,
    transactionTypeIncome
};

@interface KSCategoryItem : NSObject
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *transactionType;
@property (nonatomic, strong) NSString *color;

- (instancetype)initWithTitle:(NSString *)title
                     iconName:(NSString *)iconName
                         type:(NSNumber *)type
                        color:(NSString *)color
                    andAmount:(NSNumber *)amount;

@end
