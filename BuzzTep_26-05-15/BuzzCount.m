//
//  BuzzCount.m
//  NotificationVC1
//
//  Created by Sanchit Thakur on 21/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BuzzCount.h"
#import "NavigationCell.h"
#import "AppDelegate.h"
#import "BuzzProfileVC.h"
#import "ProjectHandler.h"
#import "AnimationVC.h"
#import "MBProgressHUD.h"
#import "BTAPIClient.h"
#import "Constant.h"
#define prototypeName @"milestones"

//http://162.243.205.36:3000/api/milestones

@interface BuzzCount()
{
    NSMutableArray* _adventureList;
    NSMutableArray* _milestoneList;
    NSMutableArray* _eventList;

    NSMutableArray* _group;

}
@property (strong, nonatomic) IBOutlet UITableView *milestoneTableview;
@property (strong, nonatomic) IBOutlet UIView *adventureView;
@property (strong, nonatomic) IBOutlet UIView *mileStoneView;
@property (strong, nonatomic) IBOutlet UIView *eventsView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *milestoneSegment;
@property NSArray *namesArray2,*namesArray3,*namesArray4,*namesArray5,*namesArray6,*namesArray7;
@property (weak, nonatomic) IBOutlet UIButton *animationButton;
@property (weak, nonatomic) IBOutlet UILabel *lblCountEvent;
@property (weak, nonatomic) IBOutlet UILabel *lblCountMilestone;
@property (weak, nonatomic) IBOutlet UILabel *lblCountAdventure;
- (IBAction)animationAction:(id)sender;
- (IBAction)backAction:(id)sender;
- (IBAction)segmentAction:(id)sender;


@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) LBRESTAdapter * adapter;

@end

@implementation BuzzCount


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _adventureList = [[NSMutableArray alloc]init];
    _milestoneList = [[NSMutableArray alloc]init];
    _eventList = [[NSMutableArray alloc]init];

    _group = [[NSMutableArray alloc]init];

    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureRight)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];

    self.adventureView.hidden=YES;
    self.eventsView.hidden=YES;


    self.milestoneTableview.delegate=self;
    self.milestoneTableview.dataSource=self;

    [self.view addSubview:self.animationButton];


    _namesArray2=[NSMutableArray arrayWithObjects:@"My Canada Weekend ", @"Fun Times in Chicago!", nil];
    _namesArray3=[NSMutableArray arrayWithObjects:@"Madrid Getaway",@"London Travels",@"New York City Adventure", nil];


    _namesArray4=[NSMutableArray arrayWithObjects:@"Cassie Harper",@"Mexico Adventure", nil];
    _namesArray5=[NSMutableArray arrayWithObjects:@"Sapin Adventure",@"Lisa Kendirck",@"Jimmy Adventure", nil];


    _namesArray6=[NSMutableArray arrayWithObjects:@"Russia Adventure",@"Kelly Hunter", nil];
    _namesArray7=[NSMutableArray arrayWithObjects:@"Katelyn jim",@"Megan smith ",@" Hawaii Adventure", nil];

    [ProjectHandler setSegmentAttributes];//for common segmentcontrol properties.


    [_milestoneSegment setSelectedSegmentIndex:_selectedIndex];

    [self segmentAction:nil];
    self.lblCountAdventure.text = nil;
    self.lblCountEvent.text = nil;
    self.lblCountMilestone.text = nil;

    [self InitUI];
}

