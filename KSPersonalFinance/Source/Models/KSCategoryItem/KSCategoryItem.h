//
//  KSCategoryItem.h
//  KSPersonalFinance
//
//  Created by Serg Bla on 18.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSCategoryItem : NSObject

@property (nonatomic, strong) NSString *itemImage;

+ (instancetype)KSCategoryItemWithDictionary:(NSDictionary *)dictionary;

@end
