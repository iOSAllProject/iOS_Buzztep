//
//  ConnectionsCustomCell.m
//  Animation
//
//  Created by Sanchit Thakur on 22/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "ConnectionsCustomCell.h"

@implementation ConnectionsCustomCell

- (void)awakeFromNib
{
    self.picImageView.layer.cornerRadius =  self.picImageView.frame.size.height /2;
    self.picImageView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
- (void)configureNotificationCell:(NSDictionary *)dict
{
    _url = dict[@"image"];
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: _url]];
        if ( data == nil )
        {
            _picImageView.image = [UIImage imageNamed:@"no_avata"];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                _picImageView.image = [UIImage imageWithData: data];
            });
        }
    });
    [_btn_follow setBackgroundImage:[UIImage imageNamed:dict[@"arrow"]] forState:UIControlStateNormal];
    _nameLabel.text = dict[@"name"];
}
- (IBAction)doFollow:(id)sender {
    [self.delegate clickFollow:self.indexPath];
}
@end
