//
//  BTBuzzAltMediaCell.h
//  BUZZtep
//
//  Created by Lin on 7/2/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTBuzzItemModel.h"

@protocol BuzzItemAltCellDelegate <NSObject>

- (void)showMediaDetail:(BTBuzzItemModel* )buzzItem;

@end

@interface BTBuzzAltMediaCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView* profileImage;

@property (strong, nonatomic) IBOutlet UILabel*     lblbprofileName;
@property (strong, nonatomic) IBOutlet UILabel*     lblbuzzTitle;
@property (strong, nonatomic) IBOutlet UILabel*     lblbuzzTime;
@property (strong, nonatomic) IBOutlet UILabel*     lblviewedCount;

@property (strong, nonatomic) IBOutlet UIImageView* imgViewed;

@property (strong, nonatomic) IBOutlet UIImageView* featuredImage;
@property (strong, nonatomic) IBOutlet UIScrollView* mediaScrollView;

@property (strong, nonatomic) IBOutlet UILabel*     lblBucketlistCount;
@property (strong, nonatomic) IBOutlet UILabel*     lblLikeCount;
@property (strong, nonatomic) IBOutlet UILabel*     lblCommentCount;

@property (strong, nonatomic) BTBuzzItemModel*      buzzItem;

@property (nonatomic, assign) id<BuzzItemAltCellDelegate> delegate;

- (void)initCell:(BTBuzzItemModel* )buzzItemModel;
- (IBAction)onMediaDetail:(id)sender;

@end
