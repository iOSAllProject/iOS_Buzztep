//
//  SeetingsVC.m
//  Animation
//
//  Created by Sanchit Thakur on 23/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "SeetingsVC.h"
#import "AnimationVC.h"

#import "AppDelegate.h"

#import "BuzzProfileVC.h"
#import "LoginVC.h"
#import "NotificationVC2.h"
#import "MyBucketList.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "MessagesVC.h"

@interface SeetingsVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
- (IBAction)closeButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSArray*settingsArray;

@end

@implementation SeetingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    
    self.picImageView.layer.cornerRadius = self.picImageView.frame.size.width/2;
    self.picImageView.clipsToBounds = YES;
    
    _settingsArray=[[NSArray alloc]initWithObjects:@"ACCOUNT INFO",@"NOTIFICATION",@"MESSAGES", @"AUTO TRCKING",@"UNDERCOVER",@"IMPORTING",@"BUCKET LIST",@"REQUEST",@"VIDEO",@"SHAKE FEATURE",@"FEEDBACK",@"HELP?",@"LOG OUT",  nil];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UITableView 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_settingsArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text=[_settingsArray objectAtIndex:indexPath.row];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow2.png"]];
    
    UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 14.0 ];
    cell.textLabel.font  = myFont;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0)
    {
        NSLog(@"ACCOUNT INFO");
        BuzzProfileVC *profile=[self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
        
        [self.navigationController pushViewController:profile animated:YES];
    }
    if(indexPath.row==1)
    {
        NSLog(@"NOTIFICATIONS");
        NotificationVC2 *notification=[self.storyboard instantiateViewControllerWithIdentifier:@"notification"];
        [self.navigationController pushViewController:notification animated:YES];
    }
    if(indexPath.row==2)
    {
        NSLog(@"MESSAGES");
        
        MessagesVC *MVC=[self.storyboard instantiateViewControllerWithIdentifier:@"messagesvc"];
        [self.navigationController pushViewController:MVC animated:YES];
    }
    if(indexPath.row==3)
    {
        NSLog(@"AUTO TRACKING");
    }
    if(indexPath.row==4)
    {
        NSLog(@"UNDERCOVER");
    }
    if(indexPath.row==5)
    {
        NSLog(@"IMPORTING");
    }
    if(indexPath.row==6)
    {
        NSLog(@"BUCKET LIST");
        MyBucketList *notification=[self.storyboard instantiateViewControllerWithIdentifier:@"bucketlist"];
        [self.navigationController pushViewController:notification animated:YES];
    }
    if(indexPath.row==7)
    {
        NSLog(@"REQUESTS");
    }
    if(indexPath.row==8)
    {
        NSLog(@"VIDEO");
    }
    if(indexPath.row==9)
    {
        NSLog(@"SHAKE FEATURE");
    }
    if(indexPath.row==10)
    {
        NSLog(@"FEEDBACK");
    }
    if(indexPath.row==11)
    {
        NSLog(@"HELP?");
    }
    if(indexPath.row==12)
    {
        NSLog(@"LOG OUT");
        FBSDKAccessToken *currentFBAccessToken = [FBSDKAccessToken currentAccessToken];
//        [currentFBAccessToken refreshCurrentAccessToken:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//            if (!error) {
//                NSLog(@"User logged out:%@", result);
//            }
//            else {
//                NSLog(@"Unable to logout:%@", error.description);
//            }
//        }];

        FBSDKLoginManager *fbLoginSession = [[FBSDKLoginManager alloc] init];
        [fbLoginSession logOut];
        
        
        LoginVC *login=[self.storyboard instantiateViewControllerWithIdentifier:@"loginpage"];
        [self.navigationController pushViewController:login animated:YES];
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
