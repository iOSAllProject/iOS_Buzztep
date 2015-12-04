//
//  OpenStatusView.h
//  BuzzTepMeetUps
//
//  Created by Sanchit Thakur  on 05/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OpenStatusView;

@protocol OpenStatusViewDelegate <NSObject>

- (void)didGetDirection:(OpenStatusView *)view;
- (void)didAddToCal:(OpenStatusView *)view;
- (void)didSetReminder:(OpenStatusView *)view;
- (void)didChangeStatus:(OpenStatusView *)view;

@end

@interface OpenStatusView : UIView

@property (weak, nonatomic) id<OpenStatusViewDelegate> delegate;

+ (OpenStatusView *)view;
- (void)showOnView:(UIView *)view;
- (void)hide;

@end
