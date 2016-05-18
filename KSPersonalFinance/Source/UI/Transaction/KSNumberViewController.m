//
//  KSNumberViewController.m
//  KSPersonalFinance
//
//  Created by Serg Bla on 11.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSNumberViewController.h"
#import "KSTransaction.h"
#import "KSExpenseViewController.h"

static const NSInteger minusButtonTag  = -10;
static const NSInteger deleteButtonTag = -1;

@interface KSNumberViewController () <UIScrollViewDelegate, CategorySelectionDelegate>

@property (weak, nonatomic) IBOutlet UITextField   *inputTextField;
@property (nonatomic, strong) NSArray *categories;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (nonatomic, strong) KSExpenseViewController *categorySelectionVC;

-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;

@end

@implementation KSNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
//    
//    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
//    self.categoryScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 2, 50);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    [self.transactionTypeButton setImage:[UIImage imageNamed:@"minus-symbol"] forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self getBalance];
}

//- (IBAction)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer {
//    NSLog(@"tapGesture");
//}

-(void)selectedCategory:(id)category{
    
}

- (IBAction)changeTransactionType:(id)sender {
    
    
}

- (IBAction)numberTapped:(UIButton *)sender {
    if (sender.tag == deleteButtonTag) {
        if (self.inputTextField.text.length != 0) {
            NSString *currentText = self.inputTextField.text;
            NSString *updatedTextFieldString = [currentText substringToIndex:currentText.length - 1];
            self.inputTextField.text = updatedTextFieldString;
        }
    } else {
        self.inputTextField.text = [self.inputTextField.text stringByAppendingString:sender.titleLabel.text];
    }
}

- (CGFloat)getInputValue{
    return [self.inputTextField.text floatValue];
}

#pragma mark -
#pragma mark Private

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

-(void)changeTransationType{
    TransactionType currentType = self.categorySelectionVC.categoryType;
    if (currentType == TransactionTypeExpense)
        currentType = TransactionTypeIncome;
    
    else
        currentType = TransactionTypeExpense;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowCharts"]) {
        
    }
    
    if ([segue.destinationViewController isKindOfClass:[KSExpenseViewController class]]) {
        KSExpenseViewController *vc = segue.destinationViewController;
        vc.delegate = self;
        vc.categoryType = TransactionTypeIncome;
        self.categorySelectionVC = vc;
    }
}

@end
