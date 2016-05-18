//
//  KSExpenceViewController.m
//  KSPersonalFinance
//
//  Created by Serg Bla on 15.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSExpenseViewController.h"
#import "KSCategoryItemCollectionViewCell.h"
#import "KSNumberViewController.h"
#import "KSCategoryItem.h"
#import "KSTransaction.h"

@interface KSExpenseViewController () <CategorySelectionDelegate>

@property (nonatomic, strong) NSArray *categoryItems;
@property (nonatomic, strong) NSIndexPath* selectedIndex;
@property (nonatomic, weak) KSNumberViewController *numberViewController;

@end

@implementation KSExpenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initCategoryItems];
//    [self presentExpenceType];
    
    [self.collectionView reloadData];
}

#pragma mark - 
#pragma mark Private 

- (void)presentExpenceType {
//    self.collectionView.backgroundColor=[UIColor yellowColor];

}

- (void)initCategoryItems {
    NSMutableArray *items = [NSMutableArray array];
    
    NSString *inputFile  = [[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"];
    NSArray *inputDataArray = [NSArray arrayWithContentsOfFile:inputFile];
    
    for (NSDictionary *inputItem in inputDataArray) {
        [items addObject:[KSCategoryItem KSCategoryItemWithDictionary:inputItem]];
    }
    
    _categoryItems = items;
}

- (void)presentAlertView {
    
    UIAlertController * alert= [UIAlertController alertControllerWithTitle:@"Info"
                                                                   message:@"You are using UIAlertController"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                                         KSTransaction *transaction = [KSTransaction MR_createEntityInContext:localContext];
                                         transaction.time = [NSDate date];
                                         transaction.amount = [NSNumber numberWithInteger:self.numberViewController.amount];
                                         transaction.category = self.categoryItems[self.selectedIndex.item];
                                     }];
                                 }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:saveAction];
    
}

- (void)selectedCategory:(id)category {
    
}

#pragma mark -
#pragma mark UICollectionViewDataSource


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KSCategoryItemCollectionViewCell *cell = [collectionView
 dequeueReusableCellWithReuseIdentifier:@"KSCategoryItemCollectionViewCell" forIndexPath:indexPath];
    
    [cell setKSCategoryItem:self.categoryItems[indexPath.row]];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryItems.count;
}


#pragma mark -
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self presentAlertView];
}

- (IBAction)fudlfis:(id)sender {
    id category = @"fgjkfdhgjkld";
    if ([self.delegate respondsToSelector:@selector(selectedCategory:)]) {
        [self.delegate selectedCategory:category];
    }
}

-(void)setCategoryType:(TransactionType)categoryType{
    _categoryType = categoryType;
    [self updateCategory];
}

-(void)updateCategory{
    
    [self updateUI];
}

-(void)updateUI{
}

@end
