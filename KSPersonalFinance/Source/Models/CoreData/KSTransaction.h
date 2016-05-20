//
//  KSTransaction.h
//  KSPersonalFinance
//
//  Created by Serg Bla on 20.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KSCategory;

@interface KSTransaction : NSManagedObject
@property (nonatomic, strong) NSNumber   *amount;
@property (nonatomic, strong) NSDate     *time;
@property (nonatomic, strong) KSCategory *category;

@end

