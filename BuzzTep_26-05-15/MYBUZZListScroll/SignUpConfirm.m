//
//  SignUpConfirm.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 16/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "SignUpConfirm.h"
#import "SignUpLicence.h"

@interface SignUpConfirm ()<UITextFieldDelegate>

- (IBAction)backButton:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextfield;

- (IBAction)nextAction:(id)sender;
@end

@implementation SignUpConfirm

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.confirmPasswordTextfield setDelegate:self];
    [self.passwordTextfield setDelegate:self];
    
    [self.passwordTextfield setValue:[UIColor colorWithRed:1.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:1.0]
                          forKeyPath:@"_placeholderLabel.textColor"];
    
    
    [self.confirmPasswordTextfield setValue:[UIColor colorWithRed:1.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:1.0]
                                 forKeyPath:@"_placeholderLabel.textColor"];
    
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.passwordTextfield.leftView = paddingView1;
    self.passwordTextfield.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.confirmPasswordTextfield.leftView = paddingView;
    self.confirmPasswordTextfield.leftViewMode = UITextFieldViewModeAlways;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.confirmPasswordTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -90;
    const float movementDuration = 0.3f;
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextAction:(id)sender {
    SignUpLicence *buzzProfile =[self.storyboard instantiateViewControllerWithIdentifier:@"licence"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
}
@end
