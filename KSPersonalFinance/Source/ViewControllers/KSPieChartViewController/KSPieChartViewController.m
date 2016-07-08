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
#import "HSDatePickerViewController.h"
#import "KSYearPickerViewController.h"

#import "UIViewController+KSExtensions.h"
#import "NSArray+KSExtensions.h"
#import "NSDate+Calendar.h"
#import "CDatePickerViewEx.h"

#import "KSPersonalFinance-Swift.h"

KSConstString(kKSCellIdentifier, @"KSPieChartTableViewCell");
KSConstString(kKSBackButtonImageName, @"back_");

typedef void(^FetchCompletionHandler)(NSArray *fetchedCategories, NSNumber *totalAmount);

typedef NS_ENUM(NSUInteger, ShowBy) {
    ShowByDay,
    ShowByMonth,
    ShowByYear
};

@interface KSPieChartViewController () <UITableViewDataSource, UITableViewDelegate, HSDatePickerViewControllerDelegate, KSYearPickerViewControllerDelegate>
@property (nonatomic, weak) IBOutlet PieChartView       *pieChartView;
@property (nonatomic, weak) IBOutlet UITableView        *tableView;
@property (nonatomic, weak) IBOutlet UILabel            *transactionSumLabel;
@property (nonatomic, weak) IBOutlet UIButton           *selectDateButton;
@property (nonatomic, weak) IBOutlet UISegmentedControl *dateSegmentedContol;
@property (nonatomic, weak) IBOutlet UIButton           *categoryTypeButton;

@property (nonatomic, strong) KSCategoryViewController *categoryViewController;
@property (nonatomic, strong) CDatePickerViewEx         *monthAndYearPicker;

@property (nonatomic, strong) NSArray         *categories;
@property (nonatomic, strong) NSNumber        *totalAmount;
@property (nonatomic, strong) NSMutableArray  *years;
@property (nonatomic, strong) NSArray         *colors;

@property (nonatomic, readwrite) TransactionType    categoryType;

- (void)updateTransactionsDataBetweenDates:(NSArray *)dates;
- (NSString *)formatDate:(NSDate *)date;
- (NSArray *)selectCurrentDate:(ShowBy)type;
- (void)showDatePicker;
- (void)hideMonthYearPicker;
- (void)changeSelectDateButtonTitle:(NSDate *)selectedDate;
- (void)changeTransactionSumLabelTitle;
- (void)confirmDateSelection;
- (void)popViewContoller;
- (void)setPieChartData;
- (void)presentChartView;
- (void)configuratePieChartTableViewCell:(KSPieChartTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation KSPieChartViewController

#pragma mark -
#pragma mark ViewController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self popViewContoller];
    
    self.categoryType = transactionTypeExpense;
    
    self.dateSegmentedContol.selectedSegmentIndex = 1;
    [self showTransactionsByDates:[self selectCurrentDate:ShowByMonth]];
}

#pragma mark -
#pragma mark Interface Handling

