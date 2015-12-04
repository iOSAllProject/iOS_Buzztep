//
//  BuzzWhenVC.m
//  When_WhereVC
//
//  Created by Sanchit Thakur on 20/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BuzzWhenVC.h"
#import "BuzzProfileVC.h"
#import "BuzzWhoVC.h"
#import "BuzzWhereVC.h"
#import "AppDelegate.h"
#import "PickerView.h"

#import "Constant.h"
#import "Global.h"

@interface BuzzWhenVC ()

- (IBAction)nextVCAction:(id)sender;
- (IBAction)closeButton:(id)sender;
- (IBAction)whenAction:(id)sender;
- (IBAction)whereAction:(id)sender;
- (IBAction)whoAction:(id)sender;
- (IBAction)skipAction:(id)sender;

- (IBAction)monthAction:(id)sender;
- (IBAction)dayAction:(id)sender;
- (IBAction)yearAction:(id)sender;
- (IBAction)durationAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *monthButton;
@property (weak, nonatomic) IBOutlet UIButton *dayButton;
@property (weak, nonatomic) IBOutlet UIButton *yearButton;
@property (weak, nonatomic) IBOutlet UIButton *durationButton;
@property (weak, nonatomic) IBOutlet UIButton *durationImg;

@property (weak, nonatomic) IBOutlet UIButton *whenProperty;
@property (weak, nonatomic) IBOutlet UIButton *whereProperty;
@property (weak, nonatomic) IBOutlet UIButton *whoProperty;

@property (nonatomic, strong) NSArray *monthArray;
@property (nonatomic, strong) NSMutableArray *dayArray, *yearArray, * durationArray;
@property (nonatomic, strong) NSArray *objectsArray;
@property (nonatomic, strong) NSArray *numbersArray;
@property (nonatomic, assign) id selectedObject;
@property (nonatomic, strong) NSString *monthString, *dayString, *yearString, *durationString;;

- (NSInteger)MonthToIndex:(NSString* )month;
- (void)initUI;
- (void)animate;

@end

@implementation BuzzWhenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _monthButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 30);
    _dayButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 30);
    _yearButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 30);
    _durationButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 30);
    
    _monthArray = @[@"JANUARY", @"FEBRUARY", @"MARCH", @"APRIL", @"MAY",@"JUNE", @"JULY", @"AUGUST", @"SEPTEMBER", @"OCTOBER",@"NOVEMBER", @"DECEMBER"];
    
    _dayArray = [[NSMutableArray alloc] init];
    
    for (int i=1; i<=31; i++)
    {
        [_dayArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    _yearArray = [[NSMutableArray alloc] init];
    
    for (int j=2015; j<=2050; j++)
    {
        [_yearArray addObject:[NSString stringWithFormat:@"%d",j]];
    }
    
    _durationArray = [[NSMutableArray alloc] init];
    
    for (int k = 1; k <= 90 ; k ++)
    {
        [_durationArray addObject:[NSString stringWithFormat:@"%d", k ]];
    }
    
    _monthString = [_monthArray objectAtIndex:0];
    _dayString = [_dayArray objectAtIndex:0];
    _yearString=[_yearArray objectAtIndex:0];
    _durationString = [_durationArray objectAtIndex:0];
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    self.managedObjectContext = [delegate managedObjectContext];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self animate];
}

#pragma mark - IBActions

