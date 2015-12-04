//
//  NewAdventureVC.m
//  When_WhereVC
//
//  Created by Sanchit Thakur on 20/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "NewAdventureVC.h"
#import "BuzzProfileVC.h"
#import "BuzzWhereVC.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Global.h"
#import "Constant.h"

@interface NewAdventureVC ()<UIAlertViewDelegate,NSFetchedResultsControllerDelegate>

- (IBAction)buzzTypeTitleAction:(id)sender;
- (IBAction)closeButton:(id)sender;
- (IBAction)titleAdventureAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *titleAdventureProperty;
@property  UIAlertView *adventureAlertView;


@end

@implementation NewAdventureVC

//@synthesize managedObjectContext = _managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.adventureAlertView.delegate=self;
    _titleAdventureProperty.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 30);
        
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buzzTypeTitleAction:(id)sender
{
    // Set Adventure Title
    
    if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Adventure)
    {
        NSString* adventureTitle = Nil;
        
        if (_titleAdventureProperty.titleLabel.text.length > 0
            && [_titleAdventureProperty.titleLabel.text.uppercaseString isEqualToString:@"TITLE YOUR ADVENTURE"] == FALSE)
        {
            adventureTitle = _titleAdventureProperty.titleLabel.text;
            
            [AppDelegate SharedDelegate].gAdventureModel.adventure_title = adventureTitle;
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
    
    
    // create instance on NSManagedObect for newAdventure
    NSManagedObject	*newAdventure = [NSEntityDescription insertNewObjectForEntityForName:@"Adventure" inManagedObjectContext:_managedObjectContext];
    
    [newAdventure setValue:_titleAdventureProperty.titleLabel.text forKey:@"adventureTitle"];
    NSError *error;
    
    NSLog(@"managed objects are=%@", _managedObjectContext);
    NSLog(@"newAdventure objects are=%@", newAdventure);
    
    // here’s where the actual save happens, and if it doesn’t we print something out to the console
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Problem saving: %@", [error localizedDescription]);
    }
}

- (IBAction)closeButton:(id)sender
{
    BuzzProfileVC *buzzProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
}

- (IBAction)titleAdventureAction:(id)sender {
    
   _adventureAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add A New Buzz", @"Buzz Title")
                                                    message:@"Title Your Adventure"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    
    _adventureAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [_adventureAlertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [_titleAdventureProperty.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        _titleAdventureProperty.titleLabel.text = [NSString stringWithFormat:@"TITLE YOUR ADVENTURE"];
    }
    
    if (buttonIndex==1)
    {
        self.titleAdventureProperty.titleLabel.text=[alertView textFieldAtIndex:0].text;
    }
}
@end
