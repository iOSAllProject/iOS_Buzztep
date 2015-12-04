//
//  Globe.m
//  Animation
//
//  Created by Sanchit Thakur on 16/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "Globe.h"

@implementation Globe
{
    UIButton *b1;
    UIButton *b2;
    UIButton *b3;
    UIWindow *mainWindow;
    UITapGestureRecognizer *tapRecognizer1 ;
    UIView *darkerView;
    
    //setup for final locations of the buttons
    CGFloat radius;
    CGPoint position1;
    CGPoint position2;
    CGPoint position3;
    
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
        [self setUpGestureRecognition1];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if(self)
    {
        [self setUpViewHierrachy];
        [self setUpGestureRecognition1];
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
    // NSLog(@"Center Point: %@",NSStringFromCGPoint(centerPoint));
    
    b1 = [[UIButton alloc]initWithFrame:CGRectMake(centerPoint.x, centerPoint.y, 0, 0)];
    b2 = [[UIButton alloc]initWithFrame:CGRectMake(centerPoint.x, centerPoint.y, 0, 0)];
    b3 = [[UIButton alloc]initWithFrame:CGRectMake(centerPoint.x, centerPoint.y, 0, 0)];
    
    
    [b1 addTarget:self action:@selector(button1) forControlEvents:UIControlEventTouchUpInside];
    [b2 addTarget:self action:@selector(button2) forControlEvents:UIControlEventTouchUpInside];
    [b3 addTarget:self action:@selector(button3) forControlEvents:UIControlEventTouchUpInside];
    
    [self visibility:NO];
    [self makeTheViewsCircular];
    darkerView = [[UIView alloc]initWithFrame:mainWindow.bounds];
    darkerView.alpha = .7;
    darkerView.userInteractionEnabled = NO;
    radius = 170;
    
    
    position1 = CGPointMake(centerPoint.x + radius * cos(M_PI/6), centerPoint.y - radius* sin(M_PI/6));
    position2 = CGPointMake(centerPoint.x + radius * cos(M_PI/3), centerPoint.y - radius* sin(M_PI/3));
    position3 = CGPointMake(centerPoint.x + radius * cos(M_PI/2), centerPoint.y - radius* sin(M_PI/2));
    
    size = CGSizeMake(self.bounds.size.width/1.5,self.bounds.size.height/1.5);
    
    
    imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self addSubview:imageView];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.layer.bounds.size.width /2;
    self.layer.cornerRadius = self.layer.bounds.size.width/2;
    
}

- (void)setUpGestureRecognition1
{
    tapRecognizer1  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    [self addGestureRecognizer:tapRecognizer1];
}

#pragma mark - Circle
- (void)makeLayerCircular:(CALayer *)layer
{
    layer.cornerRadius = layer.bounds.size.width /4 ;
    
}

- (void)makeTheViewsCircular
{
    [self makeLayerCircular:b1.layer];
    [self makeLayerCircular:b2.layer];
    [self makeLayerCircular:b3.layer];
}


#pragma mark - Tap Gesture
- (void)tapped
{
    [self animate1];
}


#pragma  mark - Positions
- (void)moveView1:(BOOL)move
{
    tapped = move;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didTapGlobeViewToOpen:)])
    {
        [_delegate didTapGlobeViewToOpen:move];
    }
    
    if(move)//move the views out
    {
        [mainWindow addSubview:darkerView];
        [mainWindow addSubview:b1];
        [mainWindow addSubview:b2];
        [mainWindow addSubview:b3];
        
        [self visibility:YES];
        
        b1.frame = CGRectMake(position1.x-37, position1.y+78, size.width+8, size.height+8);
        b2.frame = CGRectMake(position2.x-20, position2.y+55, size.width+8, size.height+8);
        b3.frame = CGRectMake(position3.x-30, position3.y+55, size.width+8, size.height+8);
        
    }
    
    else//move the views to the center
    {
        
        [UIView animateWithDuration:.5
                         animations:^{
                             
                             CGAffineTransform identityTransform = CGAffineTransformIdentity;
                             self.transform = identityTransform;
                             b1.frame = CGRectMake(centerPoint.x, centerPoint.y,self.bounds.size.width/2, self.bounds.size.width/2);
                             b2.frame = CGRectMake(centerPoint.x, centerPoint.y,self.bounds.size.width/2, self.bounds.size.width/2);
                             b3.frame = CGRectMake(centerPoint.x, centerPoint.y,self.bounds.size.width/2, self.bounds.size.width/2);
                             
                             darkerView.alpha = 0.0;
                             [self visibility:NO];
                         }
                         completion:^(BOOL finished)
         {
             [self visibility:YES];
             [darkerView removeFromSuperview];
             [b1 removeFromSuperview];
             [b2 removeFromSuperview];
             [b3 removeFromSuperview];
             darkerView.alpha = 0.5;
             
         }];
    }
}
#pragma mark - Inivisible

- (void)visibility:(BOOL)visible
{
    if(!visible)
    {
        b1.alpha = 0.0;
        b2.alpha = 0.0;
        b3.alpha = 0.0;
    }
    else
    {
        b1.alpha = 1.0;
        b2.alpha = 1.0;
        b3.alpha = 1.0;
        
    }
}
- (void)recomputePositions1
{
    position1 = CGPointMake(centerPoint.x + radius * cos(M_PI/6), centerPoint.y - radius* sin(M_PI/6));
    position2 = CGPointMake(centerPoint.x + radius * cos(M_PI/3),centerPoint.y - radius* sin(M_PI/3));
    position3 = CGPointMake(centerPoint.x + radius * cos(M_PI/2), centerPoint.y - radius* sin(M_PI/2));
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
    [self recomputePositions1];
}
#pragma mark -

- (void)button1
{
    [self animate1];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(tappedButtonWithIndex:)])
    {
        [self.delegate tappedButtonWithIndex:1];
    }
}
- (void)button2
{
    [self animate1];
    if(self.delegate && [self.delegate respondsToSelector:@selector(tappedButtonWithIndex:)])
    {
        [self.delegate tappedButtonWithIndex:8];
    }
}
- (void)button3
{
    [self animate1];
    if(self.delegate && [self.delegate respondsToSelector:@selector(tappedButtonWithIndex:)])
    {
        [self.delegate tappedButtonWithIndex:7];
        // NSLog(@"mapping");
    }
}
#pragma mark - Animations
- (void)animate1
{
    [UIView animateWithDuration:0.7
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:0
                        options:0
                     animations:^{
                         
                         [self moveView1:!tapped];
                         
                     }
                     completion:^(BOOL finished)
     {
     }];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    centerPoint = [mainWindow convertPoint:self.center fromView:self.superview];
    centerPoint = CGPointMake(centerPoint.x - (self.bounds.size.width/4) , centerPoint.y - (self.bounds.size.width/2));
    
    [self recomputePositions1];
    [darkerView setFrame:mainWindow.bounds];
}
- (void)setImagesForButtons:(NSArray *)imageArray
{
    [b1 setImage:imageArray[0] forState:UIControlStateNormal];
    [b2 setImage:imageArray[1] forState:UIControlStateNormal];
    [b3 setImage:imageArray[2] forState:UIControlStateNormal];
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
