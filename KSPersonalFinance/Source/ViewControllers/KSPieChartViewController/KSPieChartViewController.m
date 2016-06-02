//
//  KSPieChartViewController.m
//  KSPersonalFinance
//
//  Created by Serg Bla on 12.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSPieChartViewController.h"
#import "KSCategoryViewController.h"
#import "KSPieChartTableViewCell.h"
#import "KSTransaction.h"
#import "KSCategory.h"
#import "KSCategoryItem.h"
#import "KSCoreDataManager.h"
#import "KSConstants.h"

#import "UIColor+KSExtensions.h"
#import "NSString+KSExtensions.h"


typedef void(^FetchCompletionHandler)(NSArray *fetchedCategories, NSNumber *totalAmount);

@interface KSPieChartViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) KSCategoryViewController *categoryViewController;
@property (nonatomic, strong) NSArray  *categories;
@property (nonatomic, strong) NSNumber *totalAmount;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation KSPieChartViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.categoryViewController = [[KSCategoryViewController alloc]initWithNibName:@"KSCategoryViewController" bundle:nil];
#warning knew to initialize viewContoller
    [self updateTransactionsData];
    
    [self presentChartView];
    
   }

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)updateTransactionsData {
    
    [KSCoreDataManager loadCategoriesTransactionSumWithType:1
                                      withCompletionHandler:^(NSArray *categoriesItems, NSNumber *totalAmount)
     {
         self.categories = categoriesItems;
         self.totalAmount = totalAmount;
    }];

}


- (void)presentChartView {
    VBPieChart *chart = [[VBPieChart alloc] initWithFrame:CGRectMake(10, 50, 300, 300)];
    chart.startAngle = M_PI+M_PI_2;
    chart.holeRadiusPrecent = 0.5;
    [self.view addSubview:chart];
    [chart setLabelsPosition:VBLabelsPositionNone];
    [chart setLabelBlock:^CGPoint( CALayer *layer, NSInteger index) {
        CGPoint p = CGPointMake(sin(-index/10.0*M_PI)*50+50, index*30);
        return p;
    }];
    NSMutableArray *chartValues = [NSMutableArray array];
    
    for (KSCategoryItem *category in self.categories) {
         NSDictionary *chartValue = @{@"name":[category valueForKey:@"title"],
                                      @"value":[category valueForKey:@"amount"],
                                      @"color":[UIColor colorWithHexString:[category valueForKey:@"color"]]
                                      };
        
        [chartValues addObject:chartValue];
    }
   
    [chart setChartValues:chartValues animation:YES];
}

- (void)configuratePieChartTableViewCell:(KSPieChartTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    KSCategoryItem *category = self.categories[(NSUInteger)indexPath.row];
    cell.categoryTitleLabel.text = category.title;
    cell.amountLabel.text = [category.amount stringValue];
    cell.categoryIcon.image = [UIImage imageNamed:category.imageName];
    cell.backgroundColor = [UIColor colorWithHexString:category.color];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSPieChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KSPieChartTableViewCell"];
    
    [self configuratePieChartTableViewCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

@end
