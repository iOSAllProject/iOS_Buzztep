//
//  DetailViewController.m
//  BuzzTepFindFriends
//
//  Created by Sanchit Thakur  on 01/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "FindFriendsDetailVC.h"
#import "BTFriendProfileVC.h"
#import "MeetUpsVC.h"
#import <AddressBook/AddressBook.h>
#import "Constant.h"

@interface FindFriendsDetailVC ()

@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userAdress;
@property (weak, nonatomic) IBOutlet UILabel *userDistance;

@end

@implementation FindFriendsDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userName.text = self.model.userName;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *userLocation = [[CLLocation alloc]initWithLatitude:self.model.coordinate.latitude longitude:self.model.coordinate.longitude];
    [geocoder reverseGeocodeLocation:userLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"Geocode failed with error: %@", error);
        } else if (placemarks && placemarks.count > 0) {
            CLPlacemark *placemark = placemarks.firstObject;
            
            NSDictionary *addressDictionary = placemark.addressDictionary;
            
            NSString *city = [addressDictionary
                              objectForKey:(NSString *)kABPersonAddressCityKey];
            NSString *state = [addressDictionary
                               objectForKey:(NSString *)kABPersonAddressStateKey];
            
            self.userAdress.text = [NSString stringWithFormat:@"%@, %@", city, state];
        }
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *imgURL = self.model.userAvatar;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
        //set your image on main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data == nil) {
                self.userAvatar.image = [UIImage imageNamed:@"no_avatar"];
            }else{
                self.userAvatar.image = [UIImage imageWithData:data];
            }
        });
    });
    
    CLLocationDistance dist = [userLocation distanceFromLocation:self.currentLocation];
    self.userDistance.text = [NSString stringWithFormat:@"%@ Miles", [NSString stringWithFormat:@"%.1f", (dist/1609.344)]];
    
    //NSLog(@"Current Location is %@", currentLocation);
}

- (IBAction)pressCloseButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressPassportButton:(id)sender
{
    NSLog(@"Passport button pressed");

    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kBTNotificationShowPassPortProfile
                                                            object:Nil];
    }];
}

- (IBAction)pressMeetUpButton:(id)sender
{
    NSLog(@"Meet up button pressed");
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kBTNotificationShowMeetUp
                                                            object:Nil];
    }];
}

- (IBAction)pressCallButton:(id)sender
{
    NSLog(@"Call button pressed");
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kBTNotificationShowCall
                                                            object:Nil];
    }];
}

- (IBAction)pressMessageButton:(id)sender
{
    NSLog(@"Message button pressed");
    
    [self dismissViewControllerAnimated:NO
                             completion:^
     {
         DLog(@"Will show Message here ");
         
         [[NSNotificationCenter defaultCenter] postNotificationName:kBTNotificationShowMessage
                                                             object:Nil];
     }];
}


@end
