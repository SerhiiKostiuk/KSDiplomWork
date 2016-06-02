//
//  NSString+KSExtensions.h
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 01.06.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSCategoryItem.h"

@interface NSString (KSExtensions)

+ (NSString *)stringFromType:(transactionType)type;

+ (NSString *)hexStringForColor:(UIColor *)color;

@end
