//
//  UIImage+Utils.h

//  Created by Sanchit Thakur on 23/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

- (UIImage *) renderAtSize:(const CGSize) size;
- (UIImage *) maskWithImage:(const UIImage *) maskImage;
- (UIImage *) maskWithColor:(UIColor *) color;
- (UIImage*) maskimagewithMask:(const UIImage *)maskImage;
- (UIImage*)scaleToSize:(CGSize)size;

@end
