//
//  BuzzItemRWCell.h
//  BUZZtep
//
//  Created by Lin on 6/19/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTBuzzItemModel.h"

@protocol BuzzItemCellDelegate <NSObject>

- (void)lockAction:(BTBuzzItemModel* )buzzItem;
- (void)unlockAction:(BTBuzzItemModel* )buzzItem;
- (void)showMediaDetail:(BTBuzzItemModel* )buzzItem;
- (void)showBuzzEdit:(BTBuzzItemModel* )buzzItem;

@end

@interface BuzzItemRWCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView  *dotImage;
@property (strong, nonatomic) IBOutlet UIImageView  *wy_dotImage;

@property (strong, nonatomic) IBOutlet UIImageView  *featureImage;
@property (strong, nonatomic) IBOutlet UIImageView  *lastImage;
@property (strong, nonatomic) IBOutlet UIImageView  *overlayImage;

@property (strong, nonatomic) IBOutlet UIView       *featureView;
@property (strong, nonatomic) IBOutlet UIButton     *lockButton;
@property (strong, nonatomic) IBOutlet UIButton     *unlockButton;
@property (strong, nonatomic) IBOutlet UIView       *mediaView;

@property (strong, nonatomic) IBOutlet UILabel      *titleLbl;
@property (strong, nonatomic) IBOutlet UILabel      *dateLbl;
@property (strong, nonatomic) IBOutlet UILabel      *wy_dateLbl;
@property (strong, nonatomic) IBOutlet UILabel      *mediaCountLbl;

@property (strong, nonatomic) BTBuzzItemModel*      buzzItem;

@property (nonatomic, assign) id<BuzzItemCellDelegate> delegate;

- (void)initCell:(BTBuzzItemModel* )buzzItemModel timeLineMode:(NSInteger)timemode;

- (IBAction)onLockAction:(id)sender;
- (IBAction)onUnLockAction:(id)sender;
- (IBAction)onMediaDetail:(id)sender;
- (IBAction)onBuzzEdit:(id)sender;

- (void)downloadMedia:(BTBuzzItemModel* )buzzItem;

@end
