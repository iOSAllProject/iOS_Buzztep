//
//  CustomCell.m
//  BuzzTepMeetUps
//
//  Created by Sanchit Thakur  on 05/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "MeetUpsCell.h"
#import "InvitedStatusView.h"
#import "OpenStatusView.h"
#import "OpenStatusAdminView.h"

@interface MeetUpsCell () <InvitedStatusViewDelegate, OpenStatusViewDelegate, OpenStatusAdminViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *meetName;
@property (weak, nonatomic) IBOutlet UILabel *meetDate;
@property (weak, nonatomic) IBOutlet UILabel *meetAdress;
@property (weak, nonatomic) IBOutlet UILabel *firstUserName;
@property (weak, nonatomic) IBOutlet UILabel *secondUserName;
@property (weak, nonatomic) IBOutlet UILabel *thirdUserName;

@property (weak, nonatomic) IBOutlet UIImageView *firstUserAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *secondUserAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *thirdUserAvatar;

@property (strong, nonatomic) InvitedStatusView *invitedStatusView;
@property (strong, nonatomic) OpenStatusView *openStatusView;
@property (strong, nonatomic) OpenStatusAdminView *openAdminStatusView;

- (IBAction)pressActionButton:(id)sender;
- (IBAction)pressCalendarButton:(id)sender;

@end

@implementation MeetUpsCell

- (void)awakeFromNib {
    self.invitedStatusView = [InvitedStatusView view];
    self.invitedStatusView.delegate = self;
    
    self.openStatusView = [OpenStatusView view];
    self.openStatusView.delegate = self;
    
    self.openAdminStatusView = [OpenStatusAdminView view];
    self.openAdminStatusView.delegate = self;
}

- (void)updateWithMeeting:(Meeting *)model
{
    [self.invitedStatusView removeFromSuperview];
    
    _model = model;
    
    self.meetName.text = model.meetName;
    self.meetDate.text = model.meetDate;
    self.meetAdress.text = model.meetAddress;
    self.firstUserName.text = model.meetFirstUserName;
    self.secondUserName.text = model.meetSecondUserName;
    self.thirdUserName.text = model.meetThirdUserName;
    
    self.firstUserAvatar.image = [UIImage imageNamed:@"avatar_1.png"];
    self.secondUserAvatar.image = [UIImage imageNamed:@"avatar_2.png"];
    self.thirdUserAvatar.image = [UIImage imageNamed:@"avatar_3.png"];
}

- (void)updateMeetUpWithDict :(NSDictionary*)model{
    [self.invitedStatusView removeFromSuperview];
    _modelDict = model;
    _modelMeetUp = [[BTMeetUpModel alloc] initMeetUpWithDict:model];
    
    self.meetName.text = _modelMeetUp.meetup_title;
    self.meetDate.text = [self convertDayToString:_modelMeetUp.meetup_createdOn];
    [self getAddressFromLocation:[[CLLocation alloc] initWithLatitude:[[_modelMeetUp.meetup_scheduledLocation objectForKeyedSubscript:@"lat"] floatValue] longitude:[[_modelMeetUp.meetup_scheduledLocation objectForKeyedSubscript:@"lng"] floatValue]] complationBlock:^(NSString *address) {
        self.meetAdress.text = address;
    }];
    //Map View
    self.mapView.showsUserLocation = YES;
    self.mapView.mapType = 	MKMapTypeStandard;
    MKCoordinateRegion region;
    CLLocationCoordinate2D initialCoordinate = CLLocationCoordinate2DMake([[_modelMeetUp.meetup_scheduledLocation objectForKeyedSubscript:@"lat"] floatValue], [[_modelMeetUp.meetup_scheduledLocation objectForKeyedSubscript:@"lat"] floatValue]);

    region.center.latitude = initialCoordinate.latitude;
    region.center.longitude = initialCoordinate.longitude;
    region.span.latitudeDelta = .05;
    region.span.longitudeDelta = .05;
    [self.mapView setRegion:region animated:NO];

    //User
    [self initScroll :model];
}
- (void)didReceiveGoingStatus:(MeetUpsCell *)cell
{
    [self.delegate didReceiveGoingStatus:self];
}

- (void)didReceiveMaybeStatus:(MeetUpsCell *)cell
{
    [self.delegate didReceiveMaybeStatus:self];
}

