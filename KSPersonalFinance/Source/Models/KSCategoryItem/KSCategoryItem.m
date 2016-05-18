//
//  KSCategoryItem.m
//  KSPersonalFinance
//
//  Created by Serg Bla on 18.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSCategoryItem.h"

@implementation KSCategoryItem

+ (instancetype)KSCategoryItemWithDictionary:(NSDictionary *)dictionary {
    KSCategoryItem *item = [[KSCategoryItem alloc] init];
    
    item.itemImage = dictionary[@"itemImage"];
    
    return item;
}


@end