-(void)handleSwipeGestureRight{

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)segmentAction:(UISegmentedControl*)sender
{
    [_group removeAllObjects];
    if(self.milestoneSegment.selectedSegmentIndex == 0)
    {
        self.mileStoneView.hidden=NO;
        self.adventureView.hidden=YES;
        self.eventsView.hidden=YES;
        [self getMilestoneSegment];
    }

    else if(self.milestoneSegment.selectedSegmentIndex == 1)
    {
        self.mileStoneView.hidden=YES;
        self.adventureView.hidden=NO;
        self.eventsView.hidden=YES;
        [self getAdventureSegment];
    }
    else if(self.milestoneSegment.selectedSegmentIndex == 2)
    {
        self.mileStoneView.hidden=YES;
        self.adventureView.hidden=YES;
        self.eventsView.hidden=NO;
        [self getEventSegment];
    }

    [self.milestoneTableview reloadData];

}
- (IBAction)animationAction:(id)sender
{
    AnimationVC *animation=[self.storyboard instantiateViewControllerWithIdentifier:@"AnimationView"];
    [self.navigationController pushViewController:animation animated:YES];
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_group objectAtIndex:section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _group.count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    NSString *id=@"return cell";
    NSString*dateString1;
    if (self.milestoneSegment.selectedSegmentIndex == 0) {
        BTMilestoneModel *obj = [[BTMilestoneModel alloc]initMilestoneWithDict:[_group objectAtIndex:section][0]];
        dateString1 = [[NSString stringWithFormat:@"%@",obj.milestone_createdOn] componentsSeparatedByString:@"T"][0];

    }
    if (self.milestoneSegment.selectedSegmentIndex == 1) {
        BTAdventureModel *obj = [[BTAdventureModel alloc]initAdventureWithDict:[_group objectAtIndex:section][0]];
        dateString1 = [[NSString stringWithFormat:@"%@",obj.adventure_createdOn] componentsSeparatedByString:@"T"][0];
    }

    if (self.milestoneSegment.selectedSegmentIndex == 2) {
        BTEventModel *obj = [[BTEventModel alloc]initEventWithDict:[_group objectAtIndex:section][0]];
        dateString1 = [[NSString stringWithFormat:@"%@",obj.event_createdOn] componentsSeparatedByString:@"T"][0];
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [[NSDate alloc] init];
    NSString* dateString2 = [df stringFromDate:now];
    if ([dateString1 isEqualToString:dateString2]) {
        return @"To day";
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.dateFormat = @"EEEE, MMMM dd";
        NSDate *myDate = [df dateFromString: dateString1];
        NSString *dateString = [dateFormatter stringFromDate: myDate];
        return dateString;
    }
    return id;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"NavigationCell";

    NavigationCell *cell = (NavigationCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NavigationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];

    }

    if (self.milestoneSegment.selectedSegmentIndex == 0) {
        cell.dotColorImage.image=[UIImage imageNamed:@"grendot"];
        BTMilestoneModel *obj = [[BTMilestoneModel alloc]initMilestoneWithDict:[[_group objectAtIndex:[indexPath section]] objectAtIndex:indexPath.row]];
        [cell configureCellWith:obj.milestone_title atIndex:indexPath.row];
    }
    if (self.milestoneSegment.selectedSegmentIndex == 1) {
        cell.dotColorImage.image=[UIImage imageNamed:@"redsmalldot@2x"];

        BTAdventureModel *obj = [[BTAdventureModel alloc]initAdventureWithDict:[[_group objectAtIndex:[indexPath section]] objectAtIndex:indexPath.row]];
        [cell configureCellWith:obj.adventure_title atIndex:indexPath.row];
    }
    if (self.milestoneSegment.selectedSegmentIndex == 2){
        cell.dotColorImage.image=[UIImage imageNamed:@"YellowDot"];
        BTEventModel *obj = [[BTEventModel alloc]initEventWithDict:[[_group objectAtIndex:[indexPath section]] objectAtIndex:indexPath.row]];
        NSLog(@"%@",[[_group objectAtIndex:[indexPath section]] objectAtIndex:indexPath.row]);
        [cell configureCellWith:obj.event_title atIndex:indexPath.row];
    }
    cell.verticalLineTop.hidden = indexPath.row == 0;// && indexPath.section == 0;

    cell.verticalLineBottom.hidden = indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableArray*)sortAdventure
{
    NSMutableArray *adventureGroup = [[NSMutableArray alloc]init];
    
    NSMutableArray *adventureDateListGroup = [[NSMutableArray alloc]init];
    
    NSArray* sortedAdventureArray = [[NSArray alloc] init];
    
    sortedAdventureArray= [_adventureList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(NSDictionary*)a objectForKeyedSubscript:@"createdOn"];
        NSString *second = [(NSDictionary*)b objectForKeyedSubscript:@"createdOn"];
        
        return [first compare:second];
    }];
    
    NSArray* sortedAdventureList = [[NSArray alloc]init];
    
    sortedAdventureList = [[sortedAdventureArray reverseObjectEnumerator] allObjects];
    
    int i = 0;
    
    for (i = 0 ; i < [sortedAdventureList count] ; i ++)
    {
        NSDictionary* tempDict = [sortedAdventureList objectAtIndex:i];
        
        NSString* dateKey = [[AppDelegate SharedDelegate] ParseBTServerTimeToYYYYMMDD:[tempDict objectForKeyedSubscript:@"createdOn"]];
        
        [adventureDateListGroup addObject:dateKey];
    }
    
    NSArray* orderedDateKey = [[NSOrderedSet orderedSetWithArray:adventureDateListGroup] array];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    
    for (i = 0 ; i < [orderedDateKey count] ; i ++)
    {
        NSString* key = [orderedDateKey objectAtIndex:i];
        
        tempArray = [[NSMutableArray alloc] init];
        
        for (int j = 0 ; j < [sortedAdventureList count] ; j ++)
        {
            NSDictionary* tempDict = [sortedAdventureList objectAtIndex:j];
            
            NSString* dateStr = [[AppDelegate SharedDelegate] ParseBTServerTimeToYYYYMMDD:[tempDict objectForKeyedSubscript:@"createdOn"]];
            
            if ([dateStr isEqualToString:key])
            {
                [tempArray addObject:tempDict];
            }
        }
        
        [adventureGroup addObject:tempArray];
    }
    
    return adventureGroup;
}

