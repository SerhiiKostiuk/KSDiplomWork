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
#import "VBPieChart.h"
#import "HSDatePickerViewController.h"
#import "KSYearPickerViewController.h"



#import "UIViewController+KSExtensions.h"
#import "UIColor+KSExtensions.h"
#import "NSString+KSExtensions.h"
#import "NSDate+Calendar.h"
#import "CDatePickerViewEx.h"

typedef void(^FetchCompletionHandler)(NSArray *fetchedCategories, NSNumber *totalAmount);

typedef NS_ENUM(NSUInteger, ShowBy) {
    ShowByDay,
    ShowByMonth,
    ShowByYear
};

@interface KSPieChartViewController () <UITableViewDataSource, UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate, HSDatePickerViewControllerDelegate, KSYearPickerViewControllerDelegate>
@property (strong, nonatomic) IBOutlet VBPieChart         *pieChartView;
@property (nonatomic, weak) IBOutlet UITableView        *tableView;
@property (nonatomic, weak) IBOutlet UILabel            *transactionSumLabel;
@property (nonatomic, weak) IBOutlet UIButton           *selectDateButton;
@property (nonatomic, strong) CDatePickerViewEx         *monthAndYearPicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dateSegmentedContol;
//@property (nonatomic, strong) UIPickerView              *yearPickerView;


@property (nonatomic, strong) KSCategoryViewController *categoryViewController;

@property (nonatomic, strong) NSArray  *categories;
@property (nonatomic, strong) NSNumber *totalAmount;
@property (nonatomic, strong) NSDate   *dateToShow;
@property (nonatomic, strong) NSMutableArray  *years;

@end

@implementation KSPieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pieChartView.frame = CGRectMake(100, 50, 300, 300);
    
    [self popViewContoller];
    self.dateToShow = [NSDate date];
    self.dateSegmentedContol.selectedSegmentIndex = 1;
    [self showCurrentMonthTransactions];
   }

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)updateTransactionsDataBetweenDates:(NSArray *)dates {
    [KSCoreDataManager loadCategoriesTransactionSumWithType:1
                                               betweenDates:dates
                                      withCompletionHandler:^(NSArray *categoriesItems, NSNumber *totalAmount)
     {
         self.categories = categoriesItems;
         self.totalAmount = totalAmount;
    }];

    self.transactionSumLabel.text = [NSString stringWithFormat:@"Total : %@", [self.totalAmount stringValue]];
#warning put this in to seperate method --\/
        NSDate *currentDate = [NSDate date];
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMMM yyyy"];
        NSString *stringFromDate = [formatter stringFromDate:currentDate];
    
        [self.selectDateButton setTitle:stringFromDate forState:UIControlStateNormal];
}

- (IBAction)selectDateButtonPressed:(UIButton *)sender {
    switch (self.dateSegmentedContol.selectedSegmentIndex) {
        case ShowByDay: {
            HSDatePickerViewController *hsdpvc = [HSDatePickerViewController new];
            hsdpvc.delegate = self;
            [self presentViewController:hsdpvc animated:YES completion:nil];
            [self.selectDateButton setTitle:[self formatDate:_dateToShow] forState:UIControlStateNormal];
            
        }
            
            break;
            
        case ShowByMonth:
            [self showDatePicker];
            
            break;
            
        case ShowByYear:
        {
            KSYearPickerViewController *picker = [[KSYearPickerViewController alloc]init];
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:^{
                [picker selectToday];
            }];
            
        }
            
            break;
            
        default :
            
            break;
    }
    
}

- (NSString *)formatDate:(NSDate *)date {
    static NSDateFormatter *dayFormatter   = nil;
    static NSDateFormatter *monthFormatter = nil;
    static NSDateFormatter *yearFormatter  = nil;
    
    switch (self.dateSegmentedContol.selectedSegmentIndex) {
            case ShowByDay: {
                if (!dayFormatter) {
                    dayFormatter = [NSDateFormatter new];
                    [dayFormatter setDateFormat:@"d MMMM YYYY"];
                }
                return [dayFormatter stringFromDate:date];
            }
            case ShowByMonth: {
                if (!monthFormatter) {
                    monthFormatter = [NSDateFormatter new];
                    [monthFormatter setDateFormat:@"MMMM YYYY"];
                    
//                    [self setRuMonthSymbols:monthFormatter];
                }
                return [monthFormatter stringFromDate:date];
            }
            case ShowByYear: {
                if (!yearFormatter) {
                    yearFormatter = [NSDateFormatter new];
                    [yearFormatter setDateFormat:@"YYYY"];
                }
                return [yearFormatter stringFromDate:date];
            }
        default:
            break;
    }
    return nil;
}

- (IBAction)indexChanged:(UISegmentedControl *)sender {
    switch (self.dateSegmentedContol.selectedSegmentIndex) {
        case ShowByDay:
            [self showCurrentDayTransactions];
            
            break;
            
        case ShowByMonth:
            [self showCurrentMonthTransactions];
            
            break;
            
        case ShowByYear:
            break;
            
        default :
            
            break;
    }
}

- (void)showCurrentDayTransactions {
    [self updateTransactionsDataBetweenDates:[self selectCurrentDayDate]];
    
    [self presentChartView];
    
}

