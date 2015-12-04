//
//  ConnectionsVC.m
//  Animation
//
//  Created by Sanchit Thakur on 22/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "ConnectionsVC.h"
#import "ConnectionsCustomCell.h"
#import "AppDelegate.h"
#import "AnimationVC.h"
#import "ProjectHandler.h"
#import "InviteFriendsVC.h"
#import "FindFriendsVC.h"
#import "BTFriendProfileVC.h"

@interface ConnectionsVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,ConectCustomCellDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *selectedGroupArray;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) NSMutableArray *tempArray;
@property (weak, nonatomic) IBOutlet UISegmentedControl *connectionsSegment;
@property (nonatomic, strong) NSArray *friendsArray, *closeFriendsArray, *familyArray;
@property UISearchController*search;
- (IBAction)inviteUserAction:(id)sender;
- (IBAction)connectionSegAction:(id)sender;
- (IBAction)animationButtonAction:(id)sender;
- (IBAction)mapViewAction:(id)sender;

@end

@implementation ConnectionsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.searchBar.delegate=self;
    
    [ProjectHandler setSegmentAttributes];//for common segmentcontroller .

    [self loadServerData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectedGroupForSegment:(NSInteger)segmentIndex
{
    switch (segmentIndex)
    {
        case 0:
            _selectedGroupArray = [[NSArray alloc] initWithArray:_friendsArray];
            
            break;
            
        case 1:
            _selectedGroupArray = [[NSArray alloc] initWithArray:_closeFriendsArray];
            
            break;
            
        case 2:
            _selectedGroupArray = [[NSArray alloc] initWithArray:_familyArray];
            
            break;
            
    }
    
    [self filterContentForSearchText:nil];
    [self.tableView reloadData];
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    if (searchText.length)
    {
        
        NSPredicate *searchPredicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings)
                                        {
                                            
                                            return [[evaluatedObject[@"name"] uppercaseString] rangeOfString:searchText.uppercaseString].location != NSNotFound;
                                        }];
        
        self.searchResults = [[NSMutableArray alloc] initWithArray: [_selectedGroupArray filteredArrayUsingPredicate:searchPredicate]];
        
    }
    else self.searchResults = [[NSMutableArray alloc] initWithArray: _selectedGroupArray];
    
    [_tableView reloadData];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ConnectionsCustomCell";
    
    ConnectionsCustomCell *cell = (ConnectionsCustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ConnectionsCustomCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    cell.delegate = self;
    cell.indexPath = indexPath.row;

    cell.arrowImageView.image=[UIImage imageNamed:@"backCopy"];
    cell.flightImageView.image=[UIImage imageNamed:@"shape"];
    
    [cell configureNotificationCell:_searchResults[indexPath.row]];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_searchResults count];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"Row Selected");
    
    UIStoryboard *btfriend_storyboard = [UIStoryboard storyboardWithName:@"BTFriend" bundle:nil];
    
    BTFriendProfileVC *friendProfileVC=[btfriend_storyboard instantiateViewControllerWithIdentifier:@"btfriendprofile"];
    
    [self.navigationController pushViewController:friendProfileVC animated:YES];
    
}

#pragma mark - UISearchBar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterContentForSearchText:searchText];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
- (IBAction)connectionSegAction:(id)sender
{
    _searchBar.text = nil;
    
    [_searchBar resignFirstResponder];
    
    [self selectedGroupForSegment:_connectionsSegment.selectedSegmentIndex];
}

- (IBAction)animationButtonAction:(id)sender
{
    AnimationVC *animation=[self.storyboard instantiateViewControllerWithIdentifier:@"AnimationView"];
    [self.navigationController pushViewController:animation animated:YES];
}

- (IBAction)mapViewAction:(id)sender {
    
    NSLog(@"map view pin");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BuzzFindFriends" bundle:nil];
    
    FindFriendsVC *buzzvc=[storyboard instantiateViewControllerWithIdentifier:@"findfriendsvc"];
    [self.navigationController pushViewController:buzzvc animated:YES];
}
- (IBAction)inviteUserAction:(id)sender
{
    NSLog(@"invite friends");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"InviteFriends" bundle:nil];
    
    InviteFriendsVC *invitefriends=[storyboard instantiateViewControllerWithIdentifier:@"invitefriendsvc"];
    [self.navigationController pushViewController:invitefriends animated:YES];
}

