//
//  SignUpLicence.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 16/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "SignUpLicence.h"
#import "InviteFriends.h"

@interface SignUpLicence ()
- (IBAction)backButton:(id)sender;
- (IBAction)acceptAction:(id)sender;

@end

@implementation SignUpLicence

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)acceptAction:(id)sender {
    InviteFriends *buzzProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"invitefriends"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
}
@end
