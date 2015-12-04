//
//  MessagesCustomCell.m
//  Animation
//
//  Created by Sanchit Thakur on 22/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "MessagesCustomCell.h"
#import "AppDelegate.h"

@implementation MessagesCustomCell

- (void)awakeFromNib {
    // Initialization code
    self.picImageView.layer.cornerRadius =  self.picImageView.frame.size.height /2;
    self.picImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureNotificationCell:(NSDictionary *)dict
{
    _picImageView.image = [UIImage imageNamed:dict[@"image"]];
    _nameLabel.text = dict[@"name"];
    _timeLabel.text = dict[@"timestamp"];
    _messageLabel.text=dict[@"message"];
}

- (void)initCellWithMessage:(BTMessageModel *)message
                     Person:(BTPeopleModel *)person
{
    NSString* name = Nil;
    NSString* timestamp = Nil;
    NSString* messageStr = Nil;
    
    if (person.people_identity)
    {
        if ([person.people_identity objectForKeyedSubscript:@"firstName"])
        {
            if ([person.people_identity objectForKeyedSubscript:@"lastName"])
            {
                name = [NSString stringWithFormat:@"%@ %@", [person.people_identity objectForKeyedSubscript:@"firstName"], [person.people_identity objectForKeyedSubscript:@"lastName"]];
            }
            else
            {
                name = [NSString stringWithFormat:@"%@", [person.people_identity objectForKeyedSubscript:@"firstName"]];
            }
        }
        else
        {
            if ([person.people_identity objectForKeyedSubscript:@"lastName"])
            {
                name = [NSString stringWithFormat:@"%@", [person.people_identity objectForKeyedSubscript:@"lastName"]];
            }
            else
            {
                name = [NSString stringWithFormat:@"%@", @"Killer"];
            }
        }
    }
    
    if (message.message_createdOn)
    {
        timestamp = [[AppDelegate SharedDelegate] ParseBTServerTime:message.message_createdOn];
    }
    
    if (message.message_text)
    {
        messageStr = message.message_text;
    }
    
    _nameLabel.text = name;
    _timeLabel.text = timestamp;
    _messageLabel.text = messageStr;
    
    _cellMessage = message;
    _cellPerson = person;
    
}

@end