- (void)loadServerData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSDictionary *friend_params = @{@"where" : @{@"category": @"friendship"},@"include":@{@"people":@[@"photo",@"followedBy"]}};

    NSData *friend_paramsData = [NSJSONSerialization dataWithJSONObject:friend_params options:0 error:nil];
    NSString *friend_paramsStr = [[NSString alloc] initWithData:friend_paramsData encoding:NSUTF8StringEncoding];
    NSString* friend_filterQuery = [NSString stringWithFormat:@"filter=%@", friend_paramsStr];
    [[BTAPIClient sharedClient] getFriendShipPeople:@"people" withPersonId:MyPersonModelID withFilter:friend_filterQuery withBlock:^(NSArray *models, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _tempArray = [[NSMutableArray alloc]init];
        if (error == nil) {
            if ([models isKindOfClass:[NSArray class]]) {
                for (NSDictionary *friend in models) {
                    NSArray *peoples = [friend objectForKeyedSubscript:@"people"];
                    for (NSDictionary* people in peoples) {
                        BTPeopleModel *peopleModule = [[BTPeopleModel alloc]initPeopleWithDict:people];
                        BTPhotoModel *photoModule = [[BTPhotoModel alloc]initPhotoPeopleWithDict:[people objectForKey:@"photo"]];

                        if (![peopleModule.people_Id isEqualToString:MyPersonModelID]) {
                            NSString* urlPhoto = [NSString stringWithFormat:@"%@/%@",[photoModule.photo_data objectForKeyedSubscript:@"dataUrl"],[photoModule.photo_data objectForKeyedSubscript:@"filename"]];
                            NSString* bgButtonFollow;
                            if ([[people objectForKeyedSubscript:@"followedBy"] count] == 0) {
                                bgButtonFollow = @"bac.png";
                            }else{
                                BOOL isExistFollow = NO;
                                for (NSDictionary* modelFollow in [people objectForKeyedSubscript:@"followedBy"]) {
                                    BTFollowModel *follow = [[BTFollowModel alloc]initFollowWithDict:modelFollow];
                                    if ([follow.follow_followerId isEqualToString:MyPersonModelID] && [follow.follow_followedId isEqualToString:peopleModule.people_Id ]) {
                                        bgButtonFollow = @"backCopy.png";

                                        isExistFollow = YES;
                                    }
                                }
                                if (!isExistFollow) {
                                    bgButtonFollow = @"bac.png";
                                }
                            }
                            NSDictionary* cell = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ %@",[peopleModule.people_identity objectForKeyedSubscript:@"firstName"],[peopleModule.people_identity objectForKeyedSubscript:@"lastName"]],@"name",urlPhoto,@"image",bgButtonFollow,@"arrow",peopleModule.people_Id,@"peopleId", nil];
                            [_tempArray addObject:cell];
                        }
                    }

                }
                _friendsArray = [[NSArray alloc]initWithArray:_tempArray];
                [self selectedGroupForSegment:0];
                [_tableView reloadData];
            }
        }
    }];


    ///////////////// family

    NSDictionary *family_params = @{@"where" : @{@"category": @"family"},@"include":@{@"people":@[@"photo",@"followedBy"]}};

    NSData *family_paramsData = [NSJSONSerialization dataWithJSONObject:family_params options:0 error:nil];
    NSString *family_paramsStr = [[NSString alloc] initWithData:family_paramsData encoding:NSUTF8StringEncoding];
    NSString* family_filterQuery = [NSString stringWithFormat:@"filter=%@", family_paramsStr];
    [[BTAPIClient sharedClient] getFriendShipPeople:@"people" withPersonId:MyPersonModelID withFilter:family_filterQuery withBlock:^(NSArray *models, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _tempArray = [[NSMutableArray alloc]init];
        if (error == nil) {
            if ([models isKindOfClass:[NSArray class]]) {
                for (NSDictionary *friend in models) {
                    NSArray *peoples = [friend objectForKeyedSubscript:@"people"];
                    for (NSDictionary* people in peoples) {
                        BTPeopleModel *peopleModule = [[BTPeopleModel alloc]initPeopleWithDict:people];
                        BTPhotoModel *photoModule = [[BTPhotoModel alloc]initPhotoPeopleWithDict:[people objectForKey:@"photo"]];

                        if (![peopleModule.people_Id isEqualToString:MyPersonModelID]) {
                            NSString* urlPhoto = [NSString stringWithFormat:@"%@/%@",[photoModule.photo_data objectForKeyedSubscript:@"dataUrl"],[photoModule.photo_data objectForKeyedSubscript:@"filename"]];
                            NSString* bgButtonFollow;
                            if ([[people objectForKeyedSubscript:@"followedBy"] count] == 0) {
                                bgButtonFollow = @"bac.png";
                            }else{
                                BOOL isExistFollow = NO;
                                for (NSDictionary* modelFollow in [people objectForKeyedSubscript:@"followedBy"]) {
                                    BTFollowModel *follow = [[BTFollowModel alloc]initFollowWithDict:modelFollow];
                                    if ([follow.follow_followerId isEqualToString:MyPersonModelID] && [follow.follow_followedId isEqualToString:peopleModule.people_Id ]) {
                                        bgButtonFollow = @"backCopy.png";

                                        isExistFollow = YES;
                                    }
                                }
                                if (!isExistFollow) {
                                    bgButtonFollow = @"bac.png";
                                }
                            }
                            NSDictionary* cell = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ %@",[peopleModule.people_identity objectForKeyedSubscript:@"firstName"],[peopleModule.people_identity objectForKeyedSubscript:@"lastName"]],@"name",urlPhoto,@"image",bgButtonFollow,@"arrow",peopleModule.people_Id,@"peopleId", nil];
                            [_tempArray addObject:cell];
                        }
                    }

                }
                _familyArray = [[NSArray alloc]initWithArray:_tempArray];
                [self selectedGroupForSegment:0];
                [_tableView reloadData];
            }
        }
    }];

    //////////// close
    NSDictionary *close_params = @{@"where" : @{@"category": @"close"},@"include":@{@"people":@[@"photo",@"followedBy"]}};

    NSData *close_paramsData = [NSJSONSerialization dataWithJSONObject:close_params options:0 error:nil];
    NSString *close_paramsStr = [[NSString alloc] initWithData:close_paramsData encoding:NSUTF8StringEncoding];
    NSString* close_filterQuery = [NSString stringWithFormat:@"filter=%@", close_paramsStr];
    [[BTAPIClient sharedClient] getFriendShipPeople:@"people" withPersonId:MyPersonModelID withFilter:close_filterQuery withBlock:^(NSArray *models, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _tempArray = [[NSMutableArray alloc]init];
        if (error == nil) {
            if ([models isKindOfClass:[NSArray class]]) {
                for (NSDictionary *friend in models) {
                    NSArray *peoples = [friend objectForKeyedSubscript:@"people"];
                    for (NSDictionary* people in peoples) {
                        BTPeopleModel *peopleModule = [[BTPeopleModel alloc]initPeopleWithDict:people];
                        BTPhotoModel *photoModule = [[BTPhotoModel alloc]initPhotoPeopleWithDict:[people objectForKey:@"photo"]];

                        if (![peopleModule.people_Id isEqualToString:MyPersonModelID]) {
                            NSString* urlPhoto = [NSString stringWithFormat:@"%@/%@",[photoModule.photo_data objectForKeyedSubscript:@"dataUrl"],[photoModule.photo_data objectForKeyedSubscript:@"filename"]];
                            NSString* bgButtonFollow;
                            if ([[people objectForKeyedSubscript:@"followedBy"] count] == 0) {
                                bgButtonFollow = @"bac.png";
                            }else{
                                BOOL isExistFollow = NO;
                                for (NSDictionary* modelFollow in [people objectForKeyedSubscript:@"followedBy"]) {
                                    BTFollowModel *follow = [[BTFollowModel alloc]initFollowWithDict:modelFollow];
                                    if ([follow.follow_followerId isEqualToString:MyPersonModelID] && [follow.follow_followedId isEqualToString:peopleModule.people_Id ]) {
                                        bgButtonFollow = @"backCopy.png";

                                        isExistFollow = YES;
                                    }
                                }
                                if (!isExistFollow) {
                                    bgButtonFollow = @"bac.png";
                                }
                            }
                            NSDictionary* cell = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ %@",[peopleModule.people_identity objectForKeyedSubscript:@"firstName"],[peopleModule.people_identity objectForKeyedSubscript:@"lastName"]],@"name",urlPhoto,@"image",bgButtonFollow,@"arrow",peopleModule.people_Id,@"peopleId", nil];
                            [_tempArray addObject:cell];
                        }
                    }

                }
                _closeFriendsArray = [[NSArray alloc]initWithArray:_tempArray];
                [self selectedGroupForSegment:0];
                [_tableView reloadData];
            }
        }
    }];
}

