//
//  KSNumberViewController.m
//  KSPersonalFinance
//
//  Created by Serg Bla on 11.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSNumberViewController.h"

static const NSInteger minusButtonTag  = -10;
static const NSInteger deleteButtonTag = -1;

@interface KSNumberViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField   *inputTextField;
@property (weak, nonatomic) IBOutlet UIScrollView  *categoryScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *scrollViewPager;

@end

@implementation KSNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.categoryScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 2, 50);
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

-(CGFloat)getInputValue{
    return [self.inputTextField.text floatValue];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage  = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.scrollViewPager.currentPage = currentPage;
}

@end
