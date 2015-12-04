//
//  NotificationVC2.m
//  NotificationVC1
//
//  Created by Sanchit Thakur on 22/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "NotificationVC2.h"

#import "NotificationCell.h"
#import "BuzzProfileVC.h"

#import "AppDelegate.h"
#import "ChatViewController.h"
#import "BuzzViewController.h"
#import "AnimationVC.h"
#import "MeetUpsVC.h"

#import "BTAPIClient.h"

#import "BTNotificationModel.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "Global.h"

@interface NotificationVC2 ()

@property (strong, nonatomic) IBOutlet UITableView *notificationTableView;
@property (strong, nonatomic) NSMutableArray *allNotificationContent;
@property (strong, nonatomic) NSMutableArray *sectionNames;
@property (strong, nonatomic) NSArray *imageNames;

@property (strong, nonatomic) IBOutlet UIButton* bNotificationCount;

@property (assign, atomic)      NSInteger   notificationCount;

- (void) loadDataFromServer;
- (void) updateNotificationCount:(NSNotification* )dict;
- (void) reloadNotifications;
- (void) InitUI;

- (IBAction)backAction:(id)sender;
- (IBAction)animationAction:(id)sender;
- (IBAction)whiteArrowAction:(id)sender;

@end

@implementation NotificationVC2
{
    NSArray *profilePicturesArray,*profilePicturesArray1,*profilePicturesArray2;
    NSArray *namesArray,*namesArray1,*namesArray2;
    NSArray *timeArray,*timeArray1,*timeArray2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeGesture =
            [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleSwipeGestureRight)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeGesture];
    
    // Do any additional setup after loading the view from its nib.    
    
    self.notificationTableView.delegate=self;
    self.notificationTableView.dataSource=self;
    
    /*
    _allNotificationContent = @[@{@"image" : @"Dollarphotoclub_59146390",
                                  @"message" : @"Megan Smith sent you a message",
                                  @"timestamp" : @"2:13PM"},
                                
                                @{@"image" : @"Dollarphotoclub_61322874",
                                  @"message" : @"Carie Underwood commented",
                                  @"timestamp" : @"2:01PM"},
                                
                                @{@"image" : @"Dollarphotoclub_68090121",
                                  @"message" : @"Annie Hall liked a photo",
                                  @"timestamp" : @"8:13PM"}
                                ];
    */
    
    self.imageNames = @[@"Dollarphotoclub_59146390",
                        @"Dollarphotoclub_61322874",
                        @"Dollarphotoclub_68090121",
                        @"avatar1", @"avatara",
                        @"avat", @"avatara",
                        @"Dollar", @"avatara",
                        @"avatarBg"];
    
    self.allNotificationContent = [[NSMutableArray alloc] init];
    self.sectionNames = [[NSMutableArray alloc] init];
    
    self.notificationCount = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNotificationCount:)
                                                 name:kBTNotificationGotNewNotificationCount
                                               object:Nil];
    
    [self InitUI];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadDataFromServer];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:kBTNotificationGotNewNotificationCount];
}

- (void) loadDataFromServer
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[BTAPIClient sharedClient] getNotifications:@"people"
                                    withPersonId:MyPersonModelID
                                       withBlock:^(NSArray *models, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
         
         if (error == Nil)
         {
             DLog(@"%@", models);
             
             if ([models isKindOfClass:[NSArray class]])
             {
                 self.allNotificationContent = [[NSMutableArray alloc] init];
                 [self.allNotificationContent removeAllObjects];
                 
                 NSInteger modelCount = [models count];
                 
                 for (int i = 0; i < modelCount ; i ++)
                 {
                     BTNotificationModel* model = [[BTNotificationModel alloc] initNotificationWithDict:[models objectAtIndex:i]];
                     
                     [self.allNotificationContent addObject:model];
                 }
                 
                 if (modelCount)
                 {
                     
                     self.sectionNames = [[NSMutableArray alloc] init];
                     [self.sectionNames removeAllObjects];
                     
                     [self.sectionNames addObject:@"To day"];
                     [self.sectionNames addObject:@"Monday, Feb, 13"];
                     [self.sectionNames addObject:@"Sunday, Feb, 12"];
                     
                     
                     [self.notificationTableView reloadData];
                 }
             }
             
         }
     }];
}

