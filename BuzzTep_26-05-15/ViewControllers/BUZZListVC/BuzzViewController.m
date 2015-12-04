//
//  ViewController.m
//  BuzzTimeline
//
//  Created by Sanchit Thakur on 27/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BuzzViewController.h"
#import "ProjectHandler.h"
#import "AnimationVC.h"
#import "AddNewBuzzTypeVC.h"

#import "NewAdventure.h"
#import "NewAdventureVC.h"

#import "NewMilestone.h"
#import "NewMilestoneVC.h"
#import "SwipeRefresh.h"

#import "BTAPIClient.h"
#import "Constant.h"
#import "Global.h"
#import "MBProgressHUD.h"
#import "BTAdventureModel.h"
#import "BTMilestoneModel.h"
#import "BTEventModel.h"
#import "BTPeopleModel.h"
#import "BTBuzzItemModel.h"
#import "BuzzItemLWCell.h"
#import "BuzzItemRWCell.h"
#import "NewBuzzPrivacyVC.h"
#import "BTBuzzItemPrivacyVC.h"
#import "BTBuzzItemDetailVC.h"
#import "BuzzAltVC.h"
#import "BTBuzzEditVC.h"

@interface BuzzViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *BuzzSegmentProperty;

- (IBAction)BuzzSegmentAction:(id)sender;
- (IBAction)animationAction:(id)sender;
- (IBAction)stepAction:(id)sender;
- (IBAction)flowerAction:(id)sender;

- (IBAction)whiteArrowAction:(id)sender;

- (BOOL)isFirstYear:(NSString* )createdOn;

@property (strong, nonatomic) IBOutlet UIButton *whiteArrowProperty;
@property  UIRefreshControl *refreshControl;

@property NSMutableArray *namesArray,*namesArray1,*namesArray2,*profileImageArray,*profileImageArray1,*profileImageArray2,*adventureArray1,*adventureArray2,*adventureArray,*dayArray,*monthArray,*yearArray,*adventurenNamesArray;

@property (strong, nonatomic) IBOutlet UIView *hideView;

@property (strong, nonatomic) IBOutlet UILabel *buzzTitleLabel;

- (IBAction)myBuzzAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *myBuzzProperty;

- (IBAction)whatBuzzAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *whatBuzzProperty;

- (IBAction)communityBuzzAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *communityBuzzProperty;


@property (nonatomic, strong) NSMutableArray *adventureData;
@property (nonatomic, strong) NewAdventure *adventure;

@property (nonatomic, strong) NSMutableArray *milestoneData;
@property (nonatomic, strong) NewMilestone *milestone;

@property (nonatomic, strong) NSArray *fetchedObjects;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;

@property  (nonatomic, strong) SwipeRefresh *refresh;

@property (nonatomic, strong) BTPeopleModel*    buzzPeople;
@property (nonatomic, strong) NSMutableArray*   buzzAdventures;
@property (nonatomic, strong) NSMutableArray*   buzzEvents;
@property (nonatomic, strong) NSMutableArray*   buzzMilestones;

@property (nonatomic, strong) NSMutableArray*   buzzYearList;
@property (nonatomic, strong) NSArray       *   imageArray;

@property (nonatomic, strong) NSArray*   buzzItemArray;

- (void) loadDataFromServer;

@end

@implementation BuzzViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    [ProjectHandler setSegmentAttributes];
    
    _namesArray=[[NSMutableArray alloc]initWithObjects:@"Amy Adams",@"Cassandra Benny",@"Danielle Common", nil];
    _namesArray1=[NSMutableArray arrayWithObjects:@"Sapin Adventure",@"Lisa Kendirck",@"Jimmy Adventure", nil];
    _namesArray2=[NSMutableArray arrayWithObjects:@"Katelyn jim",@"Megan smith ",@" Hawaii Adventure", nil];
    
    _profileImageArray=[NSMutableArray arrayWithObjects:@"image1", @"image2",@"image3",nil];
    _profileImageArray1=[NSMutableArray arrayWithObjects:@"image4", @"image5",@"image6",nil];
    _profileImageArray2=[NSMutableArray arrayWithObjects:@"image7", @"image4",@"image1",nil];
    
    _adventureArray1=[NSMutableArray arrayWithObjects:@"bridge", @"bottomCups",@"van",nil];
    _adventureArray2=[NSMutableArray arrayWithObjects:@"van", @"teaCup",@"Tie",nil];
    _adventureArray=[NSMutableArray arrayWithObjects:@"sea", @"seaSmall",@"hills",nil];
    
    _dayArray=[NSMutableArray arrayWithObjects:@"12-05-15", @"04-03-15",@"20-01-15",nil];
    _monthArray=[NSMutableArray arrayWithObjects:@"May", @"March",@"January",nil];
    _yearArray=[NSMutableArray arrayWithObjects:@"2015", @"2014",@"2013",nil];
    
    _adventurenNamesArray=[NSMutableArray arrayWithObjects:@"London Adventure",@"Into The Woods" ,@"San Fran Conference",nil];
    
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    
    id delegate1 = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext1 = [delegate1 managedObjectContext];
    
