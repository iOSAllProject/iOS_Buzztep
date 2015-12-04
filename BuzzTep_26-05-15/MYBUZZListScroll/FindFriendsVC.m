//
//  ViewController.m
//  BuzzTepFindFriends
//
//  Created by Sanchit Thakur  on 01/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "FindFriendsVC.h"
#import "FindFriendsDetailVC.h"
#import "Annotation.h"
#import "AnimationVC.h"
#import "CommunityVC.h"
#import <MapKit/MapKit.h>

#import "AppDelegate.h"
#import "Constant.h"

#import "ChatViewController.h"
#import "BTAPIClient.h"

#import "BTFriendshipModel.h"
#import "BTMessageModel.h"
#import "BTPeopleModel.h"
#import "Constant.h"
//#import "Progress.h"
#import "BTPhotoModel.h"
@interface FindFriendsVC () <MKMapViewDelegate>
{
    Annotation *annotationSelect;
}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *mapKeyView;
@property (strong, nonatomic) IBOutlet UIButton *mapKeyButton;
@property (strong, nonatomic) BTPeopleModel* mPeopleModel;
@property (strong, nonatomic) NSMutableArray* mPeopleData;

- (void)showMessageView;

- (IBAction)animationAction:(id)sender;

//- (void)loadDataFromServer;
@end

@implementation FindFriendsVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadDataFromServer];
    
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMessageView)
                                                 name:kBTNotificationShowMessage
                                               object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showPassportProfileView)
                                                 name:kBTNotificationShowPassPortProfile
                                               object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMeetUpView)
                                                 name:kBTNotificationShowMeetUp
                                               object:Nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showCallView)
                                                 name:kBTNotificationShowCall
                                               object:Nil];
}

- (void)showMessageView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ChatViewController *chatVC=[storyboard instantiateViewControllerWithIdentifier:@"chat"];
    
    //    chatVC.chat_friendShipId = message_friendShipId;
    chatVC.chat_messageModel = Nil;
    chatVC.chat_personModel = Nil;
    chatVC.isFromMessageList = NO;
    chatVC.friendId = annotationSelect.userId;
    //    chatVC.chat_messageModel = selectedCell.cellMessage;
    //    chatVC.chat_personModel = selectedCell.cellPerson;
    
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)showPassportProfileView{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BTFriend" bundle:nil];
    BTFriendProfileVC *friendProfile =  [storyboard instantiateViewControllerWithIdentifier:@"btfriendprofile"];
    friendProfile.friendId = annotationSelect.userId;
    [self.navigationController pushViewController:friendProfile animated:YES];
}

- (void)showMeetUpView{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Amenities" bundle:nil];
    MeetUpsVC *meetups = [storyboard instantiateViewControllerWithIdentifier:@"MeetUps"];
    meetups.friendId = annotationSelect.userId;
    [self.navigationController pushViewController:meetups animated:YES];
}

- (void)showCallView{
    [[AppDelegate SharedDelegate] callWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",annotationSelect.userNumberPhone]]];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    MKAnnotationView* annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Annotation"];
    if (!annotationView) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotation"];
        annotationView.canShowCallout = NO;
    }
    
    Annotation *customAnnotation = (Annotation*)annotation;
    
    NSString *imgURL = customAnnotation.userAvatar;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data) {
                    annotationView.image = [self mergeDotImages:[UIImage imageNamed:@"annotation"] foreGround:[UIImage imageWithData:data]];
                }else{
                    annotationView.image = [self mergeDotImages:[UIImage imageNamed:@"annotation"] foreGround:[UIImage imageNamed:@"no_avatar"]];
                }

            });
        });

    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    FindFriendsDetailVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"frienddetail"];
    vc.model = mapView.selectedAnnotations.firstObject;
    vc.currentLocation = mapView.userLocation.location;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    annotationSelect = mapView.selectedAnnotations.firstObject;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)pressMapKeyButton:(id)sender
{
    self.mapKeyView.hidden = NO;
    self.mapKeyButton.hidden = YES;
}

- (IBAction)pressWalkingButtom:(id)sender
{
    self.mapKeyView.hidden = YES;
    self.mapKeyButton.hidden = NO;
    
    NSLog(@"Walking button pressed");
}

- (IBAction)pressDrivingButton:(id)sender
{
    self.mapKeyView.hidden = YES;
    self.mapKeyButton.hidden = NO;
    
    NSLog(@"Driving button pressed");
}

- (IBAction)pressFlyingButton:(id)sender
{
    self.mapKeyView.hidden = YES;
    self.mapKeyButton.hidden = NO;
    
    NSLog(@"Flying button pressed");
}

