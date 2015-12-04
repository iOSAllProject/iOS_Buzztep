//
//  BuzzAltVC.m
//  BUZZtep
//
//  Created by Pandora on 7/1/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BuzzAltVC.h"
#import "AddNewBuzzTypeVC.h"
#import "AppDelegate.h"
#import "AnimationVC.h"
#import "SwipeRefresh.h"

#import "BTAPIClient.h"
#import "Constant.h"
#import "Global.h"
#import "MBProgressHUD.h"

#import "BTBuzzAltNoMediaCell.h"
#import "BTBuzzAltMediaCell.h"

#import "BTPeopleModel.h"
#import "BTBuzzItemModel.h"
#import "BTBuzzItemDetailVC.h"

@interface BuzzAltVC () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView*      filterView;
@property (strong, nonatomic) IBOutlet UILabel*     buzzTitleLabel;
@property (strong, nonatomic) IBOutlet UITableView* buzzListTbl;
@property  (nonatomic, strong) SwipeRefresh *refresh;

@property (nonatomic, strong) BTPeopleModel*    buzzPeople;
@property (nonatomic, strong) NSMutableArray*   buzzAdventures;
@property (nonatomic, strong) NSMutableArray*   buzzEvents;
@property (nonatomic, strong) NSMutableArray*   buzzMilestones;

@property (nonatomic, strong) NSArray*   buzzItemArray;

- (IBAction)onSwitchViewMode:(id)sender;
- (IBAction)onShowBuzzFilterMode:(id)sender;
- (IBAction)onAddNewBuzz:(id)sender;
- (IBAction)onMainMenu:(id)sender;
- (IBAction)onMyBuzzAction:(id)sender;
- (IBAction)onWhatsBuzzAction:(id)sender;
- (IBAction)onCommunityBuzzAction:(id)sender;

- (void) loadDataFromServer;

@end

@implementation BuzzAltVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.buzzListTbl.dataSource = self;
    self.buzzListTbl.delegate = self;
    
    self.buzzItemArray = [[NSArray alloc] init];
    
    //TableView RefreshController.
    _refresh = [[SwipeRefresh alloc] initWithScrollView:self.buzzListTbl];
    
    [_refresh setMarginTop:0];
    [_refresh setColors:@[[UIColor colorWithRed:0.439 green:0.624 blue:0.604 alpha:1]]];
    
    [self.buzzListTbl addSubview:_refresh];
    
    [_refresh addTarget:self
                 action:@selector(refresh:)
       forControlEvents:UIControlEventValueChanged];
    
    [self loadDataFromServer];
     
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.buzzListTbl reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.buzzItemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* noMediaCellIdentifier = @"BTBuzzAltNoMediaCell";
    static NSString* MediaCellIdentifier = @"BTBuzzAltMediaCell";
    
    // DataSource
    
    BTBuzzItemModel* cellModel = [self.buzzItemArray objectAtIndex:indexPath.row];
    
    BTBuzzAltNoMediaCell* noMediaCell = (BTBuzzAltNoMediaCell* )[tableView dequeueReusableCellWithIdentifier:noMediaCellIdentifier];
    
    if (noMediaCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:noMediaCellIdentifier owner:self options:nil];
        noMediaCell = [nib objectAtIndex:0];
    }
    
    BTBuzzAltMediaCell* mediaCell = (BTBuzzAltMediaCell* )[tableView dequeueReusableCellWithIdentifier:MediaCellIdentifier];
    
    if (mediaCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:MediaCellIdentifier owner:self options:nil];
        mediaCell = [nib objectAtIndex:0];
    }
    
    if ([cellModel buzzMediaCount] == 0)
    {
        [noMediaCell initCell:cellModel];
        
        return noMediaCell;
    }
    else
    {
        [mediaCell initCell:cellModel];
        mediaCell.delegate = self;
        
        return mediaCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTBuzzItemModel* cellModel = [self.buzzItemArray objectAtIndex:indexPath.row];
    
    if ([cellModel buzzMediaCount] == 0)
    {
        return 56;
    }
    else
    {
        return 291;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    BTBuzzItemModel* buzzItem = [self.buzzItemArray objectAtIndex:indexPath.row];
    
    if ([buzzItem buzzMediaCount])
    {
        UIStoryboard *btfriend_storyboard = [UIStoryboard storyboardWithName:@"BTBuzzItem" bundle:nil];
        
        BTBuzzItemDetailVC *vc = [btfriend_storyboard instantiateViewControllerWithIdentifier:@"BTBuzzItemDetailVC"];
        
        vc.buzzitem_model = buzzItem;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Utility Functions

- (void) loadDataFromServer
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[BTAPIClient sharedClient] getPeopleBuzz:@"people"
                                 withPersonId:MyPersonModelID
                                    withBlock:^(NSDictionary *model, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
         
         if (error == Nil)
         {
             if (model && [model isKindOfClass:[NSDictionary class]])
             {
                 NSDictionary* peopleDict = [model objectForKeyedSubscript:@"person"];
                 
                 self.buzzPeople = [[BTPeopleModel alloc] initPeopleWithDict:peopleDict];
                 
                 self.buzzAdventures = [[NSMutableArray alloc] init];
                 self.buzzMilestones = [[NSMutableArray alloc] init];
                 self.buzzEvents = [[NSMutableArray alloc] init];
                 
                 if ([peopleDict objectForKeyedSubscript:@"adventures"]
                     && [[peopleDict objectForKeyedSubscript:@"adventures"] isKindOfClass:[NSArray class]])
                 {
                     self.buzzAdventures = [NSMutableArray arrayWithArray:[peopleDict objectForKeyedSubscript:@"adventures"]];
                 }
                 
                 if ([peopleDict objectForKeyedSubscript:@"milestones"]
                     && [[peopleDict objectForKeyedSubscript:@"milestones"] isKindOfClass:[NSArray class]])
                 {
                     self.buzzMilestones = [NSMutableArray arrayWithArray:[peopleDict objectForKeyedSubscript:@"milestones"]];
                 }
                 
                 if ([peopleDict objectForKeyedSubscript:@"events"]
                     && [[peopleDict objectForKeyedSubscript:@"events"] isKindOfClass:[NSArray class]])
                 {
                     self.buzzEvents = [NSMutableArray arrayWithArray:[peopleDict objectForKeyedSubscript:@"events"]];
                 }
                 
                 int i= 0;
                 
                 NSMutableArray* unsorted_buzzitemArray = [[NSMutableArray alloc] init];
                 
                 if ([self.buzzAdventures count])
                 {
                     for (i = 0 ; i < [self.buzzAdventures count] ; i ++)
                     {
                         BTBuzzItemModel* buzzItem =
                         [[BTBuzzItemModel alloc] initBuzzItemWithDict:[self.buzzAdventures objectAtIndex:i]
                                                              withType:Global_BuzzType_Adventure];
                         
                         [unsorted_buzzitemArray addObject:buzzItem];
                     }
                 }
                 
                 if ([self.buzzMilestones count])
                 {
                     for (i = 0 ; i < [self.buzzMilestones count] ; i ++)
                     {
                         BTBuzzItemModel* buzzItem =
                         [[BTBuzzItemModel alloc] initBuzzItemWithDict:[self.buzzMilestones objectAtIndex:i]
                                                              withType:Global_BuzzType_Milestone];
                         
                         [unsorted_buzzitemArray addObject:buzzItem];
                     }
                 }
                 
                 if ([self.buzzEvents count])
                 {
                     for (i = 0 ; i < [self.buzzEvents count] ; i ++)
                     {
                         BTBuzzItemModel* buzzItem =
                         [[BTBuzzItemModel alloc] initBuzzItemWithDict:[self.buzzEvents objectAtIndex:i]
                                                              withType:Global_BuzzType_Event];
                         
                         [unsorted_buzzitemArray addObject:buzzItem];
                         
                     }
                 }
                 
                 NSArray* tempArray = [[NSArray alloc] init];
                 
                 tempArray= [unsorted_buzzitemArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                     NSString *first = [(BTBuzzItemModel*)a buzzitem_createdOn];
                     NSString *second = [(BTBuzzItemModel*)b buzzitem_createdOn];
                     
                     return [first compare:second];
                 }];
                 
                 self.buzzItemArray = [[tempArray reverseObjectEnumerator] allObjects];
                 
                 // Reload TableView
                 
                 [self.buzzListTbl reloadData];
             }
         }
     }];
    
}

