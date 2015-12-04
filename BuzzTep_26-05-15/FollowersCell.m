//
//  FollowersCell.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 21/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "FollowersCell.h"

@implementation FollowersCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)followAction:(id)sender {
    [self.delegate clickFollowerAction:self.indexPath];
}
@end
