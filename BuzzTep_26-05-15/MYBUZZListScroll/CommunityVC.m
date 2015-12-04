//
//  CommunityVC.m
//  Animation
//
//  Created by Sanchit Thakur on 22/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "CommunityVC.h"
#import "CommunityCustomCell.h"
#import "ConnectionsVC.h"
#import "AnimationVC.h"
#import "AppDelegate.h"
#import "Cocacola.h"
#import "InviteFriendsVC.h"
#import "BTFollowModel.h"
#import "Constant.h"

#import "FindFriendsVC.h"
@interface CommunityVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,CommunicationCustomCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *communityArray;
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)communityAction:(id)sender;
- (IBAction)whiteButtonAction:(id)sender;
- (IBAction)connectionsAction:(id)sender;
- (IBAction)inviteUser:(id)sender;
- (IBAction)animationButtonAction:(id)sender;
- (IBAction)mapViewAction:(id)sender;

@end

@implementation CommunityVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.searchBar.delegate=self;
    
    self.searchResults=[[NSMutableArray alloc]init];
    
    _communityArray = [[NSArray alloc]init];
    
    [self filterContentForSearchText:nil];
    [self loadServerData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

#pragma markup - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CommunityCustomCell";
    CommunityCustomCell *cell = (CommunityCustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommunityCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.delegate = self;
    cell.indexPath = indexPath.row;

    [cell configureNotificationCell:_searchResults[indexPath.row]];
    cell.flightImageView.image=[UIImage imageNamed:@"shape"];

    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_searchResults count];
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    if (searchText.length)
    {
        
        NSPredicate *searchPredicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings)
            {
                                            
           return [[evaluatedObject[@"name"] uppercaseString] rangeOfString:searchText.uppercaseString].location != NSNotFound;
                    }];
        
        self.searchResults = [[NSMutableArray alloc] initWithArray: [_communityArray filteredArrayUsingPredicate:searchPredicate]];
        
    }
    else self.searchResults = [[NSMutableArray alloc] initWithArray: _communityArray];
    
    [_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row==2)
    {
        
        Cocacola *coca=[self.storyboard instantiateViewControllerWithIdentifier:@"cocacola"];
        [self.navigationController pushViewController:coca animated:YES];
        
        NSLog(@"home page");
    }
    
}

#pragma mark - UISearchBar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton=YES;
    self.searchBar.autocorrectionType=UITextAutocorrectionTypeNo;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self filterContentForSearchText:searchText];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton=NO;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}


-(IBAction)whiteButtonAction:(id)sender
{
    self.myView.hidden=NO;
    self.myView.alpha = 0.0;
    [UIView beginAnimations:@"Fade-in" context:NULL];
    [UIView setAnimationDuration:1.0];
    self.myView.alpha = 1.0;
    [UIView commitAnimations];
}

-(IBAction)connectionsAction:(id)sender
{
    self.myView.hidden=YES;
    ConnectionsVC *conn=[self.storyboard instantiateViewControllerWithIdentifier:@"connection"];
    [self.navigationController pushViewController:conn animated:YES];
}
- (IBAction)communityAction:(id)sender
{
    self.myView.hidden=YES;
    CommunityVC *comm=[self.storyboard instantiateViewControllerWithIdentifier:@"community"];
    [self.navigationController pushViewController:comm animated:YES];
    
}
- (IBAction)inviteUser:(id)sender
{
    NSLog(@"INVITE FRIENDS");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"InviteFriends" bundle:nil];
    
    InviteFriendsVC *invitefriends=[storyboard instantiateViewControllerWithIdentifier:@"invitefriendsvc"];
    [self.navigationController pushViewController:invitefriends animated:YES];
}
- (IBAction)animationButtonAction:(id)sender
{
    AnimationVC *animation=[self.storyboard instantiateViewControllerWithIdentifier:@"AnimationView"];
    [self.navigationController pushViewController:animation animated:YES];
}

- (IBAction)mapViewAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BuzzFindFriends" bundle:nil];
    
    FindFriendsVC *buzzvc=[storyboard instantiateViewControllerWithIdentifier:@"findfriendsvc"];
    [self.navigationController pushViewController:buzzvc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadServerData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *comminication_params = @{@"where" : @{@"type": @{@"neq":@"user"}},@"include":@[@"followedBy",@"photo"]};

    NSData *comminication_paramsData = [NSJSONSerialization dataWithJSONObject:comminication_params options:0 error:nil];
    NSString *comminication_paramsStr = [[NSString alloc] initWithData:comminication_paramsData encoding:NSUTF8StringEncoding];
    NSString* comminication_filterQuery = [NSString stringWithFormat:@"filter=%@", comminication_paramsStr];
    [[BTAPIClient sharedClient] getPeople:@"people" withFilter:comminication_filterQuery withBlock:^(NSArray *models, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error == nil) {
            if ([models isKindOfClass:[NSArray class]]) {
                _searchResults = [[NSMutableArray alloc]init];
                for (NSDictionary *model in models) {
                    BTPeopleModel *peolpeModel = [[BTPeopleModel alloc]initPeopleWithDict:model];
                    BTPhotoModel *photoModule = [[BTPhotoModel alloc]initPhotoPeopleWithDict:[model objectForKey:@"photo"]];

                    NSString* bgButtonFollow;
                    NSString* followId;
                    if ([[model objectForKeyedSubscript:@"followedBy"] count] == 0) {
                        bgButtonFollow = @"bac.png";
                    }else{
                        BOOL isExistFollow = NO;
                        for (NSDictionary* modelFollow in [model objectForKeyedSubscript:@"followedBy"]) {
                            BTFollowModel *follow = [[BTFollowModel alloc]initFollowWithDict:modelFollow];
                            if ([follow.follow_followerId isEqualToString:MyPersonModelID] && [follow.follow_followedId isEqualToString:peolpeModel.people_Id]) {
                                bgButtonFollow = @"backCopy.png";
                                followId = follow.follow_ID;
                                isExistFollow = YES;
                            }
                        }
                        if (!isExistFollow) {
                            bgButtonFollow = @"bac.png";
                        }
                    }

                    NSString* urlPhoto = [NSString stringWithFormat:@"%@/%@",[photoModule.photo_data objectForKeyedSubscript:@"dataUrl"],[photoModule.photo_data objectForKeyedSubscript:@"filename"]];
                    NSDictionary* cell = [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%@ %@",[peolpeModel.people_identity objectForKeyedSubscript:@"firstName"],[peolpeModel.people_identity objectForKeyedSubscript:@"lastName"]],@"name",urlPhoto,@"image",bgButtonFollow,@"arrow",peolpeModel.people_Id,@"peopleId",followId,@"followId", nil];
                    [_searchResults addObject:cell];

                }
                _communityArray = [[NSArray alloc]initWithArray:_searchResults];
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
