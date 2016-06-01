//
//  KSCategoryItemCollectionViewCell.m
//  KSPersonalFinance
//
//  Created by Serg Bla on 18.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSCategoryItemCollectionViewCell.h"
#import "KSCategory.h"

@implementation KSCategoryItemCollectionViewCell

#pragma mark - 
#pragma mark Accessors

- (void)setImageFromCategory:(KSCategory *)category {
    _categoryImageView.image = [UIImage imageNamed:category.imageName];
}



@end
