//
//  OpenStatusAdminView.h
//  BuzzTepMeetUps
//
//  Created by Sanchit Thakur  on 05/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OpenStatusAdminView;

@protocol OpenStatusAdminViewDelegate <NSObject>

- (void)didGetDirection:(OpenStatusAdminView *)view;
- (void)didInvite:(OpenStatusAdminView *)view;
- (void)didEditEvent:(OpenStatusAdminView *)view;
- (void)didAddToCal:(OpenStatusAdminView *)view;
- (void)didSetReminder:(OpenStatusAdminView *)view;
- (void)didCancelMeetUp:(OpenStatusAdminView *)view;

@end

@interface OpenStatusAdminView : UIView

@property (weak, nonatomic) id<OpenStatusAdminViewDelegate> delegate;

+ (OpenStatusAdminView *)view;
- (void)showOnView:(UIView *)view;
- (void)hide;

@end
