//
//  KSCategoryItem.m
//  KSPersonalFinance
//
//  Created by Serg Bla on 18.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSCategoryItem.h"
#import "KSMacro.h"

KSConstString(kKSImageNameKey, @"imageName");

@implementation KSCategoryItem

+ (instancetype)KSCategoryItemWithDictionary:(NSDictionary *)dictionary {
    KSCategoryItem *item = [[KSCategoryItem alloc] init];
    
    item.imageName = dictionary[kKSImageNameKey];
    item.title = dictionary[@"title"];
    
    return item;
}

- (instancetype)initWithTitle:(NSString *)title
                     iconName:(NSString *)iconName
                         type:(NSNumber *)type
                        color:(NSString *)color
                    andAmount:(NSNumber *)amount
{
    if (self = [super init]) {
        
        _title = title;
        _transactionType = type;
        _amount = amount;
        _imageName = iconName;
        _color = color;
    }
    
    return self;
}



@end
