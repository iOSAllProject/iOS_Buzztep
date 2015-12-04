//
//  AnimationVC.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 16/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "AnimationVC.h"

#import "Smile.h"
#import "Globe.h"
#import "Flight.h"
#import "AppDelegate.h"
#import "BuzzProfileVC.h"
#import "AddNewBuzzTypeVC.h"
#import "SeetingsVC.h"
#import "MapView.h"
#import "CommunityVC.h"

#import "BuzzViewController.h"

#import "MyFootprintVC.h"
#import "FindFriendsVC.h"
#import "InviteFriendsVC.h"
#import "MeetUpsVC.h"
#import "MyFootprintGlobeVC.h"

#define ImageNamed(x) [UIImage imageNamed:x]

@interface AnimationVC ()

@property (strong, nonatomic) IBOutlet UIButton *settingProperty;
@property (weak, nonatomic) IBOutlet Smile *redImage;
@property (weak, nonatomic) IBOutlet Globe *blueImage;
@property (weak, nonatomic) IBOutlet Flight *yellowImage;
@property (weak, nonatomic) IBOutlet Globe *tap1;
- (IBAction)settingsButtonAction:(id)sender;
- (IBAction)buzzProfielButton:(id)sender;@end

@implementation AnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    _settingProperty.layer.shadowColor = [UIColor cyanColor].CGColor;
    _settingProperty.layer.shadowRadius = 10.0f;
    _settingProperty.layer.shadowOpacity = 1.0f;
    _settingProperty.layer.shadowOffset = CGSizeZero;
    
    
    NSArray *listOfImages  = @[ImageNamed(@"Bloon@2x"),ImageNamed(@"addUser@2x"),ImageNamed(@"flag@2x")];
    NSArray *listOfImages1 = @[ImageNamed(@"PeoplePin@2x"),ImageNamed(@"GlovePin@2x"),ImageNamed(@"FlagPIn@2x")];
  NSArray *listOfImages2 = @[ImageNamed(@"footSteps@2x"),ImageNamed(@"yellowPassport@2x"),ImageNamed(@"Aroow@2x")];
    
    [self.redImage setImagesForButtons:listOfImages];
    [self.redImage setCenterButtonImage:[UIImage imageNamed:@"People@2x"] backgroundColor:[UIColor clearColor]];
    [self.redImage setRadius:130];
    
    [self.blueImage setImagesForButtons:listOfImages1];
    [self.blueImage setCenterButtonImage:[UIImage imageNamed:@"GlobeActive@2x"] backgroundColor:[UIColor clearColor]];
    [self.blueImage setRadius:130];
    
    [self.yellowImage setImagesForButtons:listOfImages2];
    [self.yellowImage setCenterButtonImage:[UIImage imageNamed:@"FrameActive@2x"] backgroundColor:[UIColor clearColor]];
    [self.yellowImage setRadius:-120];
    
    self.redImage.delegate = self;
    self.blueImage.delegate = self;
    self.yellowImage.delegate = self;
    
}
-(void)showImages
{
    [self.redImage setCenterButtonImage:[UIImage imageNamed:@"People@2x"] backgroundColor:[UIColor clearColor]];
    [self.blueImage setCenterButtonImage:[UIImage imageNamed:@"GlobeActive@2x"] backgroundColor:[UIColor clearColor]];
    [self.yellowImage setCenterButtonImage:[UIImage imageNamed:@"FrameActive@2x"] backgroundColor:[UIColor clearColor]];
    
}
- (void)didTapSmileViewToOpen:(BOOL)isOpening
{
    [self showImages];
    if (isOpening)
    {
        [_blueImage moveView1:NO];
        [_yellowImage moveView:NO];
        
        [self.blueImage setCenterButtonImage:[UIImage imageNamed:@"globe@2x"] backgroundColor:[UIColor clearColor]];
        [self.yellowImage setCenterButtonImage:[UIImage imageNamed:@"frame@2x"] backgroundColor:[UIColor clearColor]];
    }
}
- (void)didTapGlobeViewToOpen:(BOOL)isOpening
{
    [self showImages];
    if (isOpening)
    {
        [_redImage moveView:NO];
        [_yellowImage moveView:NO];
        
        [self.redImage setCenterButtonImage:[UIImage imageNamed:@"PeopleInactive@2x"] backgroundColor:[UIColor clearColor]];
        [self.yellowImage setCenterButtonImage:[UIImage imageNamed:@"frame@2x"] backgroundColor:[UIColor clearColor]];
    }
}
- (void)didTapFlightViewToOpen:(BOOL)isOpening
{
    [self showImages];
    if (isOpening)
    {
        [_redImage moveView:NO];
        [_blueImage moveView1:NO];
        
        [self.redImage setCenterButtonImage:[UIImage imageNamed:@"PeopleInactive@2x"] backgroundColor:[UIColor clearColor]];
    [self.blueImage setCenterButtonImage:[UIImage imageNamed:@"globe@2x"] backgroundColor:[UIColor clearColor]];
    }
}
- (IBAction)buzzProfielButton:(id)sender
{
    [_blueImage moveView1:NO];
    [_yellowImage moveView:NO];
    [_redImage moveView:NO];
    
    BuzzProfileVC *secondViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
    [self.navigationController pushViewController:secondViewController animated:YES];
}

