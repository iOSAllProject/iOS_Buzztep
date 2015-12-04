//
//  NewMilestoneVC.m
//  BUZZtep
//
//  Created by Sanchit Thakur on 29/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "NewMilestoneVC.h"
#import "BuzzProfileVC.h"
#import "BuzzWhereVC.h"

#import "Constant.h"
#import "Global.h"
#import "AppDelegate.h"

@interface NewMilestoneVC ()<UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *titleMilestoneProperty;
- (IBAction)titleMileStoneAction:(id)sender;
- (IBAction)nextAction:(id)sender;
- (IBAction)closeButton:(id)sender;
@property  UIAlertView *milestoneAlertView;

@end

@implementation NewMilestoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
      self.milestoneAlertView.delegate=self;
      _titleMilestoneProperty.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 30);
    
        
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
}

- (IBAction)titleMileStoneAction:(id)sender {
    _milestoneAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add A New Buzz", @"Buzz Title")
                                              message:@"Title Your Milestone" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    _milestoneAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [_milestoneAlertView show];
}
- (IBAction)nextAction:(id)sender
{
    if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Milestone)
    {
        NSString* milestonTitle = Nil;
        
        if (_titleMilestoneProperty.titleLabel.text.length > 0
            && [_titleMilestoneProperty.titleLabel.text.uppercaseString isEqualToString:@"TITLE YOUR MILESTONE"] == FALSE)
        {
            milestonTitle = _titleMilestoneProperty.titleLabel.text;
            
            [AppDelegate SharedDelegate].gMilestoneModel.milestone_title = milestonTitle;
        }
        else
        {
            [[AppDelegate SharedDelegate] ShowAlert:ApplicationTile
                                     messageContent:@"Input the adventure title"];
            
            return;
        }
    }
    
    BuzzWhereVC *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"buzzwhere"];
    [self.navigationController pushViewController:secondViewController animated:YES];
    
    
    // create instance on NSManagedObect for newMilestone
    NSManagedObject	*newMilestone = [NSEntityDescription insertNewObjectForEntityForName:@"Milestone" inManagedObjectContext:_managedObjectContext];
    
    [newMilestone setValue:_titleMilestoneProperty.titleLabel.text forKey:@"milestoneTitle"];
   
      NSLog(@"newMilestone objects are=%@", newMilestone);
    
    NSError *error;
    
    // here’s where the actual save happens, and if it doesn’t we print something out to the console
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Problem saving: %@", [error localizedDescription]);
    }
}

- (IBAction)closeButton:(id)sender {
    BuzzProfileVC *buzzProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
    [self.navigationController pushViewController:buzzProfile animated:YES];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0)
    {
        [_titleMilestoneProperty.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        _titleMilestoneProperty.titleLabel.text = [NSString stringWithFormat:@"TITLE YOUR MILESTONE"];
        
    }
    if (buttonIndex==1)
    {
        _titleMilestoneProperty.titleLabel.text=[alertView textFieldAtIndex:0].text;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
