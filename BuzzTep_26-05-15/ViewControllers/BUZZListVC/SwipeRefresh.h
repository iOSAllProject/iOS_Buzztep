
#import <UIKit/UIKit.h>

@interface SwipeRefresh : UIControl

@property (nonatomic, retain, setter=setColors:) NSArray *colors;

- (id)initWithScrollView:(UIScrollView *)scrollView;

- (void)endRefreshing;

// in case when navigation bar is not tranparent set 0
- (void)setMarginTop:(CGFloat)topMargin;

@end
