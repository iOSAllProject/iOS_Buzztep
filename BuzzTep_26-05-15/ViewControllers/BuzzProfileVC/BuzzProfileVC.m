//
//  BuzzProfileViewController.m
//  Animation
//
//  Created by Sanchit Thakur on 20/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BuzzProfileVC.h"
#import "Following.h"
#import "BuzzCount.h"
#import "NotificationVC2.h"
#import "AddNewBuzzTypeVC.h"
#import "Followers.h"
#import "MyBucketList.h"
#import "ConnectionsVC.h"
#import "CommunityVC.h"
#import "ProjectHandler.h"
#import "AnimationVC.h"
#import "InviteFriendsVC.h"
#import "MyFootprintVC.h"
#import "MyFootprintGlobeVC.h"
#import "LocationWorker.h"

#import "BuzzViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>

#import "BTAPIClient.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "BTPeopleModel.h"

@interface BuzzProfileVC ()


- (IBAction)myFootPrint:(id)sender;
- (IBAction)followersAction:(id)sender;
- (IBAction)notificationButton:(id)sender;
- (void)updateNotificationCount:(NSNotification* )dict;
- (void)InitUI;

- (IBAction)myBuzzAction:(id)sender;
- (IBAction)buzzCountAction:(id)sender;
- (IBAction)threeDotButton:(id)sender;
- (IBAction)followingAction:(id)sender;
- (IBAction)adventuresButton:(id)sender;
- (IBAction)pauseAction:(id)sender;
- (IBAction)bucketAction:(id)sender;
- (IBAction)newBuzzAction:(id)sender;
- (IBAction)inviteAction:(id)sender;
- (IBAction)trackingAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (strong, nonatomic) IBOutlet UIButton *footPrintButton;
@property (strong, nonatomic) IBOutlet UIButton *myBuzzButton;
@property (weak, nonatomic) IBOutlet UIView *myView;

@property (weak, nonatomic) IBOutlet UILabel *pauseLabel;

@property (weak, nonatomic) IBOutlet UILabel *hatLabel;
@property (weak, nonatomic) IBOutlet UIButton *bucketList;

@property (strong, nonatomic) IBOutlet UIImageView *oneImageView;
@property (strong, nonatomic) IBOutlet UIImageView *twoImageView;

@property (strong, nonatomic) IBOutlet UILabel  *lbl_profile_Name;

@property (strong, nonatomic) IBOutlet UIButton *trackingButton;

// Buttons

@property (strong, nonatomic) IBOutlet UIButton *btn_friend_following;
@property (strong, nonatomic) IBOutlet UIButton *btn_friend_buzzcount;
@property (strong, nonatomic) IBOutlet UIButton *btn_friend_followers;

@property (strong, nonatomic) IBOutlet UIButton *btn_friend_milestones;
@property (strong, nonatomic) IBOutlet UIButton *btn_friend_adventures;
@property (strong, nonatomic) IBOutlet UIButton *btn_friend_events;

@property (strong, nonatomic) BTPeopleModel* mPeopleModel;

// Notification Count Relation

@property (strong, nonatomic) IBOutlet UIButton* bNotificationCount;
@property (assign, atomic)          NSInteger   notificationCount;

@end

@implementation BuzzProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.size.width/2;
    self.profilePicImageView.clipsToBounds = YES;
    
    [self setWhiteBorderFor:self.profilePicImageView];
    [self setWhiteBorderFor:self.footPrintButton];
    [self setWhiteBorderFor:self.myBuzzButton];
    [self setWhiteBorderFor:self.bucketList];
    
    UITapGestureRecognizer *profilePicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profilePicTapped:)];
    self.profilePicImageView.userInteractionEnabled = YES;
    [self.profilePicImageView addGestureRecognizer:profilePicTap];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneImageTapped:)];
    
    _oneImageView.userInteractionEnabled = YES;
    [_oneImageView addGestureRecognizer:tap];
    
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoImageTapped:)];
    
    _twoImageView.userInteractionEnabled = YES;
    [_twoImageView addGestureRecognizer:tap1];
    
    self.notificationCount = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateNotificationCount:)
                                                 name:kBTNotificationGotNewNotificationCount
                                               object:Nil];
    

    [self InitUI];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([LocationWorker isWorking]) {
        self.pauseLabel.hidden = NO;
    }
    
    [self updateTrackButton];
}

