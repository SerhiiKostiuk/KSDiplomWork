//
//  UIColor+KSExtensions.m
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 31.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "UIColor+KSExtensions.h"

@implementation UIColor (KSExtensions)

//+ (UIColor *)randomColor {
//    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
//    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
//    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//    
//    return color;
//}

+ (UIColor *)randomColor {
    NSArray *colors = @[[UIColor greenColor],[UIColor redColor],[UIColor blueColor], [UIColor cyanColor],[UIColor purpleColor],[UIColor grayColor],[UIColor orangeColor],[UIColor magentaColor], [UIColor brownColor]];
    NSInteger randomColorIndex = arc4random()%[colors count];
    
    return [colors objectAtIndex:randomColorIndex];
}

+ (UIColor *)colorFromType:(transactionType)type {
    return type == transactionTypeExpense ? [UIColor redColor] : [UIColor  greenColor];
}

@end
