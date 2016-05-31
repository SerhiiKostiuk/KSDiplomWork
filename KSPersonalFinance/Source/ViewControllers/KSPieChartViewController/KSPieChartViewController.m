//
//  KSPieChartViewController.m
//  KSPersonalFinance
//
//  Created by Serg Bla on 12.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#import "KSPieChartViewController.h"
#import "KSMainViewController.h"
#import "KSTransaction.h"
#import "KSCategory.h"
#import "KSCategoryItem.h"

typedef void(^FetchCompletionHandler)(NSArray *fetchedCategories, NSNumber *totalAmount);

@interface KSPieChartViewController ()
@property (nonatomic, weak) KSMainViewController *numberViewController;
@property (nonatomic, strong) NSMutableArray *categories;

@end

@implementation KSPieChartViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self class] loadCategoriesInfoInContext];
    
    [self presentChartView];
    
   }

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

//- (void)updateTransactionsData {
//    NSArray *dates = [self getDatesForLoadCategoriesData];
//    
//    __weak PieChartTableViewController *weakSelf = self;
//    
//    [Fetch loadCategoriesInfoInContext:_managedObjectContext betweenDates:dates withCompletionHandler:^(NSArray *fetchedCategories, NSNumber *totalAmount) {
//        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(amount)) ascending:NO];
//        NSMutableArray *sortedCategories = [[fetchedCategories sortedArrayUsingDescriptors:@[sortDescriptor]]mutableCopy];
//        
//        [weakSelf removeCategoriesWithoutTransactionsFrom:sortedCategories];
//        
//        _categoriesInfo = sortedCategories;
//        _totalAmount = totalAmount;
//    }];
//}


+ (void)loadCategoriesInfoInContext { // withCompletionHandler:(FetchCompletionHandler)completionHandler {

    NSNumber *number = [NSNumber numberWithInteger:1];
    NSArray *fetchedCategories = [KSCategory MR_findByAttribute:@"categoryType" withValue:number];
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    for (KSCategory *category in fetchedCategories) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category.categoryName = %@",category.categoryName];
//        NSArray *arr = [KSTransaction MR_findAllWithPredicate:predicate];
//        NSLog(@"%@", arr);
        NSNumber *careerTotal = [KSTransaction MR_aggregateOperation:@"sum:" onAttribute:@"amount" withPredicate:predicate];
                NSLog(@"%@", careerTotal);
        
        [mutableArray addObject:@{
                                  @"total" : careerTotal,
                                  @"category" : category.categoryName
                                  }];
    }
   
}

//    NSAssert(dates.count == 2, @"Number of dates must be 2");
//    NSAssert(managedObjectContext != nil, @"NSManagedObjectContext must be not nil");
//    
//    NSArray *fetchedCategories = [self getObjectsWithEntity:NSStringFromClass([CategoryData class]) predicate:nil context:managedObjectContext sortKey:NSStringFromSelector(@selector(idValue))];



//
//    NSMutableArray *categoriesInfo = [NSMutableArray arrayWithCapacity:[fetchedCategories count]];
//    
//    //Create array of categories infos
//    for (KSCategory *category in fetchedCategories) {
//        KSCategoryItem *info = [[KSCategoryItem alloc]initWithTitle:category.title iconName:category.iconName idValue:category.idValue andAmount:@0];
//        
//        [categoriesInfo addObject:info];
//    }
//    
//    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([CategoryData class])];
//    [fetchRequest setRelationshipKeyPathsForPrefetching:@[NSStringFromSelector(@selector(expense))]];
//    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(SUBQUERY(expense, $x, ($x.dateOfExpense >= %@) AND ($x.dateOfExpense <= %@)).@count > 0)", [dates firstObject], [dates lastObject]];
//    
//    NSArray *categories = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
//    
//    float __block countForTotalAmount = 0.0f;
//    
//    for (CategoryData *category in categories) {
//        [categoriesInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            CategoriesInfo *anInfo = obj;
//            if (category.idValue == anInfo.idValue) {
//                for (ExpenseData *expense in category.expense) {
//                    if ([expense.dateOfExpense compare:[dates firstObject]] != NSOrderedAscending &&
//                        [expense.dateOfExpense compare:[dates lastObject]]  != NSOrderedDescending) {
//                        anInfo.amount = @([anInfo.amount floatValue] + [expense.amount floatValue]);
//                        countForTotalAmount += [expense.amount floatValue];
//                    }
//                    [managedObjectContext refreshObject:expense mergeChanges:NO];
//                }
//                *stop = YES;
//            }
//        }];
//    }
//    
//    if (completionHandler) {
//        completionHandler([categoriesInfo copy], @(countForTotalAmount));
//    }
//}


- (void)presentChartView {
    VBPieChart *chart = [[VBPieChart alloc] initWithFrame:CGRectMake(10, 50, 300, 300)];
    chart.startAngle = M_PI+M_PI_2;
    chart.holeRadiusPrecent = 0.5;
    [self.view addSubview:chart];
    [chart setLabelsPosition:VBLabelsPositionCustom];
    [chart setLabelBlock:^CGPoint( CALayer *layer, NSInteger index) {
        CGPoint p = CGPointMake(sin(-index/10.0*M_PI)*50+50, index*30);
        return p;
    }];
    
    [chart setChartValues:@[
                            @{@"name":@"37%", @"value":@65, @"color":@"#5677fcaa", @"labelColor":@"#000"},
                            @{@"name":@"13%", @"value":@23, @"color":@"#2baf2baa", @"labelColor":@"#000"},
                            @{@"name":@"19.3%", @"value":@34, @"color":@"#b0bec5aa", @"labelColor":@"#000"},
                            @{@"name":@"30.7%", @"value":@54, @"color":@"#f57c00aa", @"labelColor":@"#000"}
                            ]
                animation:YES];
}

@end