-(void)tappedButtonWithIndex:(NSInteger )index
{
    if (index==1)
    {
        NSLog(@"index 1 - Map Pins View");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BuzzFindFriends" bundle:nil];
        FindFriendsVC *buzzvc=[storyboard instantiateViewControllerWithIdentifier:@"findfriendsvc"];
        [self.navigationController pushViewController:buzzvc animated:YES];
    }
    
    else if (index==2)
    {
        AddNewBuzzTypeVC *buzzProfile =[self.storyboard instantiateViewControllerWithIdentifier:@"addnewbuzztype"];
        [self.navigationController pushViewController:buzzProfile animated:YES];
        
        NSLog(@"index 2 - NewBuzzType");
    }
    else if (index==3)
    {
        CommunityVC *comm=[self.storyboard instantiateViewControllerWithIdentifier:@"community"];
        [self.navigationController pushViewController:comm animated:YES];
        
        NSLog(@"index 3 - Community");
    }
    else if (index==4)
    {
        BuzzViewController *buzzlist = [self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
        [self.navigationController pushViewController:buzzlist animated:YES];
    }
    
    else if (index==5)
    {
        NSLog(@"index 5- Meet ups");
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Amenities" bundle:nil];
        
        MeetUpsVC *meetups=[storyboard instantiateViewControllerWithIdentifier:@"MeetUps"];
        [self.navigationController pushViewController:meetups animated:YES];
    }
    else if(index==6)
    {
        
        BuzzProfileVC *buzzProfile =[self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
        [self.navigationController pushViewController:buzzProfile animated:YES];
        NSLog(@"index 6 - BuzzProfile ");
    }
    
    else if(index==7)
    {
        MapView *map=[self.storyboard instantiateViewControllerWithIdentifier:@"mapview"];
        [self.navigationController pushViewController:map animated:YES];
        
        NSLog(@"index 7 - Mapview");
        
    }
    else if (index==8)
    {
        
        MyFootprintGlobeVC *myFGlobeVC = [[MyFootprintGlobeVC alloc] init];
        [self.navigationController pushViewController:myFGlobeVC animated:YES];
        
        NSLog(@"index 8 my Foot print");
    }
    
    else if (index==9)
    {
        NSLog(@"index 9 Invite Friends");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"InviteFriends" bundle:nil];
        InviteFriendsVC *invite=[storyboard instantiateViewControllerWithIdentifier:@"invitefriendsvc"];
        [self.navigationController pushViewController:invite animated:YES];
    }
    
}

- (IBAction)settingsButtonAction:(id)sender
{
    [_blueImage moveView1:NO];
    [_yellowImage moveView:NO];
    [_redImage moveView:NO];
    SeetingsVC *set=[self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
    [self.navigationController pushViewController:set animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
