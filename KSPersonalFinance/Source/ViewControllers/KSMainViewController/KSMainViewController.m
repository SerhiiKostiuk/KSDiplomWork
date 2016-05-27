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


#import "KSMacro.h"
#import "KSPreloadData.h"
#import "FSCalendar.h"

KSConstNSInteger(kKSDotButtonTag, -10);
KSConstNSInteger(kKSDeleteButtonTag, -1);

KSConstString(kKSYesAlertTitle, @"Yes");
KSConstString(kKSNoAlertTitle,  @"No");

@interface KSMainViewController () <UIScrollViewDelegate, UITextFieldDelegate, CategorySelectionDelegate>
@property (weak, nonatomic) IBOutlet UITextField   *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveAmountButton;
@property (weak, nonatomic) IBOutlet FSCalendar *calendarView;

@property (nonatomic, assign) NSUInteger               amount;
@property (nonatomic, strong) KSCategoryViewController *categorySelectionVC;
@property (nonatomic, strong) KSCategory    *currentCategory;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomPosition;

@end

@implementation KSMainViewController

#pragma mark -
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inputTextField.delegate = self;
    BOOL isPreloaded = [[NSUserDefaults standardUserDefaults]boolForKey:@"KSPreloadCompleted"];
    if (!isPreloaded) {
        [self presentActivityIndicator];
    }
    self.bottomPosition.constant = -261;
    
    self.calendarView.firstWeekday = 2;
    self.calendarView.allowsMultipleSelection = YES;
    
//    NSArray *transations = [KSTransaction MR_findAll];
//    CGFloat sum = 0.f;
//    for (KSTransaction *aTransaction in transations) {
//        sum += [aTransaction.amount floatValue];
//    }
//    NSLog(@"%f", sum);
}

-(void)hideNumpadView:(BOOL)hide {
    self.bottomPosition.constant = hide ? -261 : 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

    [self getBalance];
}

- (void)selectedCategory:(id)category {
    self.bottomPosition.constant = 0;
    [UIView animateWithDuration:1.f animations:^{
        [self.view layoutIfNeeded];
    }];
    self.currentCategory = category;
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
        if (currentText.length != 0) {
            NSString *updatedTextFieldString = [currentText substringToIndex:currentText.length - 1];
            
            self.inputTextField.text = updatedTextFieldString;
        }
    }
}

- (IBAction)numberTapped:(UIButton *)sender {
    [self appendInputWithString:sender.titleLabel.text];
}

- (IBAction)saveAmount:(id)sender {
    if (self.inputTextField.text.length > 0 ) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            KSTransaction *transaction = [KSTransaction MR_createEntityInContext:localContext];
            
            transaction.category = [self.currentCategory MR_inContext:localContext];
            
            transaction.time = [NSDate date];
            transaction.amount = @([self getInputValue]);
        }];
        
        [self.calendarView selectDate:[NSDate date]];
        
        [self hideNumpadView:YES];
    } else {
        [self presentAlertView];
    }
   
}

- (IBAction)cancelSavingAmount:(id)sender {
    [self hideNumpadView:YES];
}


#pragma mark -
#pragma mark Private

- (void)presentActivityIndicator {
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    
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
#warning add assert
//            NSAssert(<#condition#>, <#desc, ...#>)
        }
    }];
}

- (void)preloadCategoriesWithCompletion:(void(^)(BOOL success))completion {
    [KSPreloadData preloadTransactionsCategoriesWithType:TransactionTypeExpense completion:^(BOOL success) {
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

- (void)presentAlertView {
    UIAlertController * alert= [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"Enter Expense!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    [alert addAction:okAction];
}

- (UIColor *)colorFromType:(TransactionType)type {
    return type == TransactionTypeExpense ? [UIColor redColor ] : [UIColor  greenColor];
}

- (NSInteger)getBalance {
    NSManagedObjectContext *moc = [NSManagedObjectContext MR_context];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"KSTransaction"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    request.entity = entityDescription;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:YES];
    
    request.sortDescriptors = @[sortDescriptor];
    
    NSError *error;
    
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    NSInteger theSum = [[array valueForKeyPath:@"@sum.amount"] integerValue];
    return theSum;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[KSCategoryViewController class]]) {
        KSCategoryViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        self.categorySelectionVC = vc;
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.categorySelectionVC changeTransationType];
    UIColor *color = [self colorFromType:self.categorySelectionVC.categoryType];
    NSString *categoryName = [KSCategoryItem stringFromType:self.categorySelectionVC.categoryType];
    textField.textColor = color;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:categoryName
                                                                      attributes:@{NSForegroundColorAttributeName: color}];
    
    return NO;
}

@end
