//
//  MessageRecipientCell.m
//  CocaColaVC
//
//  Created by Sanchit Thakur on 22/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "MessageRecipientCell.h"

@implementation MessageRecipientCell

- (void)awakeFromNib
{
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configureNotificationCell:(NSDictionary *)dict
{
    _nameLabel.text = dict[@"nameLabel"];
}

@end
