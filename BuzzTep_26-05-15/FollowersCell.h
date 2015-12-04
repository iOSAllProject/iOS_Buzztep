//
//  FollowersCell.h
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 21/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FollowersDelegate;
@interface FollowersCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *flightImageView;
- (IBAction)followAction:(id)sender;
@property (nonatomic, assign) NSInteger indexPath;
@property (nonatomic, retain) id <FollowersDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btn_followAction;

@end
@protocol FollowersDelegate <NSObject>

- (void)clickFollowerAction :(NSInteger)index;

@end