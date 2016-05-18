//
//  KSCategoryItemCollectionViewCell.h
//  KSPersonalFinance
//
//  Created by Serg Bla on 18.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSCategoryItem;

@interface KSCategoryItemCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UIImageView *categoryItemImageView;

- (void)setKSCategoryItem:(KSCategoryItem *)item;

@end
