//
//  KSMainViewController.m
//  KSPersonalFinance
//
//  Created by Serg Bla on 11.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSMainViewController.h"

#import "DGActivityIndicatorView.h"

#import "KSTransaction.h"
#import "KSCategoryViewController.h"
#import "KSCategoryItem.h"
#import "KSCategory.h"
#import "KSConstants.h"
#import "KSActivityIndicator.h"

#import "KSMacro.h"
#import "KSCoreDataManager.h"
#import "FSCalendar.h"

#import "UIViewController+KSExtensions.h"
#import "UIColor+KSExtensions.h"
#import "NSString+KSExtensions.h"

@interface KSMainViewController () <UIScrollViewDelegate, UITextFieldDelegate, CategorySelectionDelegate>
@property (nonatomic, weak) IBOutlet UITextField  *inputTextField;
@property (nonatomic, weak) IBOutlet UIButton     *saveAmountButton;
@property (nonatomic, weak) IBOutlet FSCalendar   *calendarView;
@property (nonatomic, weak) IBOutlet UIButton     *changeTransactionType;
@property (nonatomic, weak) IBOutlet UIView       *numpadView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numpadLeading;

@property (nonatomic, strong) KSActivityIndicator      *activityIndicator;
@property (nonatomic, strong) KSCategoryViewController *categorySelectionVC;
@property (nonatomic, strong) KSCategory               *currentCategory;

@property (nonatomic, assign) NSUInteger               amount;

- (void)presentActivityIndicator;
- (void)hideNumpadView:(BOOL)hide animated:(BOOL)animated;
- (void)preloadCategoriesWithCompletion:(void(^)(BOOL success))completion;
- (void)appendInputWithString:(NSString *)stringToAppend;
- (BOOL)isDotExist;
- (CGFloat)getInputValue;





@end

@implementation KSMainViewController

#pragma mark -
#pragma mark ViewContoller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inputTextField.delegate = self;
    
    BOOL isPreloaded = [[NSUserDefaults standardUserDefaults]boolForKey:kKSCompleteCategoriesPreload];
    if (!isPreloaded) {
        [self presentActivityIndicator];
    }
    
    [self hideNumpadView:YES animated:NO];
    
    self.calendarView.firstWeekday = 2;
    self.calendarView.allowsMultipleSelection = YES;    
}

#pragma mark -
#pragma mark Interface Handling

- (IBAction)dotSignTapped:(UIButton *)sender {
    if (sender.tag == kKSDotButtonTag) {
        if (![self isDotExist])
            [self appendInputWithString:sender.titleLabel.text];
    }
}

- (IBAction)deleteSignTapped:(UIButton *)sender {
    NSString *currentText = self.inputTextField.text;

    if (sender.tag == kKSDeleteButtonTag) {
        if (currentText.length != kKSZeroSign) {
            NSString *updatedTextFieldString = [currentText substringToIndex:currentText.length - 1];
            
            self.inputTextField.text = updatedTextFieldString;
        }
    }
}

- (IBAction)numberTapped:(UIButton *)sender {
    [self appendInputWithString:sender.titleLabel.text];
}

- (IBAction)saveAmount:(id)sender {
    if (self.inputTextField.text.length > kKSZeroSign) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            KSTransaction *transaction = [KSTransaction MR_createEntityInContext:localContext];
            
            transaction.category = [self.currentCategory MR_inContext:localContext];
            
            transaction.time = [NSDate date];
            transaction.amount = @([self getInputValue]);
        }];
        
#warning how to save selection of trancaction 
        [self.calendarView selectDate:[NSDate date]];
        self.inputTextField.text = @"";
        
        [self hideNumpadView:YES animated:YES];
        
//        self.categorySelectionVC.categorySumLabel.text = [KSCategoryItem.amount];
        
    } else {
        [self presentAlertView];
    }
}

- (IBAction)cancelSavingAmount:(id)sender {
    [self hideNumpadView:YES animated:YES];
}

- (IBAction)changeTransactionType:(id)sender {
    [self.categorySelectionVC changeTransactionType];
}

#pragma mark -
#pragma mark Private

- (void)presentActivityIndicator {
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(kKSZeroSign, kKSZeroSign, viewSize.width, viewSize.height)];
    
    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc]
                                                      initWithType:DGActivityIndicatorAnimationTypeBallTrianglePath
                                                      tintColor:[UIColor redColor]
                                                      size:20.0f];
    
    activityIndicatorView.frame = CGRectMake(viewSize.width/2 - 25.0f, viewSize.height/2 - 25.0f, 50.0f, 50.0f);
    
    activityView.backgroundColor = [UIColor blackColor];
    activityView.alpha = 0.6;
    
    [activityView addSubview:activityIndicatorView];
    [self.view addSubview:activityView];
    [activityIndicatorView startAnimating];
    [self preloadCategoriesWithCompletion:^(BOOL success) {
        
        if (success) {
            sleep(3);
            [activityView removeFromSuperview];
            
        } else {
            NSAssert(success = NO, @"preload failed");
        }
    }];
}

- (void)hideNumpadView:(BOOL)hide animated:(BOOL)animated {
    CGFloat screenWigth = [UIScreen mainScreen].bounds.size.width;
    self.numpadLeading.constant = hide ? screenWigth : kKSZeroSign;
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)preloadCategoriesWithCompletion:(void(^)(BOOL success))completion {
    [KSCoreDataManager preloadTransactionsCategoriesWithType:transactionTypeExpense completion:^(BOOL success) {
        completion(success);
    }];
}

- (void)appendInputWithString:(NSString *)stringToAppend {
    self.inputTextField.text = [self.inputTextField.text stringByAppendingString:stringToAppend];
}

- (BOOL)isDotExist {
    return [self.inputTextField.text rangeOfString:@"."].location != NSNotFound;
}

- (CGFloat)getInputValue {
    return [self.inputTextField.text floatValue];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[KSCategoryViewController class]]) {
        KSCategoryViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        self.categorySelectionVC = vc;
    }
}

#pragma mark -
#pragma mark CategorySelectionDelegate

- (void)selectedCategory:(id)category {
    [self hideNumpadView:NO animated:YES];
    
    [UIView animateWithDuration:0.6f animations:^{
        [self.view layoutIfNeeded];
    }];
    
    self.currentCategory = category;
}

#pragma mark -
#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.categorySelectionVC changeTransactionType];
    UIColor *color = [UIColor colorFromType:self.categorySelectionVC.categoryType];
    NSString *categoryName = [NSString stringFromType:self.categorySelectionVC.categoryType];
    textField.textColor = color;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:categoryName
                                                                      attributes:@{NSForegroundColorAttributeName: color}];
    
    return NO;
}

@end
