//
//  KSCategoryItemCollectionViewCell.h
//  KSPersonalFinance
//
//  Created by Serg Bla on 18.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSCategory;

@interface KSCategoryItemCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *categorySumLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionViewCellTitle;
@property (weak, nonatomic) IBOutlet UIImageView *categorySumImageView;

- (void)setTitleAndImageFromCategory:(KSCategory *)category;

@end