- (void)didReceiveDeclineStatus:(MeetUpsCell *)cell
{
    [self.delegate didReceiveDeclineStatus:self];
}

- (void)didGetDirection:(MeetUpsCell *)cell
{
    [self.delegate didGetDirection:self];
}

- (void)didInvite:(MeetUpsCell *)cell
{
    [self.delegate didInvite:self];
}

- (void)didEditEvent:(MeetUpsCell *)cell
{
    [self.delegate didEditEvent:self];
}

- (void)didAddToCal:(MeetUpsCell *)cell
{
    [self.delegate didAddToCal:self];
}

- (void)didSetReminder:(MeetUpsCell *)cell
{
    [self.delegate didSetReminder:self];
}

- (void)didCancelMeetUp:(MeetUpsCell *)cell
{
    [self.delegate didCancelMeetUp:self];
}

- (void)didChangeStatus:(MeetUpsCell *)cell
{
    [self.delegate didChangeStatus:self];
}

- (IBAction)pressActionButton:(id)sender
{
    UIButton *button = (UIButton*)sender;
    if ([button.currentTitle isEqualToString:@""]) {
        [self.openAdminStatusView showOnView:self.contentView];
    }else{
        [self.invitedStatusView showOnView:self.contentView];
    }
}

- (IBAction)pressCalendarButton:(id)sender
{
    [self.openAdminStatusView showOnView:self.contentView];
}

-(NSString*)convertDayToString:(NSString*)createdOn{
    NSString* dateStr = [[NSString stringWithFormat:@"%@",createdOn] componentsSeparatedByString:@"T"][0];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"EEEE, MMMM dd";
    NSDate *myDate = [df dateFromString: dateStr];
    NSString *dateString = [dateFormatter stringFromDate: myDate];
    return dateString;
}

typedef void(^addressCompletion)(NSString *);

-(void)getAddressFromLocation:(CLLocation *)location complationBlock:(addressCompletion)completionBlock
{
    __block CLPlacemark* placemark;
    __block NSString *address = nil;

    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil && [placemarks count] > 0)
         {
             placemark = [placemarks lastObject];
             address = [NSString stringWithFormat:@"%@, %@ %@", placemark.name, placemark.postalCode, placemark.locality];
             completionBlock(address);
         }
     }];
}
// 100x73
- (void)initScroll:(NSDictionary*)model{
    NSMutableArray* invites = [[NSMutableArray alloc] initWithArray:[model objectForKeyedSubscript:@"invites"]];

    self.scrollView.delaysContentTouches = NO;
    for (int i = 0; i< invites.count; i++) {
        CGRect frame;
        frame.origin.x = 100 * i;
        frame.origin.y = 0;
        frame.size = CGSizeMake(100, 73);

        NSDictionary *peopleDic = [[invites objectAtIndex:i] objectForKeyedSubscript:@"person"];
        BTPeopleModel *peopleModel = [[BTPeopleModel alloc]initPeopleWithDict:peopleDic];
        BTPhotoModel *photoModel = [[BTPhotoModel alloc]initPhotoPeopleWithDict:[peopleDic objectForKeyedSubscript:@"photo"]];



        UIView *view = [[UIView alloc]initWithFrame:frame];

        UIImageView *avataImage = [[UIImageView alloc]initWithFrame:CGRectMake(30, 5, 40, 40)];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, 100, 12)];
        [nameLabel setFont:[UIFont fontWithName:@"OpenSans" size:12.0f]];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = [NSString stringWithFormat:@"%@ %@",[peopleModel.people_identity objectForKeyedSubscript:@"firstName"],[peopleModel.people_identity objectForKeyedSubscript:@"lastName"]];
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(q, ^{

            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[photoModel.photo_data objectForKeyedSubscript:@"dataUrl"],[photoModel.photo_data objectForKeyedSubscript:@"filename"]]]];
            if (data == nil) {
                avataImage.image = [UIImage imageNamed:@"no_avatar.png"];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    avataImage.image = [UIImage imageWithData: data];
                });
            }

        });

        [view addSubview:avataImage];
        [view addSubview:nameLabel];
        [self.scrollView addSubview:view];
    }
    self.scrollView.contentSize = CGSizeMake(100*invites.count , self.scrollView.frame.size.height);
}
@end
