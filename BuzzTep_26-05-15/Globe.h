//
//  Globe.h
//  Animation
//
//  Created by Sanchit Thakur on 16/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Globe : UIView

- (void)setRadius:(CGFloat )radiusSet;

//--> allows you to set the images of the buttons. the 0th index is left most button
- (void)setImagesForButtons:(NSArray *)imageArray;

- (void)setCenterButtonImage:(UIImage *)setimage backgroundColor:(UIColor *)color;

//---> color of the shade that goes over the scene that the user sees(by default RED)
- (void)backGroundColor:(UIColor *)color;

@property id delegate;

- (void)setUpGestureRecognition1;
- (void)animate1;
- (void)moveView1:(BOOL)move;
- (void)recomputePositions1;
//- (void)tapped:(UITapGestureRecognizer *)sender;
- (void)tapped;

@end


@protocol MYButtonDelegateProtocol <NSObject>

- (void)tappedButtonWithIndex:(NSInteger )index;

- (void)didTapGlobeViewToOpen:(BOOL)isOpening;

@end
