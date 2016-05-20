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

KSConstString(kKSReusableCellName, @"KSCategoryItemCollectionViewCell");

@interface KSCategoryViewController ()
@property (nonatomic, weak)   IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong)    NSArray              *categoryItems;
@property (nonatomic, readwrite) TransactionType      categoryType;

@end

@implementation KSCategoryViewController

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.categoryType = TransactionTypeExpense;
}

#pragma mark -
#pragma mark Private

- (void)initCategoryItemsPathForResource:(NSString *)name {
    NSMutableArray *items = [NSMutableArray array];
    
    NSString *inputFile  = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSArray *inputDataArray = [NSArray arrayWithContentsOfFile:inputFile];
    
    for (NSDictionary *inputItem in inputDataArray) {
        [items addObject:[KSCategoryItem KSCategoryItemWithDictionary:inputItem]];
    }
    
    _categoryItems = items;
}

- (void)setCategoryType:(TransactionType)categoryType {
    _categoryType = categoryType;
    [self updateCategory];
}

- (void)updateCategory {
    NSString *nameOfFile = [self nameOfFileForTransactionType:self.categoryType];
    [self initCategoryItemsPathForResource:nameOfFile];
    [self.collectionView reloadData];
}

- (void)changeTransationType {
    self.categoryType = self.categoryType == TransactionTypeExpense ? TransactionTypeIncome : TransactionTypeExpense;
}

- (NSString *)nameOfFileForTransactionType:(TransactionType)type {
    return type == TransactionTypeIncome ? @"income" : @"expense";
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

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KSCategoryItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kKSReusableCellName
                                                                                       forIndexPath:indexPath];
    
    [cell setKSCategoryItem:self.categoryItems[indexPath.row]];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryItems.count;
}

#pragma mark -
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedCategoty = self.categoryItems[indexPath.item];
    [self selectedCategory:selectedCategoty];
}

@end
