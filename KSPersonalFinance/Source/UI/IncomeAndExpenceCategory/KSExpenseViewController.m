//
//  KSExpenceViewController.m
//  KSPersonalFinance
//
//  Created by Serg Bla on 15.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSExpenseViewController.h"

@interface KSExpenseViewController ()

@property (nonatomic, strong) NSArray *categories;
@end

@implementation KSExpenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self presentExpenceType];
}

#pragma mark - 
#pragma mark Private 

- (void)presentExpenceType {
//    self.collectionView.backgroundColor=[UIColor yellowColor];

}

#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categories.count;
}

@end
