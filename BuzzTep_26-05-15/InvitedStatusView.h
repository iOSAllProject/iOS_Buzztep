//
//  ActionsView.h
//  BuzzTepMeetUps
//
//  Created by Sanchit Thakur  on 05/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InvitedStatusView;

@protocol InvitedStatusViewDelegate <NSObject>

- (void)didReceiveGoingStatus:(InvitedStatusView *)view;
- (void)didReceiveMaybeStatus:(InvitedStatusView *)view;
- (void)didReceiveDeclineStatus:(InvitedStatusView *)view;

@end

@interface InvitedStatusView : UIView
@property (weak, nonatomic) id<InvitedStatusViewDelegate> delegate;

+ (InvitedStatusView *)view;

- (void)showOnView:(UIView *)view;
- (void)hide;

@end
