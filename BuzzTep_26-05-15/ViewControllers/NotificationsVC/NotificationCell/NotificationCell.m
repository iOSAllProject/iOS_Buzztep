//
//  NotificationCell.m
//  NotificationVC1
//
//  Created by Sanchit Thakur on 22/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "NotificationCell.h"
#import "AppDelegate.h"

@interface NotificationCell ()

@end

@implementation NotificationCell

@synthesize profilePicImageView;
@synthesize nameLabel;
@synthesize timeLabel;

- (void)awakeFromNib
{
    // Initialization code
    self.profilePicImageView.layer.cornerRadius =  self.profilePicImageView.frame.size.height /2;
    self.profilePicImageView.layer.masksToBounds = YES;
    self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rightgreenarrow.png"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)configureNotificationCell:(NSDictionary *)dict
{
    self.profilePicImageView.image = [UIImage imageNamed:dict[@"image"]];
    self.nameLabel.text = dict[@"message"];
    self.timeLabel.text = dict[@"timestamp"];
}

- (void)InitNotificationWithDict:(BTNotificationModel *)model
{
    NSString* messageStr = Nil;
    NSString* timestampStr = Nil;
    
    if (model.notification_text)
    {
        messageStr = [NSString stringWithFormat:@"%@", model.notification_text];
    }
    
    if (model.notification_createdOn)
    {
        timestampStr = [[AppDelegate SharedDelegate] ParseBTServerTime:model.notification_createdOn];
    }
    
    self.nameLabel.text = messageStr;
    self.timeLabel.text = timestampStr;
}

@end
