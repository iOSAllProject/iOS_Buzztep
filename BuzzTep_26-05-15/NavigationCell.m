//
//  NavigationCell.m
//  NotificationVC1
//
//  Created by Sanchit Thakur on 21/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "NavigationCell.h"

@interface NavigationCell ()

@property (strong, nonatomic) IBOutlet UILabel *names;

@end

@implementation NavigationCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWith:(NSString *)title atIndex:(NSInteger)index
{
    self.names.text = title;
}

@end
