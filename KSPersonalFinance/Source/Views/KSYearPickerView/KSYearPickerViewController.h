//
//  KSYearPicketView.h
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 13.06.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KSYearPickerViewControllerDelegate <NSObject>
/**
 *  This method is called when user touch confrim button.
 *
 *  @param date selected date
 */
- (void)KSYearPickerSelectedDate:(NSDate *)date;

@end

@interface KSYearPickerViewController : UIViewController

@property (nonatomic, weak) id <KSYearPickerViewControllerDelegate> delegate;

-(void)selectToday;

@end