- (NSMutableArray*)sortMilestone
{
    NSMutableArray *milestoneListGroup = [[NSMutableArray alloc]init];
    
    NSMutableArray *milestoneDateListGroup = [[NSMutableArray alloc]init];
    
    NSArray* sortedMileStoneArray = [[NSArray alloc] init];
    
    sortedMileStoneArray= [_milestoneList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(NSDictionary*)a objectForKeyedSubscript:@"createdOn"];
        NSString *second = [(NSDictionary*)b objectForKeyedSubscript:@"createdOn"];
        
        return [first compare:second];
    }];
    
    NSArray* sortedMilestoneList = [[NSArray alloc]init];
    
    sortedMilestoneList = [[sortedMileStoneArray reverseObjectEnumerator] allObjects];
    
    int i = 0;
    
    for (i = 0 ; i < [sortedMilestoneList count] ; i ++)
    {
        NSDictionary* tempDict = [sortedMilestoneList objectAtIndex:i];
        
        NSString* dateKey = [[AppDelegate SharedDelegate] ParseBTServerTimeToYYYYMMDD:[tempDict objectForKeyedSubscript:@"createdOn"]];
        
        [milestoneDateListGroup addObject:dateKey];
    }
    
    NSArray* orderedDateKey = [[NSOrderedSet orderedSetWithArray:milestoneDateListGroup] array];
    
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    
    for (i = 0 ; i < [orderedDateKey count] ; i ++)
    {
        NSString* key = [orderedDateKey objectAtIndex:i];
        
        tempArray = [[NSMutableArray alloc] init];
        
        for (int j = 0 ; j < [sortedMilestoneList count] ; j ++)
        {
            NSDictionary* tempDict = [sortedMilestoneList objectAtIndex:j];
            
            NSString* dateStr = [[AppDelegate SharedDelegate] ParseBTServerTimeToYYYYMMDD:[tempDict objectForKeyedSubscript:@"createdOn"]];
            
            if ([dateStr isEqualToString:key])
            {
                [tempArray addObject:tempDict];
            }
        }
        
        [milestoneListGroup addObject:tempArray];
    }
    
    return milestoneListGroup;
}