//    [self fetchTheData];
    
    //TableView RefreshController.
    _refresh = [[SwipeRefresh alloc] initWithScrollView:self.tableView];
    
    [_refresh setMarginTop:0];
    [_refresh setColors:@[[UIColor colorWithRed:0.439 green:0.624 blue:0.604 alpha:1]]];
    
    [self.tableView addSubview:_refresh];
    
    [_refresh addTarget:self
                 action:@selector(refresh:)
       forControlEvents:UIControlEventValueChanged];
    
    self.imageArray = @[@"avatar1", @"avatara", @"avat", @"avatara", @"Dollar", @"avatara", @"avatarBg"];
    
    self.buzzItemArray = [[NSArray alloc] init];
    
    self.tableView.estimatedRowHeight = 111.0f;
    [self.tableView reloadData];
    
    self.buzzYearList = [[NSMutableArray alloc] init];
    
//    [self loadDataFromServer];
   
}

- (void)refresh:(id)sender {
    
    NSLog(@"REFRESH");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [_refresh endRefreshing];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadDataFromServer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:@"kBTBuzzUpdated"];
}

-(void)fetchTheData
{
    //  create fetch object, this object fetch’s the objects out of the database
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Adventure"
                                              inManagedObjectContext:_managedObjectContext];
    
    NSLog(@"adventure details %@",_adventure);
    
    [fetchRequest setEntity:entity];
    
    NSError *error;
    
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest
                                                                   error:&error];
    
    if (fetchedObjects != nil)
    {
        _adventureData = [[NSMutableArray alloc]initWithArray:fetchedObjects];
    }
    
    NSLog(@"adventureData data %@",_adventureData);
    
    //  create fetch object, this object fetch’s the objects out of the database
    
    NSFetchRequest *fetchRequest1 = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity1 = [NSEntityDescription entityForName:@"Milestone"
                                               inManagedObjectContext:_managedObjectContext1];
    
    NSLog(@"Milestione details %@", _milestoneData);
    
    [fetchRequest1 setEntity:entity1];
    
    NSError *error1;
    
    NSArray *fetchedObjects1 = [_managedObjectContext1 executeFetchRequest:fetchRequest1
                                                                     error:&error1];
    
    if (fetchedObjects1 != nil)
    {
        _milestoneData = [[NSMutableArray alloc]initWithArray:fetchedObjects1];
    }
    
    NSLog(@"Milestione data %@",_milestoneData);
}


- (void)deleteAllEntities:(NSString *)nameEntity
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *object in fetchedObjects)
    {
        [_managedObjectContext deleteObject:object];
    }
    
    error = nil;
    
    [_managedObjectContext save:&error];
}


#pragma mark - UITableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.buzzItemArray count];
    
