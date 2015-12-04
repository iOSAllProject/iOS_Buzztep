//
//  AddNewBuzzTypeVC.m
//  When_WhereVC
//
//  Created by Sanchit Thakur on 20/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "AddNewBuzzTypeVC.h"

#import "NewAdventureVC.h"
#import "BuzzProfileVC.h"
#import "AppDelegate.h"
#import "NewEventVC.h"
#import "NewMilestoneVC.h"

#import "Global.h"
#import "Constant.h"
#import "BTAdventureModel.h"
#import "BTMilestoneModel.h"
#import "BTEventModel.h"

@interface AddNewBuzzTypeVC ()

- (IBAction)newAdventureAction:(id)sender;
- (IBAction)newEventAction:(id)sender;
- (IBAction)newMilestoneAction:(id)sender;

- (IBAction)closeButton:(id)sender;

@end

@implementation AddNewBuzzTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)newAdventureAction:(id)sender{
    
    [AppDelegate SharedDelegate].gBuzzType = Global_BuzzType_Adventure;
    [AppDelegate SharedDelegate].gAdventureModel = [[BTAdventureModel alloc] init];
    [AppDelegate SharedDelegate].gAdventureModel.adventure_personId = MyPersonModelID;
    
    NewAdventureVC *newBuzz = [self.storyboard instantiateViewControllerWithIdentifier:@"Newbuzztypetitle"];
    [self.navigationController pushViewController:newBuzz animated:YES];
}

- (IBAction)newEventAction:(id)sender {
    
    [AppDelegate SharedDelegate].gBuzzType = Global_BuzzType_Event;
    [AppDelegate SharedDelegate].gEventModel = [[BTEventModel alloc] init];
    [AppDelegate SharedDelegate].gEventModel.event_personId = MyPersonModelID;
    [AppDelegate SharedDelegate].gEventModel.event_type = @"user";
    
    NewEventVC *newEvent = [self.storyboard instantiateViewControllerWithIdentifier:@"newEvent"];
    [self.navigationController pushViewController:newEvent animated:YES];
}

- (IBAction)newMilestoneAction:(id)sender {
    
    [AppDelegate SharedDelegate].gBuzzType = Global_BuzzType_Milestone;
    [AppDelegate SharedDelegate].gMilestoneModel = [[BTMilestoneModel alloc] init];
    [AppDelegate SharedDelegate].gMilestoneModel.milestone_personId = MyPersonModelID;
    
    NewMilestoneVC *newMile = [self.storyboard instantiateViewControllerWithIdentifier:@"newMilestone"];
    [self.navigationController pushViewController:newMile animated:YES];
}

- (IBAction)closeButton:(id)sender{
    BuzzProfileVC *buzzProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
