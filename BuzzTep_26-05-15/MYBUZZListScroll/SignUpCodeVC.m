//
//  SignUpCodeVC.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 16/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "SignUpCodeVC.h"
#import "SignUpConfirm.h"

@interface SignUpCodeVC ()<UITextFieldDelegate>

- (IBAction)backButton:(id)sender;
- (IBAction)sendItAgainAction:(id)sender;
- (IBAction)nextAction:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *myTextField;

@end

@implementation SignUpCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.myTextField setDelegate:self];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.myTextField resignFirstResponder];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
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

- (IBAction)sendItAgainAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextAction:(id)sender {
    SignUpConfirm *buzzProfile =
    [self.storyboard instantiateViewControllerWithIdentifier:@"confirm"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
}
@end
