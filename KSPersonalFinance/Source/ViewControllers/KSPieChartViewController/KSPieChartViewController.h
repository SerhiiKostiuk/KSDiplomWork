//
//  KSPieChartViewController.h
//  KSPersonalFinance
//
//  Created by Serg Bla on 12.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VBPieChart.h"

@interface KSPieChartViewController : UIViewController
@property (weak, nonatomic) IBOutlet VBPieChart *pieChartView;

@end
