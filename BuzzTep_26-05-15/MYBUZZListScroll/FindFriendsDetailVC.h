//
//  DetailViewController.h
//  BuzzTepFindFriends
//
//  Created by Sanchit Thakur  on 01/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Annotation.h"
#import "BTPeopleModel.h"
#import "BTPhotoModel.h"
#import "AppDelegate.h"
@interface FindFriendsDetailVC : UIViewController

@property (strong, nonatomic) Annotation *model;
@property (strong, nonatomic) CLLocation *currentLocation;

@end
