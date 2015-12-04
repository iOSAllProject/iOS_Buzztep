//
//  BTBuzzAltNoMediaCell.h
//  BUZZtep
//
//  Created by Lin on 7/2/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTBuzzItemModel.h"

@interface BTBuzzAltNoMediaCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView* profileImage;

@property (strong, nonatomic) IBOutlet UILabel*     lblbprofileName;
@property (strong, nonatomic) IBOutlet UILabel*     lblbuzzTitle;
@property (strong, nonatomic) IBOutlet UILabel*     lblbuzzTime;
@property (strong, nonatomic) IBOutlet UILabel*     lblviewedCount;

@property (strong, nonatomic) IBOutlet UIImageView* imgViewed;

@property (strong, nonatomic) BTBuzzItemModel*      buzzItem;

- (void)initCell:(BTBuzzItemModel* )buzzItemModel;

@end
