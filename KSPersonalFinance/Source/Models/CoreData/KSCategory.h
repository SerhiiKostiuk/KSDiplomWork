//
//  KSCategory.h
//  KSPersonalFinance
//
//  Created by Serg Bla on 20.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KSTransaction;

@interface KSCategory : NSManagedObject
@property (nonatomic, strong) NSString      *categoryName;
@property (nonatomic, strong) KSTransaction *transaction;
@property (nonatomic, strong) NSString      *categoryImage;

@end