- (IBAction)nextVCAction:(id)sender
{
    NSString* dayStr = _dayButton.titleLabel.text;
    NSString* monthStr = _monthButton.titleLabel.text;
    NSString* yearStr = _yearButton.titleLabel.text;
    NSString* durationStr = _durationButton.titleLabel.text;
    
    if ([monthStr.uppercaseString isEqualToString:@"MONTH"])
    {
        [[AppDelegate SharedDelegate] ShowAlert:@"MONTH"
                                 messageContent:@"Select the month"];
        
        return;
    }
    
    if ([dayStr.uppercaseString isEqualToString:@"DAY"])
    {
        [[AppDelegate SharedDelegate] ShowAlert:ApplicationTile
                                 messageContent:@"Select the day"];
        
        return;
    }
    
    if ([yearStr.uppercaseString isEqualToString:@"YEAR"])
    {
        [[AppDelegate SharedDelegate] ShowAlert:ApplicationTile
                                 messageContent:@"Select the year"];
        
        return;
    }
    
    if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Adventure)
    {
        if ([durationStr.uppercaseString isEqualToString:@"DURATION"])
        {
            [[AppDelegate SharedDelegate] ShowAlert:ApplicationTile
                                     messageContent:@"Select the dutation"];
            
            return;
        }
        
        NSInteger yearVal = 0;
        NSInteger monthVal = 0;
        NSInteger dayVal = 0;
        NSInteger durationVal = 0;
        
        yearVal = [yearStr integerValue];
        monthVal = [self MonthToIndex:monthStr];
        dayVal = [dayStr integerValue];
        durationVal = [durationStr integerValue];
        
        NSString* startDate =
        [[AppDelegate SharedDelegate] CreateTimeWithYear:yearVal
                                                   Month:monthVal
                                                     Day:dayVal];
        
        [AppDelegate SharedDelegate].gAdventureModel.adventure_startDate = startDate;
        
        NSString* endDate =
        [[AppDelegate SharedDelegate] DurationTimeWithYear:yearVal
                                                     Month:monthVal
                                                       Day:dayVal
                                                 ExtraDays:durationVal];
        
        [AppDelegate SharedDelegate].gAdventureModel.adventure_endDate = endDate;
        
    }
    
    if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Event)
    {
        NSInteger yearVal = 0;
        NSInteger monthVal = 0;
        NSInteger dayVal = 0;
        
        yearVal = [yearStr integerValue];
        monthVal = [self MonthToIndex:monthStr];
        dayVal = [dayStr integerValue];
        
        NSString* scheduledDate =
                [[AppDelegate SharedDelegate] CreateTimeWithYear:yearVal
                                                           Month:monthVal
                                                             Day:dayVal];
        
        [AppDelegate SharedDelegate].gEventModel.event_scheduledDate = scheduledDate;        
    }
    
    BuzzWhoVC *buzzWho = [self.storyboard instantiateViewControllerWithIdentifier:@"buzzwho"];
    
    [self.navigationController pushViewController:buzzWho animated:YES];
    
    // create instance on NSManagedObect for buzzWhen
    
    NSManagedObject	*buzzWhen =
                    [NSEntityDescription insertNewObjectForEntityForName:@"Adventure"
                                                  inManagedObjectContext:_managedObjectContext];
    
    NSLog(@"buzzWhen objects are=%@", buzzWhen);
    
    NSError *error;
    
    // here’s where the actual save happens, and if it doesn’t we print something out to the console
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Problem saving: %@", [error localizedDescription]);
    }
}

- (IBAction)closeButton:(id)sender
{
    BuzzProfileVC *buzzProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
}

- (IBAction)whenAction:(id)sender
{    
    NSLog(@"When action clicked");
}

