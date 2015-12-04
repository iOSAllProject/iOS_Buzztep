//
//  ViewController.m
//  BuzzTepMeetUps
//
//  Created by Sanchit Thakur  on 05/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "MeetUpsVC.h"
#import "MeetUpsCell.h"
#import "Meeting.h"
#import "ProjectHandler.h"
#import "AnimationVC.h"
#import <MapKit/MapKit.h>
#import "NewAdventureVC.h"

@interface MeetUpsVC () <UITableViewDataSource, UITableViewDelegate, MeetUpsCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedProperty;
@property (weak, nonatomic) NSMutableArray *currentDataSource;
@property (strong, nonatomic) NSMutableArray *invitedData;
@property (strong, nonatomic) NSMutableArray *goingData;
@property (strong, nonatomic) NSMutableArray *maybeData;
@property (strong, nonatomic) NSMutableArray *declinedData;
@property (strong, nonatomic) NSMutableArray *meetUpArray;
@property (strong, nonatomic) NSMutableArray *goingArray;
@property (strong, nonatomic) NSMutableArray *maybeArray;
@property (strong, nonatomic) NSMutableArray *declinedArray;
@property (strong, nonatomic) NSMutableArray *removeArray;

- (IBAction)addContactAction:(id)sender;

@end

@implementation MeetUpsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]];

    [ProjectHandler setSegmentAttributes];
    _segmentedProperty.selectedSegmentIndex = 0;

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"GOING_KEY"]==nil) {
        _goingArray = [[NSMutableArray alloc]init];
    }else{
        _goingArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"GOING_KEY"] mutableCopy];
    }

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"MAYBE_KEY"]==nil) {
        _maybeArray = [[NSMutableArray alloc]init];
    }else{
        _maybeArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"MAYBE_KEY"] mutableCopy];
    }

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DECLINE_KEY"]==nil) {
        _declinedArray = [[NSMutableArray alloc]init];
    }else{
        _declinedArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DECLINE_KEY"] mutableCopy];
    }

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"REMOVE_KEY"]==nil) {
        _removeArray = [[NSMutableArray alloc]init];
    }else{
        _removeArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"REMOVE_KEY"] mutableCopy];
    }
    _currentDataSource = _goingArray;
    [self loadServerData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 268;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currentDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeetUpsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetUpsCell"];
    cell.delegate = self;

    [cell updateMeetUpWithDict:_currentDataSource[indexPath.row]];
    if (_segmentedProperty.selectedSegmentIndex == 3) {
        [cell.actionButton setTitle:@"REPLY" forState:UIControlStateNormal];
        [cell.actionButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    } else {
        [cell.actionButton setTitle:@"" forState:UIControlStateNormal];
        [cell.actionButton setBackgroundImage:[UIImage imageNamed:@"3dot_btn.png"] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (IBAction)segmentedAction:(id)sender
{
    switch (_segmentedProperty.selectedSegmentIndex) {
        case 0:
            _currentDataSource = _goingArray;
            break;
            
        case 1:
            _currentDataSource = _maybeArray;
            break;
            
        case 2:
            _currentDataSource = _declinedArray;
            break;
            
        case 3:
            _currentDataSource = _meetUpArray;
            break;
            
        default:
            break;
    }
    
    [_tableView reloadData];
}

- (IBAction)pressPlusBtn:(id)sender
{
    NSLog(@"Plus button pressed");
}

- (IBAction)pressMenuBtn:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AnimationVC *animation =  [storyboard instantiateViewControllerWithIdentifier:@"AnimationView"];
    [self.navigationController pushViewController:animation animated:YES];NSLog(@"Menu button pressed");
}

- (void)didReceiveGoingStatus:(MeetUpsCell *)cell
{
    [_currentDataSource removeObject:cell.modelDict];
    [_meetUpArray removeObject:cell.modelDict];
    [_removeArray insertObject:cell.modelDict atIndex:0];
    [_goingArray insertObject:cell.modelDict atIndex:0];

    [[NSUserDefaults standardUserDefaults] setObject:_goingArray forKey:@"GOING_KEY"];
    [[NSUserDefaults standardUserDefaults] setObject:_removeArray forKey:@"REMOVE_KEY"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [_tableView reloadData];
    NSLog(@"Press going");
}

- (void)didReceiveMaybeStatus:(MeetUpsCell *)cell
{
    [_currentDataSource removeObject:cell.modelDict];
    [_meetUpArray removeObject:cell.modelDict];
    [_removeArray insertObject:cell.modelDict atIndex:0];
    [_maybeArray insertObject:cell.modelDict atIndex:0];

    [[NSUserDefaults standardUserDefaults] setObject:_maybeArray forKey:@"MAYBE_KEY"];
    [[NSUserDefaults standardUserDefaults] setObject:_removeArray forKey:@"REMOVE_KEY"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [_tableView reloadData];
    NSLog(@"Press maybe");
}

- (void)didReceiveDeclineStatus:(MeetUpsCell *)cell
{
    [_currentDataSource removeObject:cell.modelDict];
    [_meetUpArray removeObject:cell.modelDict];
    [_removeArray insertObject:cell.modelDict atIndex:0];
    [_declinedArray insertObject:cell.modelDict atIndex:0];

    [[NSUserDefaults standardUserDefaults] setObject:_declinedArray forKey:@"DECLINE_KEY"];
    [[NSUserDefaults standardUserDefaults] setObject:_removeArray forKey:@"REMOVE_KEY"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [_tableView reloadData];
    NSLog(@"Press decline");
}

- (void)didGetDirection:(MeetUpsCell *)cell
{
    NSLog(@"Get direction button pressed");
}

- (void)didInvite:(MeetUpsCell *)cell
{
    NSLog(@"Invite button pressed");
}

- (void)didEditEvent:(MeetUpsCell *)cell
{
    NSLog(@"Edit event button pressed");
}

- (void)didAddToCal:(MeetUpsCell *)cell
{
    NSLog(@"Add to cal button pressed");
}

- (void)didSetReminder:(MeetUpsCell *)cell
{
    NSLog(@"Set reminder button pressed");
}

- (void)didCancelMeetUp:(MeetUpsCell *)cell
{
    NSLog(@"Cancel meet up button pressed");
}

- (void)didChangeStatus:(MeetUpsCell *)cell
{
    NSLog(@"Change status button pressed");
}

- (IBAction)addContactAction:(id)sender
{
    NSLog(@"Add contact button clicked");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewAdventureVC *newBuzz = [storyboard instantiateViewControllerWithIdentifier:@"Newbuzztypetitle"];
    [self.navigationController pushViewController:newBuzz animated:YES];
}
- (void)loadServerData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *filter_params = @{@"include":@{@"invites":@{@"person":@"photo"}}};
    NSData *filter_paramsData = [NSJSONSerialization dataWithJSONObject:filter_params options:0 error:nil];
    NSString *filter_paramsStr = [[NSString alloc] initWithData:filter_paramsData encoding:NSUTF8StringEncoding];
    NSString* filter_filterQuery = [NSString stringWithFormat:@"filter=%@", filter_paramsStr];

    [[BTAPIClient sharedClient] getMeetUpPeople:@"people" withPersonId:MyPersonModelID withFilter:filter_filterQuery withBlock:^(NSArray *models, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error == nil) {
            if ([models isKindOfClass:[NSArray class]]) {
                _meetUpArray = [[NSMutableArray alloc]initWithArray:models];
                _currentDataSource = _goingArray;
                for (int i = 0; i<_removeArray.count; i++) {
                    if ([_meetUpArray containsObject:[_removeArray objectAtIndex:i]]) {
                        [_meetUpArray removeObject:[_removeArray objectAtIndex:i]];
                    }
                }
                [_tableView reloadData];
            }
        }
    }];
}
@end
