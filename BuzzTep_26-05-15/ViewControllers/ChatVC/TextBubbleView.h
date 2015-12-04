//
//  TextBubbleView.h

//  Created by Sanchit Thakur on 23/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.

#import <UIKit/UIKit.h>

@interface TextBubbleView : UIView

typedef enum
{
    MessageBubbleViewButtonTailDirectionRight = 0,
    MessageBubbleViewButtonTailDirectionLeft = 1
}
MessageBubbleViewButtonTailDirection;

- (id)initWithText:(NSString *) text
         withColor:(UIColor *) color
withHighlightColor:(UIColor *) highlightColor
 withTailDirection:(MessageBubbleViewButtonTailDirection)tailDirection
          maxWidth:(CGFloat) maxWidth;



@end
