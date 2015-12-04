//
//  Flight.h
//  Animation
//
//  Created by Sanchit Thakur on 16/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Flight : UIView


- (void)setRadius:(CGFloat )radiusSet;

//--> allows you to set the images of the buttons. the 0th index is left most button
- (void)setImagesForButtons:(NSArray *)imageArray;

- (void)setCenterButtonImage:(UIImage *)setimage backgroundColor:(UIColor *)color;
//---> color of the shade that goes over the scene that the user sees(by default RED)

- (void)backGroundColor:(UIColor *)color;
- (void)animate;
- (void)moveView:(BOOL)move;

@property id delegate;

@end


@protocol ThrdButtonDelegateProtocol <NSObject>

- (void)tappedButtonWithIndex:(NSInteger )index;
- (void)didTapFlightViewToOpen:(BOOL)isOpening;


@end