- (void)updateNotificationCount:(NSNotification* )dict
{
    NSNumber* countNum = [dict.object objectForKeyedSubscript:@"count"] ;
        
    // Update UI
    
    self.notificationCount = [countNum integerValue];
    
    // Check the current UI's notification count
    
    NSInteger oldCount = [self.bNotificationCount.titleLabel.text integerValue];
    
    if ([countNum integerValue] != oldCount)
    {
        [self loadDataFromServer];
    }
    
    NSString* countStr = [NSString stringWithFormat:@"%d", (int)self.notificationCount];
    
    [self.bNotificationCount setTitle:countStr forState:UIControlStateNormal];
}

- (void)InitUI
{
    // Init Notification Count
    
    NSInteger notification_count = [[AppDelegate SharedDelegate] getLocalNotificationCount];
    
    // Update UI
    
    self.notificationCount = notification_count;
    
    NSString* countStr = [NSString stringWithFormat:@"%d", (int)self.notificationCount];
    
    [self.bNotificationCount setTitle:countStr forState:UIControlStateNormal];
    
}

- (void)reloadNotifications
{
    
}

-(void)handleSwipeGestureRight
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.allNotificationContent.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionNames count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *i=@"";
    
    if (section < [self.sectionNames count])
    {
        return self.sectionNames[section];
    }
    else
    {
        return i;
    }
    
    return i;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"NotificationCell";
    
    NotificationCell *cell = (NotificationCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NotificationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    BTNotificationModel* model = self.allNotificationContent[indexPath.row];
    
    [cell InitNotificationWithDict:model];
    
    cell.profilePicImageView.image = [UIImage imageNamed:[_imageNames objectAtIndex:(indexPath.row % [_imageNames count])]];
    
    cell.verticalLineTop.hidden = indexPath.section == 0 && indexPath.row == 0;
    cell.verticalLineBottom.hidden = (indexPath.section == [self numberOfSectionsInTableView:tableView]-1) && (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BTNotificationModel* selectedModel = self.allNotificationContent[indexPath.row];
    
    if (selectedModel.notification_type == Notification_Type_Adventure)
    {
        DLog(@"Wating UI");
    }
    else if (selectedModel.notification_type == Notification_Type_Event)
    {
        DLog(@"Wating UI");
    }
    else if (selectedModel.notification_type == Notification_Type_Media)
    {
        DLog(@"Wating UI");
    }
    else if (selectedModel.notification_type == Notification_Type_Meetup)
    {
        DLog(@"Linking Meetup UI");
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Amenities" bundle:nil];
        
        MeetUpsVC *meetups=[storyboard instantiateViewControllerWithIdentifier:@"MeetUps"];
        [self.navigationController pushViewController:meetups animated:YES];
    }
    else if (selectedModel.notification_type == Notification_Type_Message)
    {
        DLog(@"Linking Message UI");
        
        ChatViewController *chatvc=[self.storyboard instantiateViewControllerWithIdentifier:@"chat"];
        
        [self.navigationController pushViewController:chatvc animated:YES];
    }
    else if (selectedModel.notification_type == Notification_Type_Milestone)
    {
        DLog(@"Wating UI");
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)animationAction:(id)sender
{
    AnimationVC *animation=[self.storyboard instantiateViewControllerWithIdentifier:@"AnimationView"];
    [self.navigationController pushViewController:animation animated:YES];
}

- (IBAction)whiteArrowAction:(id)sender
{
    NSLog(@"hii0");
    
    BuzzViewController *buzzlist = [self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
    [self.navigationController pushViewController:buzzlist animated:YES];
    
}
@end