- (IBAction)whereAction:(id)sender
{
   [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)whoAction:(id)sender
{
    BuzzWhoVC *buzzProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"buzzwho"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
}

- (IBAction)skipAction:(id)sender
{
    BuzzWhoVC *buzzWho = [self.storyboard instantiateViewControllerWithIdentifier:@"buzzwho"];
    [self.navigationController pushViewController:buzzWho animated:YES];
}

- (IBAction)monthAction:(id)sender {
    
    [PickerView showPickerViewInView:self.view
                           withStrings:_monthArray
                           withOptions:@{
                                         backgroundColor: [UIColor whiteColor],
                                         textColor: [UIColor blackColor],
                                         toolbarColor: [UIColor whiteColor],
                                         buttonColor: [UIColor blueColor],
                                         font: [UIFont systemFontOfSize:18],
                                         valueY: @3,
                                         selectedObject:_monthString,
                                         textAlignment:@1
                                         }
                            completion:^(NSString *selectedString) {
                                
                               [_monthButton setTitle:selectedString forState:UIControlStateNormal];
                                _monthString = selectedString;
                            }];
   
    NSLog(@"month action");
    
   }

- (IBAction)dayAction:(id)sender
{
    [PickerView showPickerViewInView:self.view
                         withStrings:_dayArray
                         withOptions:@{
                                       backgroundColor: [UIColor whiteColor],
                                       textColor: [UIColor blackColor],
                                       toolbarColor: [UIColor whiteColor],
                                       buttonColor: [UIColor blueColor],
                                       font: [UIFont systemFontOfSize:18],
                                       valueY: @3,
                                       selectedObject:_dayString,
                                       textAlignment:@1
                                       }
                          completion:^(NSString *selectedString){
                               [_dayButton setTitle:selectedString forState:UIControlStateNormal];
                               _dayString = selectedString;
                          }];
    

   }

- (IBAction)yearAction:(id)sender
{
    [PickerView showPickerViewInView:self.view
                         withStrings:_yearArray
                         withOptions:@{
                                       backgroundColor: [UIColor whiteColor],
                                       textColor: [UIColor blackColor],
                                       toolbarColor: [UIColor whiteColor],
                                       buttonColor: [UIColor blueColor],
                                       font: [UIFont systemFontOfSize:18],
                                       valueY: @3,
                                       selectedObject:_yearString,
                                       textAlignment:@1
                                       }
                          completion:^(NSString *selectedString){
                               [_yearButton setTitle:selectedString forState:UIControlStateNormal];
                               _yearString = selectedString;
                          }];

}

- (IBAction)durationAction:(id)sender
{
    [PickerView showPickerViewInView:self.view
                         withStrings:_durationArray
                         withOptions:@{
                                       backgroundColor: [UIColor whiteColor],
                                       textColor: [UIColor blackColor],
                                       toolbarColor: [UIColor whiteColor],
                                       buttonColor: [UIColor blueColor],
                                       font: [UIFont systemFontOfSize:18],
                                       valueY: @3,
                                       selectedObject:_durationString,
                                       textAlignment:@1
                                       }
                          completion:^(NSString *selectedString){
                              [_durationButton setTitle:selectedString forState:UIControlStateNormal];
                              _durationString = selectedString;
                          }];
}

#pragma mark - Utility Functions

-(void)animate
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.5;
    anim.repeatCount = 2;
    anim.autoreverses = YES;
    anim.removedOnCompletion = YES;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    [_whenProperty.layer addAnimation:anim forKey:nil];
}

- (NSInteger)MonthToIndex:(NSString* )month
{
    NSInteger monthIndex = -1;
    
    if (month)
    {
        for (int i =0 ; i < [_monthArray count]; i ++)
        {
            if ([month isEqualToString:[_monthArray objectAtIndex:i]])
            {
                monthIndex = i + 1;
                
                break;
            }
        }
    }
    
    return monthIndex;
}

- (void) initUI
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];

    // Setting Month
    
    NSString* monthStr = Nil;
    NSString* dayStr = Nil;
    NSString* yearStr = Nil;
    NSString* durationStr = Nil;
    
    monthStr = [_monthArray objectAtIndex:(month - 1)];
    
    dayStr = [NSString stringWithFormat:@"%d", (int) day];
    yearStr = [NSString stringWithFormat:@"%d", (int) year];
    durationStr = [_durationArray objectAtIndex:0];
    
    [_monthButton setTitle:monthStr forState:UIControlStateNormal];
    _monthString = monthStr;
    
    [_dayButton setTitle:dayStr forState:UIControlStateNormal];
    _dayString = dayStr;
    
    [_yearButton setTitle:yearStr forState:UIControlStateNormal];
    _yearString = yearStr;
    
    [_durationButton setTitle:durationStr forState:UIControlStateNormal];
    _durationString = durationStr;
    
    if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Adventure)
    {
        [self.durationButton setHidden:NO];
        [self.durationImg setHidden:NO];
    }
    else
    {
        [self.durationButton setHidden:YES];
        [self.durationImg setHidden:YES];
    }
}

@end
