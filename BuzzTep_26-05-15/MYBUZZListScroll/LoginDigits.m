//
//  LoginDigits.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 16/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "LoginDigits.h"

@interface LoginDigits ()
- (IBAction)backButton:(id)sender;
- (IBAction)backVC:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *myTextField;

@end

@implementation LoginDigits

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
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

- (IBAction)backVC:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
