//
//  KSPieChartTableViewCell.h
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 31.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSPieChartTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *categoryIcon;
@property (nonatomic, weak) IBOutlet UILabel     *categoryTitleLabel;
@property (nonatomic, weak) IBOutlet UILabel     *amountLabel;
@property (nonatomic, weak) IBOutlet UILabel     *percentLabel;

@end
