//
//  MessagesCustomCell.h
//  Animation
//
//  Created by Sanchit Thakur on 22/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTMessageModel.h"
#import "BTPeopleModel.h"

@interface MessagesCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) BTMessageModel* cellMessage;
@property (nonatomic, strong) BTPeopleModel* cellPerson;

- (void)configureNotificationCell:(NSDictionary *)dict;

- (void)initCellWithMessage:(BTMessageModel *)message
                     Person:(BTPeopleModel *)person;

@end
