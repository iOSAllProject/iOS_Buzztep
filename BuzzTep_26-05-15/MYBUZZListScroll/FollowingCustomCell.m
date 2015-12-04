//
//  FollowingCustomCell.m
//  Animation
//
//  Created by Sanchit Thakur on 21/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "FollowingCustomCell.h"

@implementation FollowingCustomCell

- (void)awakeFromNib {
    // Initialization code
    
//    _arrowImageView.layer.cornerRadius = _arrowImageView.frame.size.width / 2;
//  _arrowImageView.clipsToBounds = YES;
//    
//    _flightImageView.layer.cornerRadius = _flightImageView.frame.size.width / 2;
//    _flightImageView.clipsToBounds = YES;
//    
//    
//    _picImageView.layer.cornerRadius = _picImageView.frame.size.width / 2;
//    _picImageView.clipsToBounds = YES;

   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)followedAction:(id)sender {
    [self.delegate clickFollowedAction:self.indexPath];
}

@end
