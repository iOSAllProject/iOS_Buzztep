//
//  BTBuzzItemDetailCell.h
//  BUZZtep
//
//  Created by Lin on 6/29/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTMediaModel.h"

@protocol BTBuzzItemDetailCellDelegate <NSObject>

- (void)expandImage:(UIImageView* )mediaImageView;

@end

@interface BTBuzzItemDetailCell : UITableViewCell

@property (strong, nonatomic) BTMediaModel*     buzzitem_mediModel;

@property (strong, nonatomic) IBOutlet UILabel* buzzitem_descLbl;
@property (strong, nonatomic) IBOutlet UILabel* buzzitem_likeLbl;
@property (strong, nonatomic) IBOutlet UILabel* buzzitem_commentLbl;
@property (strong, nonatomic) IBOutlet UILabel* buzzitem_timeLbl;

@property (strong, nonatomic) IBOutlet UIImageView* buzzitem_mediaView;

@property (nonatomic, assign) id<BTBuzzItemDetailCellDelegate> delegate;

- (void)initCellWithBuzzItemModel:(BTMediaModel* )model;

- (IBAction)onLike:(id)sender;
- (IBAction)onComment:(id)sender;
- (IBAction)onExpandImage:(id)sender;

@end
