//
//  NSArray+KSExtensions.m
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 30.06.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "NSArray+KSExtensions.h"
#import "KSPersonalFinance-Swift.h"

@implementation NSArray (KSExtensions)

+ (NSArray *)colorsForCharts {
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    
    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
    [colors addObjectsFromArray:ChartColorTemplates.joyful];
    [colors addObjectsFromArray:ChartColorTemplates.colorful];
    [colors addObjectsFromArray:ChartColorTemplates.liberty];
    [colors addObjectsFromArray:ChartColorTemplates.pastel];
    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];
    
    return colors;
}

@end