- (void)refresh:(id)sender {
    
    NSLog(@"REFRESH");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_refresh endRefreshing];
    });
}

- (void)showMediaDetail:(BTBuzzItemModel* )buzzItem
{
    if ([buzzItem buzzMediaCount])
    {
        UIStoryboard *btfriend_storyboard = [UIStoryboard storyboardWithName:@"BTBuzzItem" bundle:nil];
        
        BTBuzzItemDetailVC *vc = [btfriend_storyboard instantiateViewControllerWithIdentifier:@"BTBuzzItemDetailVC"];
        
        vc.buzzitem_model = buzzItem;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - IBActions

- (IBAction)onSwitchViewMode:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onShowBuzzFilterMode:(id)sender
{
    self.filterView.hidden=NO;
    self.filterView.alpha = 0.0;
    
    [UIView beginAnimations:@"Fade-in" context:NULL];
    
    [UIView setAnimationDuration:1.0];
    
    self.filterView.alpha = 1.0;
    
    [UIView commitAnimations];
}

- (IBAction)onAddNewBuzz:(id)sender
{
    AddNewBuzzTypeVC *newBuzz=[self.storyboard instantiateViewControllerWithIdentifier:@"addnewbuzztype"];
    [self.navigationController pushViewController:newBuzz animated:YES];
}

- (IBAction)onMainMenu:(id)sender
{
    AnimationVC *newBuzz=[self.storyboard instantiateViewControllerWithIdentifier:@"AnimationView"];
    [self.navigationController pushViewController:newBuzz animated:YES];
}

- (IBAction)onMyBuzzAction:(id)sender
{
    self.buzzTitleLabel.text = @"MYBUZZ";
    [self.filterView setHidden:YES];
}

- (IBAction)onWhatsBuzzAction:(id)sender
{
    self.buzzTitleLabel.text = @"WHAT'S BUZZING";
    [self.filterView setHidden:YES];
}

- (IBAction)onCommunityBuzzAction:(id)sender
{
    self.buzzTitleLabel.text = @"COMMUNITY BUZZ";
    [self.filterView setHidden:YES];
}

@end