- (NSMutableArray*)sortEvent
{
    NSMutableArray *eventListGroup = [[NSMutableArray alloc]init];
    
    NSMutableArray *eventDateListGroup = [[NSMutableArray alloc]init];
    
    NSArray* sortedEventArray = [[NSArray alloc] init];
    
    sortedEventArray= [_eventList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(NSDictionary*)a objectForKeyedSubscript:@"createdOn"];
        NSString *second = [(NSDictionary*)b objectForKeyedSubscript:@"createdOn"];
        
        return [first compare:second];
    }];
    
    NSArray* sortedEventList = [[NSArray alloc]init];
    
    sortedEventList = [[sortedEventArray reverseObjectEnumerator] allObjects];
    
    int i = 0;
    
    for (i = 0 ; i < [sortedEventList count] ; i ++)
    {
        NSDictionary* tempDict = [sortedEventList objectAtIndex:i];
        
        NSString* dateKey = [[AppDelegate SharedDelegate] ParseBTServerTimeToYYYYMMDD:[tempDict objectForKeyedSubscript:@"createdOn"]];
        
        [eventDateListGroup addObject:dateKey];
    }
    
    NSArray* orderedDateKey = [[NSOrderedSet orderedSetWithArray:eventDateListGroup] array];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    
    for (i = 0 ; i < [orderedDateKey count] ; i ++)
    {
        NSString* key = [orderedDateKey objectAtIndex:i];
        
        tempArray = [[NSMutableArray alloc] init];
        
        for (int j = 0 ; j < [sortedEventList count] ; j ++)
        {
            NSDictionary* tempDict = [sortedEventList objectAtIndex:j];
            
            NSString* dateStr = [[AppDelegate SharedDelegate] ParseBTServerTimeToYYYYMMDD:[tempDict objectForKeyedSubscript:@"createdOn"]];
            
            if ([dateStr isEqualToString:key])
            {
                [tempArray addObject:tempDict];
            }
        }
        
        [eventListGroup addObject:tempArray];
    }
    
    return eventListGroup;
}

- (void)getAdventureSegment
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[BTAPIClient sharedClient] getAdventurePeople:@"people"
                                      withPersonId:MyPersonModelID
                                        withFilter:Nil
                                         withBlock:^(NSArray *models, NSError *error)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        
        if (error == Nil) {
             if ([models isKindOfClass:[NSArray class]]) {
                _adventureList = [[NSMutableArray alloc]initWithArray:models];
                 _group = [self sortAdventure];
                 [_milestoneTableview reloadData];
            }
        }
    }];
}

- (void)getMilestoneSegment{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[BTAPIClient sharedClient] getMilestonePeople:@"people" withPersonId:MyPersonModelID withFilter:nil withBlock:^(NSArray *models, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        if (error == Nil) {
            if ([models isKindOfClass:[NSArray class]]) {
                _milestoneList = [[NSMutableArray alloc]initWithArray:models];
                _group = [self sortMilestone];
                [_milestoneTableview reloadData];
            }
        }
    }];
}

- (void)getEventSegment{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[BTAPIClient sharedClient] getEventPeople:@"people" withPersonId:MyPersonModelID withFilter:nil withBlock:^(NSArray *models, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        if (error == Nil) {
            if ([models isKindOfClass:[NSArray class]]) {
                _eventList = [[NSMutableArray alloc]initWithArray:models];
                _group = [self sortEvent];
                [_milestoneTableview reloadData];
            }
        }
    }];
}

- (void)InitUI{
    [[BTAPIClient sharedClient] getAdventureCount:@"people" withPersonId:MyPersonModelID withBlock:^(NSDictionary *model, NSError *error) {
        if (error == nil) {
            if ([model isKindOfClass:[NSDictionary class]]) {
                _lblCountAdventure.text = [NSString stringWithFormat:@"%d",(int)[[model objectForKeyedSubscript:@"count"] intValue]];
            }
        }
    }];
    [[BTAPIClient sharedClient] getMilestoneCount:@"people" withPersonId:MyPersonModelID withBlock:^(NSDictionary *model, NSError *error) {
        if (error == nil) {
            if ([model isKindOfClass:[NSDictionary class]]) {
                _lblCountMilestone.text = [NSString stringWithFormat:@"%d",(int)[[model objectForKeyedSubscript:@"count"] intValue]];
            }
        }
    }];
    [[BTAPIClient sharedClient] getEventCount:@"people" withPersonId:MyPersonModelID withBlock:^(NSDictionary *model, NSError *error) {
        if (error == nil) {
            if ([model isKindOfClass:[NSDictionary class]]) {
                _lblCountEvent.text = [NSString stringWithFormat:@"%d",(int)[[model objectForKeyedSubscript:@"count"] intValue]];
            }
        }
    }];
}
@end
