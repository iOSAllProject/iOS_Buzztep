//
//  Smile.m
//  Animation
//
//  Created by Sanchit Thakur on 16/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "Smile.h"
#import "Globe.h"
#import "Flight.h"

@implementation Smile
{
    UIButton *b3;
    UIButton *b4;
    UIButton *b5;
    
    UIWindow *mainWindow;
    
    UITapGestureRecognizer *tapRecognizer;
    
    UIView *darkerView;
    
    //setup for final locations of the buttons
    CGFloat radius;
    CGPoint position3;
    CGPoint position4;
    CGPoint position5;
    
    CGPoint centerPoint;
    
    CGSize size;
    BOOL tapped;
    
    //--->
    UIImage *image;
    UIImageView *imageView;
    
    //--->
    BOOL firstTime;
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self setUpViewHierrachy];
        [self setUpGestureRecognition];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if(self)
    {
        [self setUpViewHierrachy];
        [self setUpGestureRecognition];
    }
    return self;
}
- (void)setUpViewHierrachy
{
    tapped = NO;
    //CGSize buttonSize = self.bounds.size;
    //--> get the window
    mainWindow = (UIWindow *)[UIApplication sharedApplication].windows [0];
    //Point in the window
    
    centerPoint = [mainWindow convertPoint:self.center fromView:self.superview];
    centerPoint = CGPointMake(centerPoint.x - (self.bounds.size.width/4) , centerPoint.y - (self.bounds.size.width/2));
    
    b3 = [[UIButton alloc]initWithFrame:CGRectMake(centerPoint.x, centerPoint.y, 0, 0)];
    b4 = [[UIButton alloc]initWithFrame:CGRectMake(centerPoint.x, centerPoint.y, 0, 0)];
    b5 = [[UIButton alloc]initWithFrame:CGRectMake(centerPoint.x, centerPoint.y, 0, 0)];
    
    
    [b3 addTarget:self action:@selector(button3) forControlEvents:UIControlEventTouchUpInside];
    [b4 addTarget:self action:@selector(button4) forControlEvents:UIControlEventTouchUpInside];
    [b5 addTarget:self action:@selector(button5) forControlEvents:UIControlEventTouchUpInside];
    
    [self visibility:NO];
    [self makeTheViewsCircular];
    
    darkerView = [[UIView alloc]initWithFrame:mainWindow.bounds];
    darkerView.alpha = .7;
    darkerView.userInteractionEnabled = NO;
    radius = 170;
    
    position3 = CGPointMake(centerPoint.x + radius * cos(M_PI/2), centerPoint.y - radius* sin(M_PI/2));
    position4 = CGPointMake(centerPoint.x + radius * cos(2 * M_PI/3),centerPoint.y - radius* sin(2 * M_PI/3));
    position5 = CGPointMake(centerPoint.x + radius * cos(5 * M_PI/6),centerPoint.y - radius* sin(5 * M_PI/6));
    
    size = CGSizeMake(self.bounds.size.width/1.5,self.bounds.size.height/1.5);
    
    imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:imageView];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.layer.bounds.size.width /2;
    self.layer.cornerRadius = self.layer.bounds.size.width/2;
    
}
- (void)setUpGestureRecognition
{
    tapRecognizer  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tapRecognizer];
}
//#pragma mark - Circle
- (void)makeLayerCircular:(CALayer *)layer
{
    layer.cornerRadius = layer.bounds.size.width /4 ;
    
}
- (void)makeTheViewsCircular
{
    [self makeLayerCircular:b3.layer];
    [self makeLayerCircular:b4.layer];
    [self makeLayerCircular:b5.layer];
}
// #pragma mark - Tap Gesture
- (void)tapped:(UITapGestureRecognizer *)sender
{
    [self animate];
}
// #pragma  mark - Positions
- (void)moveView:(BOOL)move
{
    tapped = move;
    if (_delegate && [_delegate respondsToSelector:@selector(didTapSmileViewToOpen:)])
    {
        [_delegate didTapSmileViewToOpen:move];
    }
    
    if(move)//move the views out
    {
        [mainWindow addSubview:darkerView];
        [mainWindow addSubview:b3];
        [mainWindow addSubview:b4];
        [mainWindow addSubview:b5];
        
        [self visibility:YES];
        b3.frame = CGRectMake(position3.x-3, position3.y+55, size.width+8, size.height+8);
        b4.frame = CGRectMake(position4.x-3, position4.y+65, size.width+8, size.height+8);
        b5.frame = CGRectMake(position5.x+25, position5.y+90, size.width+8, size.height+8);
    }
    else//move the views to the center
    {
        [UIView animateWithDuration:.5
                         animations:^{
                             CGAffineTransform identityTransform = CGAffineTransformIdentity;
                             self.transform = identityTransform;
                             b3.frame = CGRectMake(centerPoint.x, centerPoint.y,self.bounds.size.width/2, self.bounds.size.width/2);
                             b4.frame = CGRectMake(centerPoint.x, centerPoint.y,self.bounds.size.width/2, self.bounds.size.width/2);
                             b5.frame = CGRectMake(centerPoint.x, centerPoint.y,self.bounds.size.width/2, self.bounds.size.width/2);
                             darkerView.alpha = 0.0;
                             [self visibility:NO];
                         }
                         completion:^(BOOL finished) {
                             [self visibility:YES];
                             [darkerView removeFromSuperview];
                             [b3 removeFromSuperview];
                             [b4 removeFromSuperview];
                             [b5 removeFromSuperview];
                             darkerView.alpha = 0.5;
                         }];
    }
}
#pragma mark - Inivisible
- (void)visibility:(BOOL)visible
{
    if(!visible)
    {
        b3.alpha = 0.0;
        b4.alpha = 0.0;
        b4.alpha = 0.0;
        b5.alpha = 0.0;
    }
    else
    {
        b3.alpha = 1.0;
        b4.alpha = 1.0;
        b4.alpha = 1.0;
        b5.alpha = 1.0;
    }
}
- (void)recomputePositions
{
    position3 = CGPointMake(centerPoint.x + radius * cos(M_PI/2), centerPoint.y - radius* sin(M_PI/2));
    position4 = CGPointMake(centerPoint.x + radius * cos(2 * M_PI/3),centerPoint.y - radius* sin(2 * M_PI/3));
    position5 = CGPointMake(centerPoint.x + radius * cos(5 * M_PI/6),centerPoint.y - radius* sin(5 * M_PI/6));
}