- (void)clickFollow:(NSInteger)index{
    NSDictionary *modelCell = [_searchResults objectAtIndex:index];
    NSString* peopleId = [modelCell objectForKeyedSubscript:@"peopleId"];
    NSLog(@"People Id %@",[modelCell objectForKeyedSubscript:@"peopleId"]);
    NSLog(@"Follow Id %@",[modelCell objectForKeyedSubscript:@"followId"]);

    NSDictionary *params = @{@"where" : @{@"followedId": peopleId}};

    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSString *paramsStr = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];

    NSString* filterQuery = [NSString stringWithFormat:@"filter=%@", paramsStr];
    [[BTAPIClient sharedClient] getFollowPeople:@"people" withPersonId:MyPersonModelID withFilter:filterQuery withBlock:^(NSArray *models, NSError *error) {
        if (error == Nil)
        {
            if ([models isKindOfClass:[NSArray class]])
            {
                DLog(@"%@", models);

                if ([models count] >= 1)
                {
                    BTFollowModel* follow_model = [[BTFollowModel alloc] initFollowWithDict:[models firstObject]];

                    [[BTAPIClient sharedClient] unfollow:follow_model.follow_ID
                                               withBlock:^(NSDictionary *model, NSError *error)
                     {
                         if (error == Nil)
                         {

                         }
                     }];
                }else{
                    NSDictionary* followDict = @{
                                                 @"followerId" : MyPersonModelID,
                                                 @"followedId" : peopleId
                                                 };
                    [[BTAPIClient sharedClient] followPeople:@"follow"
                                                withPostDict:followDict
                                                   withBlock:^(NSDictionary *model, NSError *error)
                     {

                         if (error == Nil)
                         {
                             DLog(@"%@", model);
                         }
                     }];
                }
                [self loadServerData];
            }
        }
    }];
}
@end
