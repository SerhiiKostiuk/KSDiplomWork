//
//  KSCategory+CoreDataProperties.h
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 26.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "KSCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSCategory (CoreDataProperties)

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSNumber *transactionType;

@property (nonatomic, strong) NSSet<KSTransaction *> *transactions;

@end

@interface KSCategory (CoreDataGeneratedAccessors)

- (void)addTransactionsObject:(KSTransaction *)value;
- (void)removeTransactionsObject:(KSTransaction *)value;
- (void)addTransactions:(NSSet<KSTransaction *> *)values;
- (void)removeTransactions:(NSSet<KSTransaction *> *)values;

@end

NS_ASSUME_NONNULL_END
