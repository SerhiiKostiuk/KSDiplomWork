//
//  KSMainViewController.h
//  KSPersonalFinance
//
//  Created by Serg Bla on 11.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSMainViewController : UIViewController

- (void)preloadCategoriesWithCompletion:(void(^)(BOOL success))completion;

@end
