//
//  CommunityCustomCell.m
//  BUZZtep
//
//  Created by Mac on 6/26/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "CommunityCustomCell.h"

@implementation CommunityCustomCell

- (void)awakeFromNib {
    self.picImageView.layer.cornerRadius =  self.picImageView.frame.size.height /2;
    self.picImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (IBAction)doFollow:(id)sender {
    [self.delegate clickFollow:self.indexPath];
}



- (void)configureNotificationCell:(NSDictionary *)dict
{
    _url = dict[@"image"];
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: _url]];
        if ( data == nil )
        {
            _picImageView.image = [UIImage imageNamed:@"no_avatar"];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                _picImageView.image = [UIImage imageWithData: data];
            });
        }
    });
    _nameLabel.text = dict[@"name"];
    [_btn_follow setBackgroundImage:[UIImage imageNamed:dict[@"arrow"]] forState:UIControlStateNormal];
}
@end
