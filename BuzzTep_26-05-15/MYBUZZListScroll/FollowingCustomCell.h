//
//  FollowingCustomCell.h
//  Animation
//
//  Created by Sanchit Thakur on 21/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FollowedDelegate;
@interface FollowingCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *flightImageView;

- (IBAction)followedAction:(id)sender;
@property (nonatomic, assign) NSInteger indexPath;
@property (nonatomic, retain) id <FollowedDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btn_followedAction;

@end
@protocol FollowedDelegate <NSObject>

- (void)clickFollowedAction :(NSInteger)index;

@end