#pragma mark - Configuration
#pragma mark - Setting size of the view
- (void)setSize:(CGSize )buttonSize
{
    size = buttonSize;
}
- (void)setRadius:(CGFloat )radiusSet
{
    radius = radiusSet;
    [self recomputePositions];
}
- (void)button3
{
    [self animate];
    
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(tappedButtonWithIndex:)])
    {
        [self.delegate tappedButtonWithIndex:3];
    }
}
- (void)button4
{
    [self animate];
    // NSLog(@"hiii");
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(tappedButtonWithIndex:)])
    {
        [self.delegate tappedButtonWithIndex:9];
    }
}
- (void)button5
{
    [self animate];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(tappedButtonWithIndex:)])
    {
        [self.delegate tappedButtonWithIndex:5];
    }
}
#pragma mark - Animations
- (void)animate
{
    [UIView animateWithDuration:0.7
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:0
                     animations:^
     {
         [self moveView:!tapped];
         //                         tapped = !tapped;
     }
                     completion:^(BOOL finished)
     {
         
     }];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    centerPoint = [mainWindow convertPoint:self.center fromView:self.superview];
    centerPoint = CGPointMake(centerPoint.x - (self.bounds.size.width/4),centerPoint.y-(self.bounds.size.width/2));
    
    [self recomputePositions];
    [darkerView setFrame:mainWindow.bounds];
}
- (void)setImagesForButtons:(NSArray *)imageArray
{
    [b3 setImage:imageArray[0] forState:UIControlStateNormal];
    [b4 setImage:imageArray[1] forState:UIControlStateNormal];
    [b5 setImage:imageArray[2] forState:UIControlStateNormal];
}
- (void)setCenterButtonImage:(UIImage *)setimage backgroundColor:(UIColor *)color;
{
    imageView.image = setimage;
    self.backgroundColor = color;
}
- (void)backGroundColor:(UIColor *)color
{
    darkerView.backgroundColor = color;
}
@end
