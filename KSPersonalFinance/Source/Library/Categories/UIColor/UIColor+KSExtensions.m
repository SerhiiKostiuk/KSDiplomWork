//
//  UIColor+KSExtensions.m
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 31.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "UIColor+KSExtensions.h"

@implementation UIColor (KSExtensions)

#pragma mark - 
#pragma mark Public Class Methods

+ (UIColor *)randomColor {
    NSArray *colors = @[[UIColor greenColor],[UIColor redColor],[UIColor blueColor], [UIColor cyanColor],[UIColor purpleColor],[UIColor grayColor],[UIColor orangeColor],[UIColor magentaColor], [UIColor brownColor]];
    NSInteger randomColorIndex = arc4random()%[colors count];
    
    return [colors objectAtIndex:randomColorIndex];
}

+ (UIColor *)colorFromType:(transactionType)type {
    return type == transactionTypeExpense ? [UIColor redColor] : [UIColor  greenColor];
}

+ (UIColor *) colorWithHexString:(NSString *)hexString {
    
    /* convert the string into a int */
    unsigned int colorValueR,colorValueG,colorValueB,colorValueA;
    NSString *hexStringCleared = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if(hexStringCleared.length == 3) {
        /* short color form */
        /* im lazy, maybe you have a better idea to convert from #fff to #ffffff */
        hexStringCleared = [NSString stringWithFormat:@"%@%@%@%@%@%@", [hexStringCleared substringWithRange:NSMakeRange(0, 1)],[hexStringCleared substringWithRange:NSMakeRange(0, 1)],
                            [hexStringCleared substringWithRange:NSMakeRange(1, 1)],[hexStringCleared substringWithRange:NSMakeRange(1, 1)],
                            [hexStringCleared substringWithRange:NSMakeRange(2, 1)],[hexStringCleared substringWithRange:NSMakeRange(2, 1)]];
    }
    if(hexStringCleared.length == 6) {
        hexStringCleared = [hexStringCleared stringByAppendingString:@"ff"];
    }
    
    /* im in hurry ;) */
    NSString *red = [hexStringCleared substringWithRange:NSMakeRange(0, 2)];
    NSString *green = [hexStringCleared substringWithRange:NSMakeRange(2, 2)];
    NSString *blue = [hexStringCleared substringWithRange:NSMakeRange(4, 2)];
    NSString *alpha = [hexStringCleared substringWithRange:NSMakeRange(6, 2)];
    
    [[NSScanner scannerWithString:red] scanHexInt:&colorValueR];
    [[NSScanner scannerWithString:green] scanHexInt:&colorValueG];
    [[NSScanner scannerWithString:blue] scanHexInt:&colorValueB];
    [[NSScanner scannerWithString:alpha] scanHexInt:&colorValueA];
    
    
    return [UIColor colorWithRed:((colorValueR)&0xFF)/255.0
                           green:((colorValueG)&0xFF)/255.0 
                            blue:((colorValueB)&0xFF)/255.0 
                           alpha:((colorValueA)&0xFF)/255.0];
    
    
}

@end
