//
//  MessageFilledVC.m
//  CocaColaVC
//
//  Created by Sanchit Thakur on 22/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "MessageFilledVC.h"
#import "MessagesVC.h"
#import "AppDelegate.h"

#import "BTAPIClient.h"
#import "MBProgressHUD.h"
#import "Constant.h"

#import "ChatViewController.h"

@interface MessageFilledVC ()

- (IBAction)backButton:(id)sender;
- (IBAction)sendMessage:(id)sender;
- (void) postMessage:(NSString* )message;

@end

@implementation MessageFilledVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.messageField.delegate = self;    
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureRight)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeGesture];
    
}

-(void)handleSwipeGestureRight
{
    MessagesVC *BPVC=[self.storyboard instantiateViewControllerWithIdentifier:@"addrecipient"];
    [self.navigationController pushViewController:BPVC animated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.messageField resignFirstResponder];
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
    const int movementDistance = -200;
    const float movementDuration = 0.2f;
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


- (IBAction)backButton:(id)sender
{
    MessagesVC *BPVC=[self.storyboard instantiateViewControllerWithIdentifier:@"messagesvc"];
    
    [self.navigationController pushViewController:BPVC animated:YES];
}

- (IBAction)sendMessage:(id)sender
{
    if ([self.messageField.text length]>0)
    {        
        [self postMessage:self.messageField.text];
        
        [self.messageField setText:@""];
    }
    
    [self.messageField resignFirstResponder];
}

- (void) postMessage:(NSString* )message
{
    NSDictionary* postDict = @{
                               @"text"        : message,
                               @"createdById" : MyPersonModelID,
                               @"toPersonId"  : PartnerPersonModelID
                               };
    
    [MBProgressHUD hideAllHUDsForView:[AppDelegate SharedDelegate].window animated:NO];
    [MBProgressHUD showHUDAddedTo:[AppDelegate SharedDelegate].window animated:YES];
    
    [[BTAPIClient sharedClient] postMessageWithFriendShip:@"friendships"
                                         withFriendshipID:FriendShipID
                                                 withDict:postDict
                                                withBlock:^(NSDictionary *model, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:[AppDelegate SharedDelegate].window animated:NO];
         
         if (error == Nil)
         {
             if ([model isKindOfClass:[NSDictionary class]])
             {
                 ChatViewController *chatVC=[self.storyboard instantiateViewControllerWithIdentifier:@"chat"];
                 
                 chatVC.chat_friendShipId = FriendShipID;
                 chatVC.chat_messageModel = Nil;
                 chatVC.chat_personModel = Nil;
                 chatVC.isFromMessageList = YES;
                 
                 [self.navigationController pushViewController:chatVC animated:YES];
             }
         }
     }];

}
@end
