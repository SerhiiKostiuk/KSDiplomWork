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

- (void)setImageFromCategory:(KSCategory *)category;

@end
