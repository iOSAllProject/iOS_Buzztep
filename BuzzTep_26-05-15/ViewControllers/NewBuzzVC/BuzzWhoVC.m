//
//  BuzzWhoVC.m
//  When_WhereVC
//
//  Created by Sanchit Thakur on 20/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BuzzWhoVC.h"
#import "NewBuzzMediaVC.h"
#import "BuzzProfileVC.h"
#import "BuzzWhereVC.h"
#import "BuzzWhenVC.h"
#import <QuartzCore/QuartzCore.h>
#import "ProjectHandler.h"

#import "Global.h"
#import "Constant.h"
#import "BTAPIClient.h"
#import "MBProgressHUD.h"
#import "BTPeopleModel.h"
#import "BTFriendshipModel.h"
#import "BTBuzzWhoCell.h"

#define prototypeName @"friendships"

@interface BuzzWhoVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *whoProperty;
@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) LBRESTAdapter * adapter;
@property (weak, nonatomic) IBOutlet UITableView *whoTableView;
@property UIButton *button;
@property (strong, nonatomic) BTFriendshipModel* friendshipModel;

- (IBAction)nextVCAction:(id)sender;
- (IBAction)closeButton:(id)sender;
- (IBAction)whoAction:(id)sender;

- (IBAction)whereAction:(id)sender;
- (IBAction)whenAction:(id)sender;
- (IBAction)skipAction:(id)sender;

@end

@implementation BuzzWhoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.whoTableView.delegate=self;
    self.whoTableView.dataSource=self;
}

-(void)animate
{
    //For bouncing of Who image when the view will appear.
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.5;
    anim.repeatCount = 2;
    anim.autoreverses = YES;
    anim.removedOnCompletion = YES;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    
    [_whoProperty.layer addAnimation:anim forKey:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self animate];
    
    NSDictionary *params = @{ @"include" : @[@{@"people":@"photo"}]};
    
    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSString *paramsStr = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
    
    NSString* filterQuery = [NSString stringWithFormat:@"filter=%@", paramsStr];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[BTAPIClient sharedClient] getFriends:@"people"
                              withPersonId:MyPersonModelID
                                withFilter:filterQuery
                                 withBlock:^(NSArray *models, NSError *error)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        
        if (error == Nil)
        {
            if ([models isKindOfClass:[NSArray class]])
            {
                self.friendshipModel = [[BTFriendshipModel alloc] initFriendshipWithDict:[models firstObject]];
                
                if (self.friendshipModel.friendship_peoples)
                {
                    NSMutableArray* friendship_people = self.friendshipModel.friendship_peoples;
                    
                    if ([self.friendshipModel.friendship_peoples count])
                    {
                        for (int i = 0 ; i  <  [self.friendshipModel.friendship_peoples count] ; i ++)
                        {
                            BTPeopleModel* people = [self.friendshipModel.friendship_peoples objectAtIndex:i];
                            
                            if ([people.people_Id isEqualToString:MyPersonModelID])
                            {
                                [friendship_people removeObjectAtIndex:i];
                            }
                        }
                    }
                    
                    self.tableData = [friendship_people copy];
                    
                    [self.whoTableView reloadData];
                }
            }
        }
    }];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *buzzwhocellIdentifier = @"BTBuzzWhoCell";
    
    BTBuzzWhoCell *whocell = (BTBuzzWhoCell* )[tableView dequeueReusableCellWithIdentifier:buzzwhocellIdentifier];
    
    if( whocell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:buzzwhocellIdentifier
                                                     owner:self
                                                   options:nil];
        
        whocell = [nib objectAtIndex:0];
    }
    
    BTPeopleModel* indexedPeople = [self.tableData objectAtIndex:indexPath.row];
    
    whocell.friendName.text = [self getPeopleName:indexedPeople];
    
    [whocell.friendSelectBtn addTarget:self
                                action:@selector(customActionPressed:)
                      forControlEvents:UIControlEventTouchUpInside];
    return whocell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)customActionPressed:(id)sender//When we are click on tick mark it will fill with color.
{
    _button = (UIButton*)sender;
    
    [_button setBackgroundImage:[UIImage imageNamed:@"new_buzz_friend_selected"]
                       forState:UIControlStateNormal];
    
    NSLog(@"Tick button clicked");
}

- (NSString* )getPeopleName:(BTPeopleModel* )people
{
    NSString* name = @"";
    
    if (people.people_identity)
    {
        if ([people.people_identity objectForKeyedSubscript:@"firstName"])
        {
            if ([people.people_identity objectForKeyedSubscript:@"lastName"])
            {
                name = [NSString stringWithFormat:@"%@ %@", [people.people_identity objectForKeyedSubscript:@"firstName"], [people.people_identity objectForKeyedSubscript:@"lastName"]];
            }
            else
            {
                name = [NSString stringWithFormat:@"%@", [people.people_identity objectForKeyedSubscript:@"firstName"]];
            }
        }
        else
        {
            if ([people.people_identity objectForKeyedSubscript:@"lastName"])
            {
                name = [NSString stringWithFormat:@"%@", [people.people_identity objectForKeyedSubscript:@"lastName"]];
            }
            else
            {
                name = [NSString stringWithFormat:@"%@", @"Killer"];
            }
        }
    }
    
    return name;
}

#pragma mark - IBActions

- (IBAction)nextVCAction:(id)sender
{
    NewBuzzMediaVC *buzzMedia = [self.storyboard instantiateViewControllerWithIdentifier:@"newbuzzmedia"];
    [self.navigationController pushViewController:buzzMedia animated:YES];
}

- (IBAction)closeButton:(id)sender
{
    BuzzProfileVC *buzzProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
}


- (IBAction)whoAction:(id)sender
{
    NSLog(@"Who action clicked");
    
}
- (IBAction)whereAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)whenAction:(id)sender
{
    BuzzWhenVC *buzzProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"buzzwhen"];
    
    [self.navigationController pushViewController:buzzProfile animated:YES];    
}

- (IBAction)skipAction:(id)sender
{
    NewBuzzMediaVC *buzzMedia = [self.storyboard instantiateViewControllerWithIdentifier:@"newbuzzmedia"];
    [self.navigationController pushViewController:buzzMedia animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
