//
//  NotificationCell.h
//  NotificationVC1
//
//  Created by Sanchit Thakur on 22/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BTNotificationModel.h"

@interface NotificationCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profilePicImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UIImageView *verticalLineTop;
@property (strong, nonatomic) IBOutlet UIImageView *verticalLineBottom;

- (void)configureNotificationCell:(NSDictionary *)dict;
- (void)InitNotificationWithDict:(BTNotificationModel *)model;

@end
