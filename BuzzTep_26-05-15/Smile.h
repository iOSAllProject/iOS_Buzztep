//
//  Smile.h
//  Animation
//
//  Created by Sanchit Thakur on 16/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Smile : UIView
- (void)setRadius:(CGFloat )radiusSet;
- (void)setImagesForButtons:(NSArray *)imageArray;
- (void)setCenterButtonImage:(UIImage *)setimage backgroundColor:(UIColor *)color;
- (void)backGroundColor:(UIColor *)color;
- (void)animate;
- (void)moveView:(BOOL)move;

@property id delegate;

@end


@protocol RGButtonDelegateProtocol <NSObject>

- (void)tappedButtonWithIndex:(NSInteger )index;
- (void)setUpGestureRecognition;
- (void)didTapSmileViewToOpen:(BOOL)isOpening;

@end
