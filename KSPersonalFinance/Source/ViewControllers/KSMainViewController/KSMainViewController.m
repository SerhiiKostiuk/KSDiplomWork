//
//  KSMainViewController.m
//  KSPersonalFinance
//
//  Created by Serg Bla on 11.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSMainViewController.h"
#import "KSTransaction.h"
#import "KSCategoryViewController.h"
#import "KSCategoryItem.h"
#import "KSCategory.h"

#import "KSMacro.h"

KSConstNSInteger(kKSDotButtonTag, -10);
KSConstNSInteger(kKSDeleteButtonTag, -1);

KSConstString(kKSYesAlertTitle, @"Yes");
KSConstString(kKSNoAlertTitle,  @"No");

@interface KSMainViewController () <UIScrollViewDelegate, UITextFieldDelegate, CategorySelectionDelegate>
@property (weak, nonatomic) IBOutlet UITextField   *inputTextField;

@property (nonatomic, assign) NSUInteger               amount;
@property (nonatomic, strong) KSCategoryViewController *categorySelectionVC;

@end

@implementation KSMainViewController

#pragma mark - 
#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inputTextField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self getBalance];
}

- (void)selectedCategory:(id)category {
    [self presentAlertView:category];
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

#pragma mark -
#pragma mark Private

- (void)appendInputWithString:(NSString *)stringToAppend {
    self.inputTextField.text = [self.inputTextField.text stringByAppendingString:stringToAppend];
}

- (BOOL)isDotExist {
    return [self.inputTextField.text rangeOfString:@"."].location != NSNotFound;
}

- (CGFloat)getInputValue {
    return [self.inputTextField.text floatValue];
}

- (void)presentAlertView:(id)category {
    UIAlertController * alert= [UIAlertController alertControllerWithTitle:nil
                                                                   message:@"Save Transaction ?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:kKSYesAlertTitle
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
                                         KSTransaction *transaction = [KSTransaction MR_createEntityInContext:localContext];
                                         
                                         transaction.time = [NSDate date];
                                         transaction.amount = @([self getInputValue]);
                                         transaction.category.categoryName = [category categoryName];
                                         NSLog(@"%@", transaction.description);
                                     }];
                                 }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:kKSNoAlertTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:saveAction];
    
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
    if ([segue.identifier isEqualToString:@"ShowCharts"]) {
        
    }
    
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