//    return [_adventureData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* leftCellIdentifier = @"BuzzItemLWCell";
    static NSString* rightCellIdentifier = @"BuzzItemRWCell";
    
    // DataSource
    
    BTBuzzItemModel* cellModel = [self.buzzItemArray objectAtIndex:indexPath.row];
    
    BuzzItemLWCell* leftcell = (BuzzItemLWCell* )[tableView dequeueReusableCellWithIdentifier:leftCellIdentifier];
    
    if (leftcell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:leftCellIdentifier owner:self options:nil];
        leftcell = [nib objectAtIndex:0];
    }
    
    BuzzItemRWCell* rightcell = (BuzzItemRWCell* )[tableView dequeueReusableCellWithIdentifier:rightCellIdentifier];
    
    if (rightcell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:rightCellIdentifier owner:self options:nil];
        rightcell = [nib objectAtIndex:0];
    }
    
    NSInteger timelineMode = self.BuzzSegmentProperty.selectedSegmentIndex;
    
    if (timelineMode == 2)
    {
        leftcell.isFirstYear = [self isFirstYear:cellModel.buzzitem_createdOn];
        
        [self.buzzYearList addObject:cellModel.buzzitem_createdOn];
    }
    
    if (indexPath.row % 2 == 0)
    {
//        leftcell.isFirstYear = [self isFirstYear:cellModel.buzzitem_createdOn];
        
        [leftcell initCell:cellModel timeLineMode:timelineMode];
        
        leftcell.delegate = self;
        
        return leftcell;
    }
    else
    {
        [rightcell initCell:cellModel timeLineMode:timelineMode];
        
        rightcell.delegate = self;
        
        return rightcell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 111;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//}

#pragma mark

- (IBAction)BuzzSegmentAction:(id)sender
{
    [self.tableView reloadData];//When we tap on different segment sections it will refresh the data.
}

- (IBAction)animationAction:(id)sender
{
    AnimationVC *animation =  [self.storyboard instantiateViewControllerWithIdentifier:@"AnimationView"];
    [self.navigationController pushViewController:animation animated:YES];
    
}

- (IBAction)stepAction:(id)sender
{
    AddNewBuzzTypeVC *newBuzz =[self.storyboard instantiateViewControllerWithIdentifier:@"addnewbuzztype"];
    
    [self.navigationController pushViewController:newBuzz animated:YES];
}

- (IBAction)flowerAction:(id)sender
{
    BuzzAltVC   *altVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BuzzAltVC"];
    [self.navigationController pushViewController:altVC animated:YES];
    
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BuzzPhoto" bundle:nil];
//    MainViewController *buzzvc=[storyboard instantiateViewControllerWithIdentifier:@"mainvc"];
//    [self.navigationController pushViewController:buzzvc animated:YES];
}

- (IBAction)whiteArrowAction:(id)sender {
    
    self.hideView.hidden=NO;
    self.hideView.alpha = 0.0;
    [UIView beginAnimations:@"Fade-in" context:NULL];
    [UIView setAnimationDuration:1.0];
    self.hideView.alpha = 1.0;
    [UIView commitAnimations];
    NSLog(@"white button ");
}

- (IBAction)myBuzzAction:(id)sender
{
    self.buzzTitleLabel.text = self.myBuzzProperty.titleLabel.text;
    self.hideView.hidden=YES;
    NSLog(@"MY BUZZ CLICKED");
}

- (IBAction)whatBuzzAction:(id)sender {
    self.buzzTitleLabel.text=self.whatBuzzProperty.titleLabel.text;
    self.hideView.hidden=YES;
    NSLog(@"WHAT'S BUZZ CLICKED");
}

- (IBAction)communityBuzzAction:(id)sender {
    
    self.buzzTitleLabel.text=self.communityBuzzProperty.titleLabel.text;
    self.hideView.hidden=YES;
    NSLog(@"COMMUNITY BUZZ CLICKED");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utility Function

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
                
                [self.tableView reloadData];
            }
        }
    }];
    
}

- (BOOL)isFirstYear:(NSString* )createdOn
{
    BOOL retVal = NO;
    
    NSString *date = createdOn;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSDate* dateFromString = [formatter dateFromString:date];
    
    [formatter setDateFormat:@"YYYY"];
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *stringFromDate = [formatter stringFromDate:dateFromString];
    
    BOOL isExisting = NO;
    
    if ([self.buzzYearList count])
    {
        for (int i = 0; i < [self.buzzYearList count] ;  i ++)
        {
            if ([[self.buzzYearList objectAtIndex:i] isEqualToString:stringFromDate])
            {
                isExisting = YES;
                
                break;
            }
        }
    }
    
    if (isExisting == NO)
    {
        [self.buzzYearList addObject:stringFromDate];
        
        retVal = YES;
    }
    else
    {
        retVal = NO;
    }
    
    return retVal;
}

- (void)lockAction:(BTBuzzItemModel* )buzzItem
{
    UIStoryboard *btfriend_storyboard = [UIStoryboard storyboardWithName:@"BTBuzzItem" bundle:nil];
    
    BTBuzzItemPrivacyVC *vc = [btfriend_storyboard instantiateViewControllerWithIdentifier:@"BTBuzzItemPrivacyVC"];
    
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)unlockAction:(BTBuzzItemModel* )buzzItem
{
    UIStoryboard *btfriend_storyboard = [UIStoryboard storyboardWithName:@"BTBuzzItem" bundle:nil];
    
    BTBuzzItemPrivacyVC *vc = [btfriend_storyboard instantiateViewControllerWithIdentifier:@"BTBuzzItemPrivacyVC"];
    
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:nil];
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

- (void)showBuzzEdit:(BTBuzzItemModel *)buzzItem
{
    if ([buzzItem buzzMediaCount] == 0)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadDataFromServer) name:@"kBTBuzzUpdated"
                                                   object:Nil];
        
        UIStoryboard *btBuzzEdit_storyboard = [UIStoryboard storyboardWithName:@"BTBuzzEdit" bundle:nil];
        
        BTBuzzEditVC *buzzEditVC = [btBuzzEdit_storyboard instantiateViewControllerWithIdentifier:@"BTBuzzEditVC"];
        
        buzzEditVC.buzzitem_model = buzzItem;
        
        buzzEditVC.modalPresentationStyle = UIModalPresentationCustom;
        
        [self presentViewController:buzzEditVC animated:YES completion:nil];
    }
}

@end
