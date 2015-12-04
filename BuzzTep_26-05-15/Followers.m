//
//  Followers.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 21/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "Followers.h"
#import "FollowersCell.h"
#import "AppDelegate.h"
#import "BuzzProfileVC.h"
#import "AnimationVC.h"

@interface Followers ()<FollowersDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray*namesArray;
@property NSMutableArray *personList,*followerList,*checkFollowList,*followByList;
@property  NSArray*picImage,*arrowImage,*nextImage;
@property (weak, nonatomic) IBOutlet UIButton *animationButton;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
- (IBAction)animationButtonAction:(id)sender;
- (IBAction)backButtonAction:(id)sender;

@end

@implementation Followers

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate=self;
    self.tableView.dataSource=self;

    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureRight)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];


    _namesArray=[[NSArray alloc]initWithObjects:@"Amy Adams",@"Cassandra Benny",@"Danielle Common",@"Sallie Dennings",@"Fred Harris",@"Amy Henry",@"Terry Jones",@"Stephanie Kendrick",@"Ben Long",@"Emily Song", nil];
    _picImage=[[NSArray alloc]initWithObjects:@"avatar1.png",@"Dolla.png",@"Dolla1.png",@"Dollar.png",@"avatar1.png",@"Dolla.png",@"Dolla1.png", @"avatar1.png",@"avatar1.png",@"avatar1.png",nil];

    _arrowImage=[[NSArray alloc]initWithObjects:@"backCopy.png", nil];
    _nextImage=[[NSArray alloc]initWithObjects:@"shape.png", nil];
    _personList = [[NSMutableArray alloc]init];
    _followerList = [[NSMutableArray alloc]init];
    _checkFollowList = [[NSMutableArray alloc]init];
    [self loadServerData];
}
-(void)handleSwipeGestureRight
{
    [self.navigationController popViewControllerAnimated:YES];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [_personList count];
}

- (FollowersCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"CustomTableCell";

    FollowersCell *cell = (FollowersCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FollowersCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.indexPath = indexPath.row;
    cell.delegate = self;
    BTPeopleModel *peopleModel = [[BTPeopleModel alloc]initPeopleWithDict:[_personList objectAtIndex:indexPath.row]];
    if (peopleModel.people_identity)
    {
        if ([peopleModel.people_identity objectForKeyedSubscript:@"firstName"])
        {
            if ([peopleModel.people_identity objectForKeyedSubscript:@"lastName"])
            {
                cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", [peopleModel.people_identity objectForKeyedSubscript:@"firstName"], [peopleModel.people_identity objectForKeyedSubscript:@"lastName"]];
            }
            else
            {
                cell.nameLabel.text = [NSString stringWithFormat:@"%@", [peopleModel.people_identity objectForKeyedSubscript:@"firstName"]];
            }
        }
        else
        {
            if ([peopleModel.people_identity objectForKeyedSubscript:@"lastName"])
            {
                cell.nameLabel.text = [NSString stringWithFormat:@"%@", [peopleModel.people_identity objectForKeyedSubscript:@"lastName"]];
            }
            else
            {
                cell.nameLabel.text = [NSString stringWithFormat:@"%@", @"Killer"];
            }
        }
    }
    // Check follow state

    NSDictionary *follow_params = @{@"where" : @{@"followedId": peopleModel.people_Id}};

    NSData *follow_paramsData = [NSJSONSerialization dataWithJSONObject:follow_params options:0 error:nil];
    NSString *follow_paramsStr = [[NSString alloc] initWithData:follow_paramsData encoding:NSUTF8StringEncoding];
    NSString* follow_filterQuery = [NSString stringWithFormat:@"filter=%@", follow_paramsStr];
    [[BTAPIClient sharedClient] getFollowPeople:@"people" withPersonId:MyPersonModelID withFilter:follow_filterQuery withBlock:^(NSArray *models, NSError *error) {
        if (error == Nil)
        {
            if ([models count] > 0)
            {
                [cell.btn_followAction setImage:[UIImage imageNamed:@"friend_passport_followed"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.btn_followAction setImage:[UIImage imageNamed:@"friend_passport_follow"] forState:UIControlStateNormal];
            }
        }
    }];

    // Get Avatar
    [[BTAPIClient sharedClient] getPhotoPeople:@"people" withPersonId:peopleModel.people_Id withBlock:^(NSDictionary *model, NSError *error) {
        if (!error) {
            if ([model isKindOfClass:[NSDictionary class]]) {
                BTPhotoModel *photo = [[BTPhotoModel alloc]initPhotoPeopleWithDict:model];
                NSDictionary* photo_data = photo.photo_data;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *imgURL = [NSString stringWithFormat:@"%@/%@",[photo_data objectForKeyedSubscript:@"dataUrl"],[photo_data objectForKeyedSubscript:@"filename"]];
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
                    //set your image on main thread.
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.picImageView.image =[UIImage imageWithData:data];

                    });
                });
            }
        }
    }];

    cell.flightImageView.image=[UIImage imageNamed:@"shape"];

    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)animationButtonAction:(id)sender
{
    AnimationVC *animation =
    [self.storyboard instantiateViewControllerWithIdentifier:@"AnimationView"];
    [self.navigationController pushViewController:animation animated:YES];

}
- (IBAction)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickFollowerAction:(NSInteger)index{
    BTPeopleModel *peopleModel = [[BTPeopleModel alloc]initPeopleWithDict:[_personList objectAtIndex:index]];
    NSDictionary *params = @{@"where" : @{@"followedId": peopleModel.people_Id}};

    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSString *paramsStr = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];

    NSString* filterQuery = [NSString stringWithFormat:@"filter=%@", paramsStr];

    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[BTAPIClient sharedClient] getFollowPeople:(NSString* )@"people"
                                   withPersonId:(NSString* )MyPersonModelID
                                     withFilter:(NSString* )filterQuery
                                      withBlock:^(NSArray* models, NSError* error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:NO];

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
                          [_tableView reloadData];
                      }];
                 }else{
                     [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                     NSDictionary* followDict = @{
                                                  @"followerId" : MyPersonModelID,
                                                  @"followedId" : peopleModel.people_Id
                                                  };
                     [[BTAPIClient sharedClient] followPeople:@"follow"
                                                 withPostDict:followDict
                                                    withBlock:^(NSDictionary *model, NSError *error)
                      {
                          [MBProgressHUD hideAllHUDsForView:self.view animated:NO];

                          if (error == Nil)
                          {
                              DLog(@"%@", model);
                          }
                          [_tableView reloadData];
                      }];
                 }
             }
         }
     }];
}

- (void)loadServerData{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[BTAPIClient sharedClient] getFollowByPeople:@"people" withPersonId:MyPersonModelID withFilter:nil withBlock:^(NSArray *models, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        if (error ==  nil) {
            if ([models isKindOfClass:[NSArray class]]) {
                _followByList = [[NSMutableArray alloc]initWithArray:models];
                for (NSDictionary *followed in models) {
                    BTFollowModel *followModel = [[BTFollowModel alloc]initFollowWithDict:followed];
                    [[BTAPIClient sharedClient] getPeopleBuzz:@"people"
                                                 withPersonId:followModel.follow_followerId                                                    withBlock:^(NSDictionary *model, NSError *error) {
                        if (error == nil) {
                            if ([model isKindOfClass:[NSDictionary class]]) {
                                [_personList addObject:model];
                                [_tableView reloadData];
                            }
                        }
                    }];
                }
            }
        }
    }];
}
@end
