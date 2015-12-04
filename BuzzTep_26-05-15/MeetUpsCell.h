//
//  CustomCell.h
//  BuzzTepMeetUps
//
//  Created by Sanchit Thakur  on 05/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Meeting.h"
#import "BTMeetUpModel.h"
#import <MapKit/MapKit.h>
#import "BTPeopleModel.h"
#import "BTPhotoModel.h"
@class MeetUpsCell;
@protocol MeetUpsCellDelegate <NSObject>

- (void)didReceiveGoingStatus:(MeetUpsCell *)cell;
- (void)didReceiveMaybeStatus:(MeetUpsCell *)cell;
- (void)didReceiveDeclineStatus:(MeetUpsCell *)cell;

- (void)didGetDirection:(MeetUpsCell *)cell;
- (void)didInvite:(MeetUpsCell *)cell;
- (void)didEditEvent:(MeetUpsCell *)cell;
- (void)didAddToCal:(MeetUpsCell *)cell;
- (void)didSetReminder:(MeetUpsCell *)cell;
- (void)didCancelMeetUp:(MeetUpsCell *)cell;
- (void)didChangeStatus:(MeetUpsCell *)cell;

@end

@interface MeetUpsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) Meeting *model;
@property (strong, nonatomic) BTMeetUpModel* modelMeetUp;
@property (strong, nonatomic) NSDictionary* modelDict;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) id<MeetUpsCellDelegate> delegate;

- (void)updateWithMeeting:(Meeting *)model;
- (void)updateMeetUpWithDict :(NSDictionary*)model;
@end
