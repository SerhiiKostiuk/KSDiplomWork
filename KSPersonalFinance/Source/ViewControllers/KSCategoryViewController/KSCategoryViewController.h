//
//  KSCategoryViewController.h
//  KSPersonalFinance
//
//  Created by Serg Bla on 18.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSCategoryItem.h"


@protocol CategorySelectionDelegate <NSObject>

-(void)selectedCategory:(id)category;

@end

@interface KSCategoryViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak)   id <CategorySelectionDelegate> delegate;
@property (nonatomic, readonly) TransactionType           categoryType;


-(void)changeTransationType;

@end
