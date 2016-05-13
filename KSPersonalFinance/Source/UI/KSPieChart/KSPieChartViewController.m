//
//  KSPieChartViewController.m
//  KSPersonalFinance
//
//  Created by Serg Bla on 12.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSPieChartViewController.h"
#import "KSNumberViewController.h"

@interface KSPieChartViewController () <MCPieChartViewDelegate, MCPieChartViewDataSource>
@property (nonatomic, weak) KSNumberViewController *numberViewController;

@end

@implementation KSPieChartViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pieChartView.dataSource = self;
    self.pieChartView.delegate = self;
    self.pieChartView.animationDuration = 0.5;
    self.pieChartView.sliceColor = [MCUtil flatWetAsphaltColor];
    self.pieChartView.borderColor = [MCUtil flatSunFlowerColor];
    self.pieChartView.selectedSliceColor = [MCUtil flatSunFlowerColor];
    self.pieChartView.textColor = [MCUtil flatSunFlowerColor];
    self.pieChartView.selectedTextColor = [MCUtil flatWetAsphaltColor];
    self.pieChartView.borderPercentage = 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSlicesInPieChartView:(MCPieChartView*)pieChartView {
    return 3;
}

- (CGFloat)pieChartView:(MCPieChartView*)pieChartView valueForSliceAtIndex:(NSInteger)index {
    CGFloat value = 0.0;
    if (index % 3 == 0) {
        value = 15;
    }else if (index % 2 == 0 ) {
        value = 15;
    }else {
        value = 65;
    }
    
    return value;
}

@end
