//
//  KSExpenceViewController.m
//  KSPersonalFinance
//
//  Created by Serg Bla on 15.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSExpenceViewController.h"

@interface KSExpenceViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) NSArray *categories;

@end

@implementation KSExpenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self presentExpenceType];
}

#pragma mark - 
#pragma mark Private 

- (void)presentExpenceType {
    self.collectionView.backgroundColor=[UIColor darkGrayColor];

}

#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categories.count;
}

@end
