//
//  SignUpDigits.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 16/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "SignUpDigits.h"
#import "SignUpCodeVC.h"

@interface SignUpDigits ()
- (IBAction)backButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *myTextField;
- (IBAction)nextAction:(id)sender;

@end

@implementation SignUpDigits

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.myTextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextAction:(id)sender {
    SignUpCodeVC *buzzProfile =
    [self.storyboard instantiateViewControllerWithIdentifier:@"signupcode"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
}
@end
