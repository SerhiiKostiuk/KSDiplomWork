//
//  KSYearPicketView.h
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 13.06.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSYearPickerView : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

-(void)selectToday;

@end
