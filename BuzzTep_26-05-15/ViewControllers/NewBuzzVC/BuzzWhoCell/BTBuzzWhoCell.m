//
//  BTBuzzWhoCell.m
//  BUZZtep
//
//  Created by Lin on 6/25/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTBuzzWhoCell.h"

@implementation BTBuzzWhoCell

- (void)awakeFromNib {
    // Initialization code
        
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)selectFriend
{
    if (self.friendSelected)
    {
        [self.friendSelectBtn setBackgroundImage:[UIImage imageNamed:@"new_buzz_friend_selected"]
                                        forState:UIControlStateNormal];
    }
    else
    {
        [self.friendSelectBtn setBackgroundImage:[UIImage imageNamed:@"new_buzz_friend_unselected"]
                                        forState:UIControlStateNormal];
    }
}
@end
