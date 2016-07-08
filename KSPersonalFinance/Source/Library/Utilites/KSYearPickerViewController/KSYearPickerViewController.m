//
//  KSYearPicketView.m
//  KSPersonalFinance
//
//  Created by Сергій Костюк on 13.06.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSYearPickerViewController.h"


@interface KSYearPickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *years;
@property (nonatomic, strong) NSIndexPath *todayIndexPath;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;


@end

@implementation KSYearPickerViewController

- (instancetype)init {
    if (self = [super init]) {
        [self loadDefaultsParameters];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    return self = [super initWithNibName:nibNameOrNil bundle:bundle];
}

- (NSDate *)date {
    NSInteger yearCount = self.years.count;
    NSString *year = [self.years objectAtIndex:([self.pickerView selectedRowInComponent:0] % yearCount)];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@", year]];
    return date;
}


- (NSArray *)nameOfYears {
    NSMutableArray  *years = [[NSMutableArray alloc] init];
    for (int i=2010; i<=2020; i++) {
        [years addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    return years;
}

- (NSString *)currentYearName {
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy"];
    return [formatter stringFromDate:[NSDate date]];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.years.count;

}

- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSInteger yearCount = self.years.count;
    return [self.years objectAtIndex:(row % yearCount)];
}

- (UIView *)pickerView: (UIPickerView *)pickerView
            viewForRow: (NSInteger)row
          forComponent: (NSInteger)component
           reusingView: (UIView *)view
{
    BOOL selected = NO;
  
    NSString *yearName = [self.years objectAtIndex:(row % self.years.count)];
    
    if([yearName isEqualToString:[self currentYearName]] == YES) {
        selected = YES;
    }
    
    UILabel *returnView  = [self labelForComponent:component];
    
    returnView.textColor = selected ? [UIColor blueColor] : [UIColor orangeColor];
    returnView.text = [self titleForRow:row forComponent:component];
    
    return returnView;
}


- (UILabel *)labelForComponent:(NSInteger)component {
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = NO;
    
    
    return label;
}

- (NSIndexPath *)todayPath {
    CGFloat row = 0.f;
    CGFloat section = 0.f;
    
    NSString *year  = [self currentYearName];
    
    for(NSString *cellYear in self.years) {
        if([cellYear isEqualToString:year]) {
            row = [self.years indexOfObject:cellYear];
            break;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}


- (void)selectToday {
    [self.pickerView selectRow: self.todayIndexPath.row
                   inComponent: 0
                      animated: NO];
}

 
- (void)loadDefaultsParameters {
    self.years = [self nameOfYears];
    self.todayIndexPath = [self todayPath];
    
}

- (IBAction)confirmDate:(id)sender {
    if ([self.delegate respondsToSelector:@selector(KSYearPickerSelectedDate:)]) {
        [self.delegate KSYearPickerSelectedDate:[self date]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
