//
//  Cocacola.m
//  CocaColaVC
//
//  Created by Sanchit Thakur on 22/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "Cocacola.h"
#import "BuzzViewController.h"
#import "AppDelegate.h"
#import "AnimationVC.h"

@interface Cocacola ()

@property (strong, nonatomic) IBOutlet UIButton *myBuzz;
@property (strong, nonatomic) IBOutlet UIButton *myFootPrint;

- (IBAction)myBuzzAction:(id)sender;
- (IBAction)myFootPrintAction:(id)sender;
- (IBAction)followingAction:(id)sender;
- (IBAction)buzzcountAction:(id)sender;
- (IBAction)followersAction:(id)sender;
- (IBAction)animationAction:(id)sender;
- (IBAction)pinAction:(id)sender;
- (IBAction)leftArrowAction:(id)sender;


@end

@implementation Cocacola

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setWhiteBorderFor:self.myBuzz];
    [self setWhiteBorderFor:self.myFootPrint];
}

- (void)setWhiteBorderFor:(UIView*)view
{
    view.layer.borderWidth = 2.0;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)myBuzzAction:(id)sender
{
    //coca-cola Buzz
    
    BuzzViewController *buzzlist = [self.storyboard instantiateViewControllerWithIdentifier:@"viewcontroller"];
    [self.navigationController pushViewController:buzzlist animated:YES];
    
}

- (IBAction)myFootPrintAction:(id)sender
{
}

- (IBAction)followingAction:(id)sender
{
}

- (IBAction)buzzcountAction:(id)sender
{
}

- (IBAction)followersAction:(id)sender
{
}

- (IBAction)animationAction:(id)sender
{
    AnimationVC *animation=[self.storyboard instantiateViewControllerWithIdentifier:@"AnimationView"];
    [self.navigationController pushViewController:animation animated:YES];
}

- (IBAction)pinAction:(id)sender
{
}

- (IBAction)leftArrowAction:(id)sender
{
}


@end
