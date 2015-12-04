//
//  ViewController.m
//  BuzzTepInvite
//
//  Created by Sanchit Thakur  on 01/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "InviteFriendsVC.h"
#import "InviteFriendsCell.h"
#import "ProjectHandler.h"
#import "AnimationVC.h"
#import "FindFriendsVC.h"
#import "CommunityVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <AddressBook/AddressBook.h>

@interface InviteFriendsVC () <UITableViewDataSource, UITableViewDelegate>
{
    Invite *inv;
    InviteFriendsCell *cell;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedProperty;
@property (strong, nonatomic) NSMutableArray *facebookDataSource;
@property (strong, nonatomic) NSMutableArray *contactsDataSource;
@property (weak, nonatomic) NSMutableArray *currentDataSource;

- (IBAction)AnimationAction:(id)sender;

@end

@implementation InviteFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [ProjectHandler setSegmentAttributes];
    _segmentedProperty.selectedSegmentIndex = 0;
    
    AppDelegate * appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _facebookDataSource = appdel.FBFriendsList;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    if (addressBook) {
        if (&ABAddressBookRequestAccessWithCompletion) {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    
                    _contactsDataSource = [NSMutableArray array];
                    
                    CFArrayRef lRawAddressBookEntries = ABAddressBookCopyArrayOfAllPeople(addressBook);
                    CFIndex lTotalContactsCount = ABAddressBookGetPersonCount(addressBook);
                    for (CFIndex i = 0; i < lTotalContactsCount; i++) {
                        NSMutableDictionary *userData = [NSMutableDictionary dictionary];
                        ABRecordRef lRef = CFArrayGetValueAtIndex(lRawAddressBookEntries, i);
                        
                        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(lRef, kABPersonFirstNameProperty);
                        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(lRef, kABPersonLastNameProperty);
                        
                        if (firstName.length == 0) {
                            firstName = @"";
                        }
                        
                        if (lastName.length == 0) {
                            lastName = @"";
                        }
                        
                        NSString *name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                        
                        if (name.length) {
                            userData[@"name"] = name;
                        }
                        
                        CFDataRef imageData = ABPersonCopyImageData(lRef);
                        UIImage *image = [UIImage imageWithData:(__bridge NSData *)imageData];
                        
                        if (image) {
                            CFRelease(imageData);
                        } else {
                            image = [UIImage imageNamed:@"no_avatar"];
                        }
                        userData[@"picture"] = image;
                        
                        Invite * invite = [[Invite alloc] initWithData:userData];
                        [_contactsDataSource addObject:invite];
                        
                    }
                } else {
                    CFRelease(addressBook);
                }
            });
        }
    }
    
    _currentDataSource = _facebookDataSource;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currentDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
    UIImageView * imgv = (UIImageView *)[cell viewWithTag:10];
    imgv.layer.cornerRadius = 20;
    
    [cell updateWithInvite:_currentDataSource[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)segmentedAction:(id)sender
{
    switch (_segmentedProperty.selectedSegmentIndex) {
        case 0:
            _currentDataSource = _facebookDataSource;
            break;
            
        case 1:
            _currentDataSource = _contactsDataSource;
            break;
            
        default:
            break;
    }
    
    [_tableView reloadData];
}

- (IBAction)pressLeftBarButton:(id)sender
{
    NSLog(@"Left bar button pressed");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommunityVC   *community =  [storyboard instantiateViewControllerWithIdentifier:@"community"];
    [self.navigationController pushViewController:community animated:YES];
}

- (IBAction)pressRightBarButton:(id)sender
{
    NSLog(@"Right bar button pressed-- FIND FRIENDS");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BuzzFindFriends" bundle:nil];
    FindFriendsVC *buzzvc=[storyboard instantiateViewControllerWithIdentifier:@"findfriendsvc"];
    [self.navigationController pushViewController:buzzvc animated:YES];
}

- (IBAction)AnimationAction:(id)sender
{
    NSLog(@"Menu button pressed");
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AnimationVC *animation =  [storyboard instantiateViewControllerWithIdentifier:@"AnimationView"];
    [self.navigationController pushViewController:animation animated:YES];
}

- (IBAction)pressInviteButton:(UIButton*)sender
{
    //Invite *model = self.currentDataSource[sender.tag];
    // model.invited = !model.invited;
    NSLog(@"The part number is:%@",[NSString stringWithFormat:@"%zd", sender.tag]);
    FBSDKGameRequestDialog *gameRequestDialog = [[FBSDKGameRequestDialog alloc] init];
    FBSDKGameRequestContent *content = [[FBSDKGameRequestContent alloc] init];
    content.title = @"Challenge a Friend";
    content.message = @"Please come play RPS with me!";
    gameRequestDialog.content = content;
    [gameRequestDialog show];    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    //[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
