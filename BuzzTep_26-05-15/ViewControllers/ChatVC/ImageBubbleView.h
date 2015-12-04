//
//  ImageBubbleView.h

//  Created by Sanchit Thakur on 23/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.

#import <UIKit/UIKit.h>

@interface ImageBubbleView : UIView

typedef enum
{
    MessageBubbleViewTailDirectionRight = 0,
    MessageBubbleViewTailDirectionLeft = 1
} MessageBubbleViewTailDirection;

- (id)initWithText:(NSString *) text
         withColor:(UIColor *) color
withHighlightColor:(UIColor *) highlightColor
 withTailDirection:(MessageBubbleViewTailDirection) tailDirection;

- (id) initWithImage:(UIImage *) image
   withTailDirection:(MessageBubbleViewTailDirection) tailDirection
              atSize:(CGSize) size;
@end
