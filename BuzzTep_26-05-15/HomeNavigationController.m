//
//  HomeNavigationController.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 18/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "HomeNavigationController.h"
#import "AnimationVC.h"

@interface HomeNavigationController ()

@property (nonatomic, strong) UIButton *threeDots;

@end

@implementation HomeNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    
//    CGRect screenSize = [[UIScreen mainScreen] bounds];
//    
//    _threeDots = [[UIButton alloc] initWithFrame:CGRectMake(screenSize.size.width/2 - 10, screenSize.size.height - 70, 50, 50)];
//    
//    [_threeDots setImage:[UIImage imageNamed:@"ellipse6Copy2.png"] forState:UIControlStateNormal];
//    
//    [_threeDots addTarget:self action:@selector(showAnimationView) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:_threeDots];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[AnimationVC class]])
        _threeDots.hidden = YES;
    
    else _threeDots.hidden = NO;
}

- (void)showAnimationView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AnimationVC *animationVC = [storyboard instantiateViewControllerWithIdentifier:@"AnimationView"];
    [self pushViewController:animationVC animated:YES];
}

@end