- (IBAction)pressTrainButton:(id)sender
{
    self.mapKeyView.hidden = YES;
    self.mapKeyButton.hidden = NO;
    
    NSLog(@"Train button pressed");
}

- (IBAction)pressFerryButton:(id)sender
{
    self.mapKeyView.hidden = YES;
    self.mapKeyButton.hidden = NO;
    
    NSLog(@"Ferry button pressed");
}

- (IBAction)pressRightBarButton:(id)sender
{
    NSLog(@"Right bar button pressed - Community");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommunityVC   *community =  [storyboard instantiateViewControllerWithIdentifier:@"community"];
    [self.navigationController pushViewController:community animated:YES];
}

- (IBAction)animationAction:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AnimationVC *animation =  [storyboard instantiateViewControllerWithIdentifier:@"AnimationView"];
    [self.navigationController pushViewController:animation animated:YES];
}

- (void)mapView:(MKMapView*)mapView regionDidChangeAnimated:(BOOL)animated
{
//    [self loadDataFromServer];
}

#pragma mark - Utility Function
- (void)loadDataFromServer
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *filter_params = @{@"include":@"photo"};

    NSData *filter_paramsData = [NSJSONSerialization dataWithJSONObject:filter_params options:0 error:nil];
    NSString *filter_paramsStr = [[NSString alloc] initWithData:filter_paramsData encoding:NSUTF8StringEncoding];
    NSString* filter_filterQuery = [NSString stringWithFormat:@"filter=%@", filter_paramsStr];
    
    [[BTAPIClient sharedClient] getPeople:@"people" withFilter:filter_filterQuery withBlock:^(NSArray *models, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error == nil) {
            if ([models isKindOfClass:[NSArray class]]) {
                for (NSDictionary *model in models) {
                    BTPeopleModel *modelPeople = [[BTPeopleModel alloc]initPeopleWithDict:model];
                    BTPhotoModel *modelPhoto = [[BTPhotoModel alloc] initPhotoPeopleWithDict:[model objectForKeyedSubscript:@"photo"]];

                    Annotation *annotation = [Annotation new];
                    if (modelPeople.people_identity)
                    {
                        if ([modelPeople.people_identity objectForKeyedSubscript:@"firstName"])
                        {
                            if ([modelPeople.people_identity objectForKeyedSubscript:@"lastName"])
                            {
                                annotation.userName = [NSString stringWithFormat:@"%@ %@", [modelPeople.people_identity objectForKeyedSubscript:@"firstName"], [modelPeople.people_identity objectForKeyedSubscript:@"lastName"]];
                            }
                            else
                            {
                                annotation.userName = [NSString stringWithFormat:@"%@", [modelPeople.people_identity objectForKeyedSubscript:@"firstName"]];
                            }
                        }
                        else
                        {
                            if ([modelPeople.people_identity objectForKeyedSubscript:@"lastName"])
                            {
                                annotation.userName = [NSString stringWithFormat:@"%@", [modelPeople.people_identity objectForKeyedSubscript:@"lastName"]];
                            }
                            else
                            {
                                annotation.userName = [NSString stringWithFormat:@"%@", @"Killer"];
                            }
                        }
                        annotation.userNumberPhone = [modelPeople.people_identity objectForKeyedSubscript:@"phoneNumber"];
                        annotation.userId = modelPeople.people_Id;
                    }

                    ///////
                    annotation.userAdress = @"1 Pall Mall E London SW1Y 5AU";
                    annotation.dot = @"annotation";
                    if (modelPhoto) {
                         annotation.userAvatar = [NSString stringWithFormat:@"%@/%@", [modelPhoto.photo_data objectForKeyedSubscript:@"dataUrl"], [modelPhoto.photo_data objectForKeyedSubscript:@"filename"]];
                    }

                    annotation.coordinate =CLLocationCoordinate2DMake([[modelPeople.people_lastLocation objectForKeyedSubscript:@"lat"]floatValue], [[modelPeople.people_lastLocation objectForKeyedSubscript:@"lng"] floatValue]);
                    [self.mapView removeAnnotation:annotation];
                    [self.mapView addAnnotation:annotation];

                }
            }
        }
    }];
}


- (UIImage *) mergeDotImages:(UIImage *)bgImage foreGround:(UIImage *)fgImage  {
    UIImage *bottomImage = bgImage; //background image
    UIImage *image       = fgImage; //foreground image
    
    CGSize newSize = CGSizeMake(bottomImage.size.width, bottomImage.size.height);
    UIGraphicsBeginImageContext( newSize );
    
    // Use existing opacity as is
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Apply supplied opacity if applicable
    // Change xPos, yPos if applicable
    [image drawInRect:CGRectMake(4,4,30,30) blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

@end