- (void)updateTrackButton
{
    NSString *imageName = [LocationWorker isWorking] ? @"Pause1" : @"Play1";
    [self.trackingButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:kBTNotificationGotNewNotificationCount];
}

- (void)updateNotificationCount:(NSNotification* )dict
{
    NSNumber* countNum = [dict.object objectForKeyedSubscript:@"count"] ;
    
    // Update UI
    
    self.notificationCount = [countNum integerValue];
    
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
    
    // Load server data
    
    [self loadServerData];
    
}


- (void )oneImageTapped:(UITapGestureRecognizer *) gestureRecognizer
{
    //NSLog(@"One Image Tapped");
    
        self.myView.alpha = 0.0;
        [UIView beginAnimations:@"Fade-in" context:NULL];
        [UIView setAnimationDuration:1.0];
        self.myView.alpha = 1.0;
        [UIView commitAnimations];
    
        self.pauseLabel.hidden=YES;
        self.hatLabel.hidden=NO;
    
        self.hatLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:14];
    
    self.oneImageView.hidden=YES;
    self.twoImageView.hidden=NO;

}

- (void )twoImageTapped:(UITapGestureRecognizer *) gestureRecognizer
{
   // NSLog(@"Two Image Tapped");
    self.oneImageView.hidden=NO;
    self.twoImageView.hidden=YES;
    self.hatLabel.hidden=YES;
    self.pauseLabel.hidden=YES;
}

- (void)setWhiteBorderFor:(UIView*)view
{
    view.layer.borderWidth = 2.0;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)profilePicTapped:(UIGestureRecognizer *)gestureRecognizer
{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Choose Profile Pic" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose from Gallery", @"Take a Photo", nil];
    
    popupQuery.actionSheetStyle = UIActionSheetStyleDefault;
    [popupQuery showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate=self;
        [picker setSourceType:(UIImagePickerControllerSourceTypePhotoLibrary)];
        [self presentViewController:picker animated:YES completion:Nil];
        
    }
    else if (buttonIndex==1)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            NSArray *media = [UIImagePickerController
                              availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
            
            if ([media containsObject:(NSString*)kUTTypeImage] == YES)
            {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                [picker setMediaTypes:[NSArray arrayWithObject:(NSString *)kUTTypeImage]];
                
                [self presentViewController:picker animated:YES completion:nil];
            }
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unsupported!"
                                                                message:@"Camera does not support photo capturing."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unavailable!"
                                                            message:@"This device does not have a camera."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.chooseImage=info[UIImagePickerControllerOriginalImage];
    [self.profilePicImageView setImage:self.chooseImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)myFootPrint:(id)sender
{
    MyFootprintGlobeVC *myFGlobeVC = [[MyFootprintGlobeVC alloc] init];
    [self.navigationController pushViewController:myFGlobeVC animated:YES];
}

- (IBAction)followersAction:(id)sender
{
   
    Followers *following=[self.storyboard instantiateViewControllerWithIdentifier:@"followers"];
    [self.navigationController pushViewController:following animated:YES];
}

- (IBAction)notificationButton:(id)sender
{
    NotificationVC2 *notification=[self.storyboard instantiateViewControllerWithIdentifier:@"notification"];
    [self.navigationController pushViewController:notification animated:YES];
}

- (IBAction)myBuzzAction:(id)sender
{
    BuzzViewController *buzzlist = [self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
    [self.navigationController pushViewController:buzzlist animated:YES];

}

- (IBAction)buzzCountAction:(id)sender
{
    BuzzCount *buzzCount=[self.storyboard instantiateViewControllerWithIdentifier:@"buzzcount"];
    [self.navigationController pushViewController:buzzCount animated:YES];
}

- (IBAction)threeDotButton:(id)sender
{
    AnimationVC *animation =[self.storyboard instantiateViewControllerWithIdentifier:@"AnimationView"];
    [self.navigationController pushViewController:animation animated:YES];
}

- (IBAction)followingAction:(id)sender
{
    Following *following=[self.storyboard instantiateViewControllerWithIdentifier:@"following"];
    [self.navigationController pushViewController:following animated:YES];
}

- (IBAction)adventuresButton:(UIButton*)sender
{
    BuzzCount *buzzCount=[self.storyboard instantiateViewControllerWithIdentifier:@"buzzcount"];
    buzzCount.selectedIndex = sender.tag;
    [self.navigationController pushViewController:buzzCount animated:YES];
}

- (IBAction)pauseAction:(id)sender
{
    self.myView.alpha = 0.0;
    [UIView beginAnimations:@"Fade-in" context:NULL];
    [UIView setAnimationDuration:1.0];
    self.myView.alpha = 1.0;
    [UIView commitAnimations];
    
    self.pauseLabel.hidden=NO;
    self.hatLabel.hidden=YES;
    self.pauseLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:14];
    
}
- (IBAction)bucketAction:(id)sender
{
    MyBucketList *bucket=[self.storyboard instantiateViewControllerWithIdentifier:@"bucketlist"];
    [self.navigationController pushViewController:bucket animated:YES];
}

- (IBAction)newBuzzAction:(id)sender
{
    AddNewBuzzTypeVC *addNewBuzz=[self.storyboard instantiateViewControllerWithIdentifier:@"addnewbuzztype"];
    [self.navigationController pushViewController:addNewBuzz animated:YES];
}

- (IBAction)inviteAction:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"InviteFriends" bundle:nil];
    InviteFriendsVC *invite=[storyboard instantiateViewControllerWithIdentifier:@"invitefriendsvc"];
    [self.navigationController pushViewController:invite animated:YES];
}

