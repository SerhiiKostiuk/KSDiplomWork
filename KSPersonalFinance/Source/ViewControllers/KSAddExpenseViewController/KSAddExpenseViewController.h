//
//  KSAddExpenseViewController.h
//  KSPersonalFinance
//
//  Created by Serg Bla on 25.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KSCategoryViewController.h"


@interface KSAddExpenseViewController : UIViewController <CategorySelectionDelegate>
@property (strong, nonatomic) IBOutlet UIView *addExpenseView;

@property (nonatomic, weak)   id <CategorySelectionDelegate> delegate;

@end
