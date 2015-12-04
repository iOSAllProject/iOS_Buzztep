//
//  NewEventVC.m
//  BUZZtep
//
//  Created by Sanchit Thakur on 29/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "NewEventVC.h"
#import "BuzzProfileVC.h"
#import "AppDelegate.h"
#import "BuzzWhereVC.h"
#import "AppDelegate.h"
#import "Global.h"
#import "Constant.h"

@interface NewEventVC ()<UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *titleEventProperty;

- (IBAction)titleEventAction:(id)sender;
- (IBAction)nextAction:(id)sender;
- (IBAction)closeAction:(id)sender;

@property  UIAlertView *eventAlertView;


@end

@implementation NewEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.eventAlertView.delegate=self;
    _titleEventProperty.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 30);
    
    
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)titleEventAction:(id)sender
{
     _eventAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add A New Buzz", @"Buzz Title")
                                              message:@"Title Your Event" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    _eventAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [_eventAlertView show];
}

- (IBAction)nextAction:(id)sender
{
    if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Event)
    {
        NSString* eventTitle = Nil;
        
        if (_titleEventProperty.titleLabel.text.length > 0
            && [_titleEventProperty.titleLabel.text.uppercaseString isEqualToString:@""] == FALSE)
        {
            eventTitle = _titleEventProperty.titleLabel.text;
            
            [AppDelegate SharedDelegate].gEventModel.event_title = eventTitle;
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
    
        
    // create instance on NSManagedObect for newEvent
    NSManagedObject	*newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:_managedObjectContext];
    
    [newEvent setValue:_titleEventProperty.titleLabel.text forKey:@"eventTitle"];
    
       NSLog(@"newEvent objects are=%@", newEvent);
    NSError *error;
    
    // here’s where the actual save happens, and if it doesn’t we print something out to the console
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Problem saving: %@", [error localizedDescription]);
    }
 
}

- (IBAction)closeAction:(id)sender
{
    BuzzProfileVC *buzzProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [_titleEventProperty.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        _titleEventProperty.titleLabel.text = [NSString stringWithFormat:@"TITLE YOUR EVENT"];
    }

    if (buttonIndex==1)
    {
        _titleEventProperty.titleLabel.text=[alertView textFieldAtIndex:0].text;
    }
    
}
@end
