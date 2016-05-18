//
//  KSExpenceViewController.h
//  KSPersonalFinance
//
//  Created by Serg Bla on 15.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TransactionType) {
    TransactionTypeExpense,
    TransactionTypeIncome
};

@protocol CategorySelectionDelegate <NSObject>

-(void)selectedCategory:(id)category;

@end

@interface KSExpenseViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) id <CategorySelectionDelegate> delegate;
@property (nonatomic) TransactionType categoryType;


@end