- (void)showCurrentMonthTransactions {  // make a switch case from this method
    [self updateTransactionsDataBetweenDates:[self selectCurrentMonthDate]];
    
    [self presentChartView];
}

- (NSArray *)selectCurrentDayDate {
    NSDate *date = [NSDate date];
    
    NSDate *startDate = [NSDate dateWithYear:date.year month:date.month  day:date.day hour:-21 minute:0 second:0];
    NSDate *endDate = [NSDate dateWithYear:date.year month:date.month day:date.day hour:+3 minute:0 second:0];
    
    NSArray *dates = @[startDate,endDate];
    
    return dates;
}


- (NSArray *)selectCurrentMonthDate {
    NSDate *date = [NSDate date];
    
    NSDate *startDate = [NSDate dateWithYear:date.year month:date.month  day:2 hour:-21 minute:0 second:0];
    NSDate *endDate = [NSDate dateWithYear:date.year month:date.month day:date.day+1 hour:+3 minute:0 second:0];
    
    NSArray *dates = @[startDate,endDate];
    
    return dates;
}

- (void)showDatePicker {
    CGRect pickerFrame = CGRectMake(40, 50, self.view.frame.size.width-2*40, 350);
    CDatePickerViewEx *datePicker = [[CDatePickerViewEx alloc] initWithFrame:pickerFrame];
    datePicker.backgroundColor = [UIColor grayColor];
    datePicker.showsSelectionIndicator = YES;
    [self.view addSubview:datePicker];
    
    self.monthAndYearPicker = datePicker;
    [datePicker selectToday];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(hideMonthYearPicker)];
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStylePlain target:self action:@selector(confirmDateSelection)];
}

- (void)hideMonthYearPicker {
    [self.monthAndYearPicker removeFromSuperview];
    
    [self popViewContoller];
    
}

- (NSArray *)getDatesForLoadCategoriesData {
    NSArray *dates;
    
    switch (self.dateSegmentedContol.selectedSegmentIndex) {
            case ShowByDay: {
//                dates = [_dateToShow getStartAndEndDatesFromDate];
                break;
            }
            case ShowByMonth: {
                dates = [self selectCurrentMonthDate];
                break;
            }
            case ShowByYear: {
//                dates = [_dateToShow startAndEndDatesOfYear];
                break;
            }
        default:
            break;
    }
    
    return dates;
}

- (void)confirmDateSelection {
    NSDate *selectedDate = self.monthAndYearPicker.date;
    NSLog(@"%@", selectedDate);
    NSDate *startDate = [NSDate dateWithYear:selectedDate.year month:selectedDate.month  day:1];
    NSDate *endDate = [NSDate dateWithYear:selectedDate.year month:selectedDate.month day:startDate.daysInMonth];
    
    NSArray *dates = [NSArray arrayWithObjects:startDate,endDate, nil];
    
    [self updateTransactionsDataBetweenDates:dates];
    [self presentChartView];

    [self.selectDateButton setTitle:[self formatDate:selectedDate] forState:UIControlStateNormal];

    
    [self hideMonthYearPicker];
}

- (void)popViewContoller {
    UIImage *backImage = [UIImage imageNamed:@"back_"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage: backImage style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(popViewControllerAnimated:)];
    
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)presentChartView {
    self.pieChartView.startAngle = M_PI+M_PI_2;
    self.pieChartView.holeRadiusPrecent = 0.5;

        NSMutableArray *chartValues = [NSMutableArray array];
        
        for (KSCategoryItem *category in self.categories) {
            NSDictionary *chartValue = @{@"name":[category valueForKey:@"title"],
                                         @"value":[category valueForKey:@"amount"],
                                         @"color":[UIColor colorWithHexString:[category valueForKey:@"color"]]
                                         };
            
            [chartValues addObject:chartValue];
        }
    
    if (self.categories.count > 0) {
        self.pieChartView.hidden = NO;
        [self.pieChartView setChartValues:chartValues animation:YES];
        [self.tableView reloadData];
    } else {
        [self presentAlertViewWithMessage:kKSAlertNoTransactionsMessage];
        self.pieChartView.hidden = YES;
        [self.tableView reloadData];
    }
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

- (void)hsDatePickerPickedDate:(NSDate *)date {
    NSDate *startDate = [NSDate dateWithYear:date.year month:date.month  day:date.day hour:date.hour minute:date.minute second:0];
    NSDate *endDate = [NSDate dateWithYear:date.year month:date.month day:date.day+1 hour:date.hour minute:date.minute second:0];
    
    NSArray *dates = [NSArray arrayWithObjects:startDate,endDate, nil];
    
    [self updateTransactionsDataBetweenDates:dates];
    
    [self presentChartView];
}

- (void)KSYearPickerSelectedDate:(NSDate *)date {
    NSDate *startDate = [NSDate dateWithYear:date.year month:date.month day:date.day+1];
    NSDate *endDate = [NSDate dateWithYear:date.year+1 month:date.month day:date.day];
    
    NSArray *dates = [NSArray arrayWithObjects:startDate,endDate, nil];
    
    [self updateTransactionsDataBetweenDates:dates];
    
    [self presentChartView];
}


- (NSInteger)numberOfComponentsInPickerView: (UIPickerView*)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.years count];
}
- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.years objectAtIndex:row];
}

@end
