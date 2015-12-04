//
//  MessageRecipientViewController.m
//  CocaColaVC
//
//  Created by Sanchit Thakur on 22/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "MessageRecipient.h"
#import "MessageRecipientVC.h"
#import "MessagesVC.h"

#import "AppDelegate.h"

@interface MessageRecipient ()

- (IBAction)msgRecipientAction:(id)sender;
- (IBAction)backButton:(id)sender;


@end

@implementation MessageRecipient

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureRight)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleSwipeGestureRight
{
    MessagesVC *BPVC=[self.storyboard instantiateViewControllerWithIdentifier:@"messagesvc"];
    [self.navigationController pushViewController:BPVC animated:YES];
    //addrecipient
    
}

- (IBAction)msgRecipientAction:(id)sender
{
    MessageRecipientVC *coca=[self.storyboard instantiateViewControllerWithIdentifier:@"messagerecipient"];
    [self.navigationController pushViewController:coca animated:YES];
    //messagerecipient
}

- (IBAction)backButton:(id)sender {
    
    MessagesVC *BPVC=[self.storyboard instantiateViewControllerWithIdentifier:@"messagesvc"];
    [self.navigationController pushViewController:BPVC animated:YES];
    
}


@end
