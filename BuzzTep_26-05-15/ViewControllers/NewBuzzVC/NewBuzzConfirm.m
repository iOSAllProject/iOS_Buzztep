//
//  NewBuzzConfirm.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 20/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "NewBuzzConfirm.h"
#import "BuzzProfileVC.h"

@interface NewBuzzConfirm ()

- (IBAction)closeButton:(id)sender;
- (IBAction)myPassportAction:(id)sender;

@end

@implementation NewBuzzConfirm

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)closeButton:(id)sender {
    BuzzProfileVC *buzzProfile =
    [self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
}

- (IBAction)myPassportAction:(id)sender {
    BuzzProfileVC *buzzProfile =
    [self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
}
@end
