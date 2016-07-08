//
//  KSCategoryViewController.m
//  KSPersonalFinance
//
//  Created by Serg Bla on 18.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSCategoryViewController.h"
#import "KSCategoryItemCollectionViewCell.h"
#import "KSMacro.h"
#import "KSCategory.h"
#import "KSWeakifyMacro.h"
#import "KSConstants.h"
#import "KSCoreDataManager.h"
#import "NSDate+Calendar.h"

KSConstString(kKSReusableCellName, @"KSCategoryItemCollectionViewCell");

@interface KSCategoryViewController ()
@property (nonatomic, strong) KSCategoryItemCollectionViewCell *collectionViewCell;

@property (nonatomic, strong) NSArray *categoryItems;
@property (nonatomic, strong) NSArray * todayCategoriesTransactions;

@property (nonatomic, readwrite) TransactionType    categoryType;

- (void)fetchCategoriesWithType:(TransactionType)type;
- (void)updateCategory;
- (void)startObservingNotification;
- (void)endObservingNotification;

@end

@implementation KSCategoryViewController

#pragma mark -
#pragma mark Initializations and Deallocations

- (void)dealloc {
    [self endObservingNotification];
}

#pragma mark -
#pragma mark ViewController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.categoryType = transactionTypeExpense;

    [self startObservingNotification];
    
    [self showTodayTransaction];
}

#pragma mark -
#pragma mark Accessors

- (void)setCategoryType:(TransactionType)categoryType {
    _categoryType = categoryType;
    [self updateCategory];
}

#pragma mark -
#pragma mark Public

- (void)changeTransactionType {
    self.categoryType = self.categoryType == transactionTypeExpense ? transactionTypeIncome : transactionTypeExpense;
    [self showTodayTransaction];
}

- (void)showTodayTransaction {
    NSDate *date = [NSDate date];
    
    NSDate *startDate = [NSDate dateWithYear:date.year month:date.month  day:date.day+1 hour:-21 minute:0 second:0];
    NSDate *endDate = [NSDate dateWithYear:date.year month:date.month day:date.day+1 hour:+3 minute:0 second:0];
    
    NSArray *dates = @[startDate, endDate];
    
    [KSCoreDataManager loadCategoriesTransactionSumWithType:self.categoryType betweenDates:dates withCompletionHandler:^(NSArray *categoriesItems, NSNumber *totalAmount) {
        self.todayCategoriesTransactions = categoriesItems;
    }];
}

#pragma mark -
#pragma mark Private

- (void)fetchCategoriesWithType:(TransactionType)type {
    NSNumber *categoryType = [NSNumber numberWithInteger:type];
    
    NSArray *categories = [KSCategory MR_findByAttribute:kKSTransactionTypeKey
                                               withValue:categoryType
                                              andOrderBy:kKSOrderKey
                                               ascending:YES];

    _categoryItems = categories;
}

- (void)updateCategory {
    [self fetchCategoriesWithType:self.categoryType];
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark Notification

- (void)startObservingNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    KSWeakify(self);
    id block = ^(NSNotification *note){
        KSStrongifyAndReturnIfNil(self);
        self.categoryType = transactionTypeExpense;
    };
    
    [center addObserverForName:kKSCompleteCategoriesPreload object:nil queue:nil usingBlock:block];
}

- (void)endObservingNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:nil object:nil];
}

#pragma mark -
#pragma mark CategorySelectionDelegate

- (void)selectedCategory:(id)category {
    if ([self.delegate respondsToSelector:@selector(selectedCategory:)]) {
        [self.delegate selectedCategory:category];
    }
}

#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KSCategoryItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kKSReusableCellName
                                                                                       forIndexPath:indexPath];
    [cell setTitleAndImageFromCategory:self.categoryItems[indexPath.row]];
    for (KSCategoryItem *item in self.todayCategoriesTransactions) {
        if (cell.collectionViewCellTitle.text == item.title) {
            cell.categorySumImageView.hidden = NO;
            cell.categorySumLabel.text = [item.amount stringValue];
        }
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryItems.count;
}

#pragma mark -
#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedCategory = self.categoryItems[indexPath.item];
    [self selectedCategory:selectedCategory];
}

@end
