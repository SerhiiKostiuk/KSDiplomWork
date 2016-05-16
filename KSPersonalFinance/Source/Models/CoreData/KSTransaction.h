//
//  KSTransaction.h
//  KSPersonalFinance
//
//  Created by Serg Bla on 17.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface KSTransaction : NSManagedObject
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSDate   *time;

@end

