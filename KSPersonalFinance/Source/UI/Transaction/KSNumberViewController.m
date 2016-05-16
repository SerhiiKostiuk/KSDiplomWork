//
//  KSNumberViewController.m
//  KSPersonalFinance
//
//  Created by Serg Bla on 11.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSNumberViewController.h"
#import "KSTransaction.h"


static const NSInteger minusButtonTag  = -10;
static const NSInteger deleteButtonTag = -1;

@interface KSNumberViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField   *inputTextField;
@property (weak, nonatomic) IBOutlet UIScrollView  *categoryScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *scrollViewPager;
@property (weak, nonatomic) IBOutlet UICollectionView *categoryOfExpence;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic) NSIndexPath* selectedIndex;

@end

@implementation KSNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.categoryScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 2, 50);
}
- (IBAction)categorySelect:(id)sender {
    [self presentAlertView];
    
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


//-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSInteger currentPage  = scrollView.contentOffset.x / scrollView.frame.size.width;
//    self.scrollViewPager.currentPage = currentPage;
//}

#pragma mark -
#pragma mark Private

- (void)presentAlertView {
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Info"
                                  message:@"You are using UIAlertController"
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     
                                     NSManagedObjectContext *moc = [NSManagedObjectContext MR_context];
                                     
                                     KSTransaction *transaction = [NSEntityDescription insertNewObjectForEntityForName:@"KSTransaction"                                                     inManagedObjectContext:moc];
                                     
                                     
                                     transaction.time = [NSDate date];
                                     transaction.amount = [NSNumber numberWithInteger:self.amount];
                                     transaction.category = self.categories[self.selectedIndex.item];
                                 }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     
                                     [self.navigationController popViewControllerAnimated:YES];
                                 }];

    [self presentViewController:alert animated:YES completion:nil];

    [alert addAction:cancelAction];
    [alert addAction:saveAction];
   
}


@end