- (IBAction)trackingAction:(id)sender
{
    if ([LocationWorker isWorking]) {
        [LocationWorker stopTracking];
        [LocationWorker saveLocations];
        self.pauseLabel.hidden = YES;
        
    } else {
        [LocationWorker startTracking];
        [UIView beginAnimations:@"Fade-in" context:NULL];
        [UIView setAnimationDuration:1.0];
        [UIView commitAnimations];
        self.myView.alpha = 1.0;
        self.pauseLabel.hidden = NO;
    }
    
    [self updateTrackButton];
}

#pragma mark - Utility Function

- (void)loadServerData
{
    NSDictionary *params = @{@"where":@{@"id":MyPersonModelID}};
    
    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSString *paramsStr = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
    
    NSString* filterQuery = [NSString stringWithFormat:@"filter=%@", paramsStr];
    
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[BTAPIClient sharedClient] getPeople:@"people"
                               withFilter:filterQuery
                                withBlock:^(NSArray *models, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
         
         if (error == Nil)
         {
             if ([models count] == 1)
             {
                 if ([[models firstObject] isKindOfClass:[NSDictionary class]])
                 {
                     self.mPeopleModel = [[BTPeopleModel alloc] initPeopleWithDict:[models firstObject]];
                     
                     if (self.mPeopleModel)
                     {
//                         DLog(@"%@", self.mPeopleModel);
                         
                         // Name and Location
                         
                         NSString* name = @"Emily Stoneburg";
                         
                         if (self.mPeopleModel.people_identity)
                         {
                             if ([self.mPeopleModel.people_identity objectForKeyedSubscript:@"firstName"])
                             {
                                 if ([self.mPeopleModel.people_identity objectForKeyedSubscript:@"lastName"])
                                 {
                                     name = [NSString stringWithFormat:@"%@ %@", [self.mPeopleModel.people_identity objectForKeyedSubscript:@"firstName"], [self.mPeopleModel.people_identity objectForKeyedSubscript:@"lastName"]];
                                 }
                                 else
                                 {
                                     name = [NSString stringWithFormat:@"%@", [self.mPeopleModel.people_identity objectForKeyedSubscript:@"firstName"]];
                                 }
                             }
                             else
                             {
                                 if ([self.mPeopleModel.people_identity objectForKeyedSubscript:@"lastName"])
                                 {
                                     name = [NSString stringWithFormat:@"%@", [self.mPeopleModel.people_identity objectForKeyedSubscript:@"lastName"]];
                                 }
                                 else
                                 {
                                     name = [NSString stringWithFormat:@"%@", @"Killer"];
                                 }
                             }
                         }
                         
                         self.lbl_profile_Name.text = name;
                         
                         // How can we get the friend's location?
                         
                         if (self.mPeopleModel.people_statistics)
                         {
                             // Following, BuzzCount and Followers
                             
                             if ([self.mPeopleModel.people_statistics objectForKeyedSubscript:@"followingCount"])
                             {
                                 NSNumber* followingCount = [self.mPeopleModel.people_statistics objectForKeyedSubscript:@"followingCount"];
                                 
                                 NSString* followingCountStr = [NSString stringWithFormat:@"%d", [followingCount intValue]];
                                 
                                 [self.btn_friend_following setTitle:followingCountStr forState:UIControlStateNormal];
                             }
                             else
                             {
                                 [self.btn_friend_following setTitle:@"0" forState:UIControlStateNormal];
                             }
                             
                             if ([self.mPeopleModel.people_statistics objectForKeyedSubscript:@"buzzCount"])
                             {
                                 NSNumber* buzzCount = [self.mPeopleModel.people_statistics objectForKeyedSubscript:@"buzzCount"];
                                 
                                 NSString* buzzCountStr = [NSString stringWithFormat:@"%d", [buzzCount intValue]];
                                 
                                 [self.btn_friend_buzzcount setTitle:buzzCountStr forState:UIControlStateNormal];
                             }
                             else
                             {
                                 [self.btn_friend_buzzcount setTitle:@"0" forState:UIControlStateNormal];
                             }
                             
                             if ([self.mPeopleModel.people_statistics objectForKeyedSubscript:@"followerCount"])
                             {
                                 NSNumber* followerCount = [self.mPeopleModel.people_statistics objectForKeyedSubscript:@"followerCount"];
                                 
                                 NSString* followerCountStr = [NSString stringWithFormat:@"%d", [followerCount intValue]];
                                 
                                 [self.btn_friend_followers setTitle:followerCountStr forState:UIControlStateNormal];
                             }
                             else
                             {
                                 [self.btn_friend_followers setTitle:@"0" forState:UIControlStateNormal];
                             }
                         }
                     }
                 }
             }
         }
     }];
    
    [[BTAPIClient sharedClient] getAdventureCount:@"people"
                                     withPersonId:MyPersonModelID
                                        withBlock:^(NSDictionary *model, NSError *error)
     {
         if (error == Nil)
         {
             if ([model isKindOfClass:[NSDictionary class]])
             {
                 if ([model objectForKeyedSubscript:@"count"])
                 {
                     NSNumber* countNum = [model objectForKeyedSubscript:@"count"];
                     
                     NSString* countStr = [NSString stringWithFormat:@"%d", [countNum intValue]];
                     
                     [self.btn_friend_adventures setTitle:countStr
                                                 forState:UIControlStateNormal];
                 }
             }
         }
     }];
    
    [[BTAPIClient sharedClient] getMilestoneCount:@"people"
                                     withPersonId:MyPersonModelID
                                        withBlock:^(NSDictionary *model, NSError *error)
     {
         if (error == Nil)
         {
             if ([model isKindOfClass:[NSDictionary class]])
             {
                 if ([model objectForKeyedSubscript:@"count"])
                 {
                     NSNumber* countNum = [model objectForKeyedSubscript:@"count"];
                     
                     NSString* countStr = [NSString stringWithFormat:@"%d", [countNum intValue]];
                     
                     [self.btn_friend_milestones setTitle:countStr
                                                 forState:UIControlStateNormal];
                 }
             }
         }
     }];
    
    [[BTAPIClient sharedClient] getEventCount:@"people"
                                 withPersonId:MyPersonModelID
                                    withBlock:^(NSDictionary *model, NSError *error)
     {
         if (error == Nil)
         {
             if ([model isKindOfClass:[NSDictionary class]])
             {
                 if ([model objectForKeyedSubscript:@"count"])
                 {
                     NSNumber* countNum = [model objectForKeyedSubscript:@"count"];
                     
                     NSString* countStr = [NSString stringWithFormat:@"%d", [countNum intValue]];
                     
                     [self.btn_friend_events setTitle:countStr
                                             forState:UIControlStateNormal];
                 }
             }
         }
     }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
