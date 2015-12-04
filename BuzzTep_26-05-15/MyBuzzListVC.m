//
//  MyBuzzListVC.m
//  MyBuzzVC
//
//  Created by Sanchit Thakur on 21/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "MyBuzzListVC.h"
#import "MyBucketList.h"
#import "AnimationVC.h"
#import "MBProgressHUD.h"
#import "BuzzViaBucketList.h"

//#define TEXT_FIELD_TAG 1
//#define ACTION_SHEET_TAG 1

@interface MyBuzzListVC ()<UIActionSheetDelegate,UITextFieldDelegate,UIAlertViewDelegate>

- (IBAction)goAction:(id)sender;
- (IBAction)closeAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *titleProperty;
@property (strong, nonatomic) IBOutlet UIButton *locationProperty;
@property (strong, nonatomic) IBOutlet UIButton *notesProperty;

- (IBAction)titleAction:(id)sender;
- (IBAction)locationAction:(id)sender;
- (IBAction)notesAction:(id)sender;

@property UIAlertView *myAlertView,*myAlertView1,*myAlertView2;
@property UITextField *myTextField;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *notesLabel;

@end

@implementation MyBuzzListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myTextField.delegate=self;
    
    self.myAlertView.delegate=self;
    self.myAlertView1.delegate=self;
    self.myAlertView2.delegate=self;
    
}


- (IBAction)goAction:(id)sender
{
    NSLog(@"Go Action");
    if (_titleLabel.text.length < 1 || [_titleLabel.text isEqualToString:@"TITLE"]) {
        [self showMessage:@"Title is null" ];
    }else if (_locationLabel.text.length < 1 || [_locationLabel.text isEqualToString:@"LOCATION"]){
        [self showMessage:@"Location is null" ];
    }else if (_notesLabel.text.length < 1 || [_notesLabel.text isEqualToString:@"NOTES"]){
        [self showMessage:@"Notes is null" ];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary* milestoneDict = @{@"title" : _titleLabel.text,
                          @"location" : _locationLabel.text,
                          @"note" : @"",
                          @"personId" : MyPersonModelID};
        [[BTAPIClient sharedClient] postBucketList:@"people" withPersonId:MyPersonModelID withParam:milestoneDict withBlock:^(NSDictionary *model, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error == Nil)
            {
                DLog(@"%@", model);
            }

            [self confirmAction];
        }];
    }
    //    BuzzViaBucketList *bucketlist=[self.storyboard instantiateViewControllerWithIdentifier:@"buzzviabucket"];
    //    [self.navigationController pushViewController:bucketlist animated:YES];
}

- (IBAction)closeAction:(id)sender
{
    MyBucketList *bucketlist=[self.storyboard instantiateViewControllerWithIdentifier:@"bucketlist"];
    [self.navigationController pushViewController:bucketlist animated:YES];
}

- (IBAction)titleAction:(id)sender
{
    NSLog(@"Title Alert view");
    _myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@" Title ", @"Buzz Title")
                                              message:@"Title" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    _myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [_myAlertView setTag:1];
    [_myAlertView show];
}

- (IBAction)locationAction:(id)sender
{
    NSLog(@"Location Alert view");
    _myAlertView1 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@" Location ", @"Location Title")
                                               message:@"Location" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    _myAlertView1.alertViewStyle = UIAlertViewStylePlainTextInput;
    [_myAlertView1 setTag:2];
    
    [_myAlertView1 show];
    
}


- (IBAction)notesAction:(id)sender
{
    NSLog(@"Notes Alert view");
    
    _myAlertView2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@" Notes", @"Notes Title")
                                               message:@"Notes" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    _myAlertView2.alertViewStyle = UIAlertViewStylePlainTextInput;
    [_myAlertView2 setTag:3];
    
    [_myAlertView2 show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView==_myAlertView)
    {
        NSLog(@"alert tag 1");
        if (buttonIndex==0)
        {
            _titleLabel.text = @"TITLE";
            
        }
        if (buttonIndex==1)
        {
            _titleLabel.text=[alertView textFieldAtIndex:0].text;
        }
    }
    
    if (alertView==_myAlertView1)
    {
        NSLog(@"alert tag 2");
        
        if (buttonIndex==0)
        {
            _locationLabel.text=@"LOCATION";
        }
        
        if (buttonIndex==1)
        {
            _locationLabel.text=[alertView textFieldAtIndex:0].text;
            
        }
        
    }
    
    if (alertView==_myAlertView2)
    {
        NSLog(@"alert tag 3");
        
        if (buttonIndex==0)
        {
            _notesLabel.text=@"NOTES";
        }
        
        if (buttonIndex==1)
        {
            _notesLabel.text=[alertView textFieldAtIndex:0].text;
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showMessage :(NSString*)message{
    UIAlertView* warning = [[UIAlertView alloc]initWithTitle:@"BuzzTep" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [warning show];
}

- (void)confirmAction{
    MyBucketList *bucket=[self.storyboard instantiateViewControllerWithIdentifier:@"bucketlist"];
    [self.navigationController pushViewController:bucket animated:YES];
}
@end
