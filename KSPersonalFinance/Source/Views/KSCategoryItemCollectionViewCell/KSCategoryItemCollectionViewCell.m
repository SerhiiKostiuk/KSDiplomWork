//
//  KSCategoryItemCollectionViewCell.m
//  KSPersonalFinance
//
//  Created by Serg Bla on 18.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSCategoryItemCollectionViewCell.h"
#import "KSCategoryItem.h"

@implementation KSCategoryItemCollectionViewCell

#pragma mark - 
#pragma mark Accessors

- (void)setKSCategoryItem:(KSCategoryItem *)item {
    _categoryItemImageView.image = [UIImage imageNamed:item.categoryImage];
}

@end