- (IBAction)selectDateButtonPressed:(UIButton *)sender {
    switch (self.dateSegmentedContol.selectedSegmentIndex) {
        case ShowByDay:
        {
            HSDatePickerViewController *hsdpvc = [HSDatePickerViewController new];
            hsdpvc.delegate = self;
            [self presentViewController:hsdpvc animated:YES completion:nil];
        }
            break;
            
        case ShowByMonth:
            [self showDatePicker];
            
            break;
            
        case ShowByYear:
        {
            KSYearPickerViewController *picker = [KSYearPickerViewController new];
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

- (IBAction)indexChanged:(UISegmentedControl *)sender {
    [self showTransactionsByDates:[self selectCurrentDate:(ShowBy)self.dateSegmentedContol.selectedSegmentIndex]];
}

- (IBAction)changeCategoryTypeButton:(id)sender {
    self.categoryType = self.categoryType == transactionTypeExpense ? transactionTypeIncome : transactionTypeExpense;
    
    self.categoryTypeButton.selected = !self.categoryTypeButton.selected;
    
    [self showTransactionsByDates:[self selectCurrentDate:self.dateSegmentedContol.selectedSegmentIndex]];
}

#pragma mark -
#pragma mark Private 

- (void)updateTransactionsDataBetweenDates:(NSArray *)dates {
    [KSCoreDataManager loadCategoriesTransactionSumWithType:self.categoryType
                                               betweenDates:dates
                                      withCompletionHandler:^(NSArray *categoriesItems, NSNumber *totalAmount)
     {
         self.categories = categoriesItems;
         self.totalAmount = totalAmount;
    }];
    
    [self changeTransactionSumLabelTitle];
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

- (void)showTransactionsByDates:(NSArray *)dates {
    [self updateTransactionsDataBetweenDates:dates];
    
    [self changeSelectDateButtonTitle:[dates firstObject]];

    [self presentChartView];
}

- (NSArray *)selectCurrentDate:(ShowBy)type {
    NSDate *date = [NSDate date];
    NSArray *dates = nil;
    
    switch (type) {
        case ShowByDay:
        {
            NSDate *startDate = [NSDate dateWithYear:date.year month:date.month  day:date.day hour:-21 minute:0 second:0];
            NSDate *endDate = [NSDate dateWithYear:date.year month:date.month day:date.day hour:+3 minute:0 second:0];
            
            dates = @[startDate,endDate];
        }
            break;
            
        case ShowByMonth:
        {
            NSDate *startDate = [NSDate dateWithYear:date.year month:date.month  day:2 hour:-21 minute:0 second:0];
            NSDate *endDate = [NSDate dateWithYear:date.year month:date.month day:date.day+1 hour:+3 minute:0 second:0];

            dates = @[startDate,endDate];
        }
            break;
            
        case ShowByYear:
        {
            NSDate *startDate = [NSDate dateWithYear:date.year month:1  day:1 hour:0 minute:0 second:0];
            NSDate *endDate = [NSDate dateWithYear:date.year month:12 day:31 hour:0 minute:0 second:0];
            
            dates = @[startDate,endDate];
        }
            break;
            
        default :
            break;
    }
    
    return dates;
}

- (void)showDatePicker {
    CGRect pickerFrame = CGRectMake(40, 50, self.view.frame.size.width-2*40, 350);
    CDatePickerViewEx *datePicker = [[CDatePickerViewEx alloc] initWithFrame:pickerFrame];
    datePicker.layer.cornerRadius = 11.f;
    datePicker.backgroundColor = [UIColor lightGrayColor];
    datePicker.showsSelectionIndicator = YES;
    [self.view addSubview:datePicker];
    
    self.monthAndYearPicker = datePicker;
    [datePicker selectToday];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(hideMonthYearPicker)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"OK"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(confirmDateSelection)];
}

- (void)hideMonthYearPicker {
    [self.monthAndYearPicker removeFromSuperview];
    
    [self popViewContoller];
}

- (void)changeSelectDateButtonTitle:(NSDate *)selectedDate {
    [self.selectDateButton setTitle:[self formatDate:selectedDate] forState:UIControlStateNormal];
 
}

- (void)changeTransactionSumLabelTitle {
    self.transactionSumLabel.text = [NSString stringWithFormat:@"Всего потрачено: %@ грн", [self.totalAmount stringValue]];
}

- (void)confirmDateSelection {
    NSDate *selectedDate = self.monthAndYearPicker.date;
    
    NSDate *startDate = [NSDate dateWithYear:selectedDate.year month:selectedDate.month  day:1];
    NSDate *endDate = [NSDate dateWithYear:selectedDate.year month:selectedDate.month day:startDate.daysInMonth];
    
    NSArray *dates = @[startDate,endDate];
    
    [self showTransactionsByDates:dates];

    [self hideMonthYearPicker];
}

- (void)popViewContoller {
    UIImage *backImage = [UIImage imageNamed:kKSBackButtonImageName];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self.navigationController
                                                                            action:@selector(popViewControllerAnimated:)];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)setPieChartData {
    NSMutableArray *yValues = [[NSMutableArray alloc] init];
    
    NSArray *categories = self.categories;
    for (int i = 0; i < categories.count; i++) {
        KSCategoryItem * item = categories[i];
        
        [yValues addObject:[[BarChartDataEntry alloc] initWithValue:[item.amount doubleValue] xIndex:i]];
        PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithYVals:yValues label:nil];
        
        NSArray *colors = [NSArray colorsForCharts];
        dataSet.colors = colors;
        self.colors = colors;
        
        PieChartData *data = [[PieChartData alloc] initWithXVals:nil dataSet:dataSet];
        [data setValueTextColor:[UIColor colorWithRed:99/255.f green:121/255.f blue:209/255.f alpha:1.f]];
        
        _pieChartView.data = data;
    }
}

- (void)presentChartView {  
    if (self.categories.count > kKSZeroSign) {
        self.pieChartView.hidden = NO;
        [self setPieChartData];
        [self.tableView reloadData];
    } else {
        if ([self.navigationController.visibleViewController isKindOfClass:[KSYearPickerViewController class]]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
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
    
    UIColor *color = [self.colors objectAtIndex:indexPath.row];
    cell.backgroundColor = color;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSPieChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kKSCellIdentifier];
    
    [self configuratePieChartTableViewCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark -
#pragma mark HSDatePickerViewControllerDelegate

- (void)hsDatePickerPickedDate:(NSDate *)date {
    
    NSDate *startDate = [NSDate dateWithYear:date.year month:date.month  day:date.day hour:date.hour minute:date.minute second:0];
    NSDate *endDate   = [NSDate dateWithYear:date.year month:date.month day:date.day+1 hour:date.hour minute:date.minute second:0];
    
    NSArray *dates = [NSArray arrayWithObjects:startDate,endDate, nil];
    
    [self showTransactionsByDates:dates];
}

#pragma mark - 
#pragma mark KSYearPickerViewControllerDelegate

- (void)KSYearPickerSelectedDate:(NSDate *)date {
    
    NSDate *startDate = [NSDate dateWithYear:date.year month:date.month day:date.day+1];
    NSDate *endDate   = [NSDate dateWithYear:date.year+1 month:date.month day:date.day];
    
    NSArray *dates = [NSArray arrayWithObjects:startDate,endDate, nil];
    
    [self showTransactionsByDates:dates];

}

@end
