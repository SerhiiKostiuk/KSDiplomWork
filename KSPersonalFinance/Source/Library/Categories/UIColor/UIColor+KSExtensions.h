//
//  UIColor+KSExtensions.h
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 31.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSCategoryItem.h"

@interface UIColor (KSExtensions)

+ (UIColor *)randomColor;

+ (UIColor *)colorFromType:(TransactionType)type;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end
