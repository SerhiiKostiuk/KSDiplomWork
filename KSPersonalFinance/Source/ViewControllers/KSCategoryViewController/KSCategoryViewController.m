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

KSConstString(kKSReusableCellName, @"KSCategoryItemCollectionViewCell");

@interface KSCategoryViewController ()
@property (nonatomic, weak)   IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong)    NSArray            *categoryItems;
@property (nonatomic, readwrite) transactionType    categoryType;

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

}

#pragma mark -
#pragma mark Accessors

- (void)setCategoryType:(transactionType)categoryType {
    _categoryType = categoryType;
    [self updateCategory];
}

#pragma mark -
#pragma mark Private

- (void)fetchCategoriesWithType:(transactionType)type {
    NSNumber *categoryType = [NSNumber numberWithInteger:type];
    
    NSArray *categories = [KSCategory MR_findByAttribute:kKSTransactionTypeKey withValue:categoryType];

    _categoryItems = categories;
}

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


- (void)updateCategory {
    [self fetchCategoriesWithType:self.categoryType];
    [self.collectionView reloadData];
}

- (void)changeTransactionType {
    self.categoryType = self.categoryType == transactionTypeExpense ? transactionTypeIncome : transactionTypeExpense;
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
//   set cell with image and title
#warning thange the method 
    [cell setImageFromCategory:self.categoryItems[indexPath.row]];
    
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
