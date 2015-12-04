//
//  BTBuzzWhoCell.h
//  BUZZtep
//
//  Created by Lin on 6/25/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTBuzzWhoCell : UITableViewCell

@property (strong, nonatomic) IBOutlet  UIImageView* friendImg;
@property (strong, nonatomic) IBOutlet  UILabel*     friendName;
@property (strong, nonatomic) IBOutlet  UIButton*    friendSelectBtn;
@property (assign, atomic)              BOOL         friendSelected;


- (void)selectFriend;

@end
