//
//  BuzzViaBucketList.m
//  BUZZtep
//
//  Created by apple on 20/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BuzzViaBucketList.h"

#import "BuzzProfileVC.h"
#import "AppDelegate.h"
#import "BuzzWhereVC.h"
#import "MyBuzzListVC.h"

#define TEXT_FIELD_TAG 1
#define ACTION_SHEET_TAG 1

@interface BuzzViaBucketList () <UIActionSheetDelegate,UITextFieldDelegate,UIAlertViewDelegate>

- (IBAction)buzzTypeTitleAction:(id)sender;
- (IBAction)closeButton:(id)sender;
- (IBAction)titleAdventureAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *titleAdventureProperty;

@property  UIAlertView *myAlertView;
@property UITextField *myTextField;
- (IBAction)backAction:(id)sender;

@end

@implementation BuzzViaBucketList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTextField.delegate=self;
    self.myAlertView.delegate=self;
    
    _titleAdventureProperty.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 30);
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureLeft)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)handleSwipeGestureLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buzzTypeTitleAction:(id)sender
{
    MyBuzzListVC *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mybuzzlist"];
    [self.navigationController pushViewController:secondViewController animated:YES];
    //    mybuzzlist
    
}

- (IBAction)closeButton:(id)sender
{
    BuzzProfileVC *buzzProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
    
}

- (IBAction)titleAdventureAction:(id)sender {
    
    _myAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add A New Buzz", @"Buzz Title")
                                              message:@"Title Your Adventure" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    _myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [_myAlertView show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //    NSLog(@"enter text %@", [alertView textFieldAtIndex:0].text);
    
    //    NSLog(@"button index=%ld",(long)buttonIndex);
    
    
    if (buttonIndex==0)
    {
        _titleAdventureProperty.titleLabel.font = [UIFont fontWithName:@"Title Your Adventure" size:12];
    }
    if (buttonIndex==1)
    {
        self.titleAdventureProperty.titleLabel.text=[alertView textFieldAtIndex:0].text;
    }
    
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
