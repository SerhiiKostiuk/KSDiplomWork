//
//  KSTransaction+CoreDataProperties.h
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 26.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "KSTransaction.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSTransaction (CoreDataProperties)

@property (nonatomic, strong) NSNumber   *amount;
@property (nonatomic, strong) NSDate     *time;
@property (nonatomic, strong) KSCategory *category;

@end

NS_ASSUME_NONNULL_END
