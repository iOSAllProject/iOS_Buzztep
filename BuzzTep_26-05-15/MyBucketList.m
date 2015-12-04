//
//  MyBucketList.m
//  MyBucketListVC
//
//  Created by Sanchit Thakur on 21/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "MyBucketList.h"
#import "DetailsVC.h"
#import "MyBuzzListVC.h"
#import "BuzzProfileVC.h"
#import "AnimationVC.h"
#import "ProjectHandler.h"

#define prototypename @"bucketitems"

//http://buzztep.com:80/api/bucketitems

@interface MyBucketList ()

@property (strong, nonatomic) IBOutlet UITableView *bucketListTableView;
- (IBAction)pinAction:(id)sender;
- (IBAction)animationAction:(id)sender;
- (IBAction)backAction:(id)sender;


@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) LBRESTAdapter * adapter;
@property (strong, nonatomic) NSMutableArray *bucketListItem;
@property NSArray *noArray;
@property NSArray *bucketListArray;
@property NSInteger *i;

@end

@implementation MyBucketList

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureRight11)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
    
    self.bucketListTableView.dataSource=self;
    self.bucketListTableView.delegate=self;
//    self.bucketListArray=[NSArray arrayWithObjects:@"1. Sky diving",@"2. Ride in a Hot",@"3. Visit San Fransisco",@"4. See the Leaving Tower of Pisa",@"5. Go apple picking",@"6. Take a boat ride",@"7. Ice fishing", nil];
    [self loadServerData];
}
-(void)handleSwipeGestureRight11
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - LoopBack Data
-(void)viewWillAppear:(BOOL)animated
{
    NSDictionary *params = @{@"status": [[NSString alloc] initWithFormat:@"category %u", (arc4random() % 33 + 1)],
                             @"message" : [NSNumber numberWithInteger:(arc4random() % 60 + 1)]};
    
    [[ProjectHandler sharedHandler] dataFromServerForModelName:prototypename
                                                    parameters:params
                                                       success:^(NSArray *models) {
                                                           
                                                           NSLog( @"selfSuccessBlock %lu", (unsigned long)models.count);
                                                           self.tableData  = models;
                                                           [self.bucketListTableView reloadData];
                                                           
                                                       }
                                                       failure:nil];
    return;
}

-(NSArray*)tableData
{
    if (!_tableData) _tableData = [[NSMutableArray alloc] init];
    return _tableData;
}

- (void)getModels
{
    // Get all the model instances on the server
    //  the load error functional block
    
    void (^loadErrorBlock)(NSError *) = ^(NSError *error)
    {
        NSLog( @"Error %@", error.description); //end selfFailblock
    };
    
    //  the load success block for the LBModelRepository allWithSuccess message
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models)
    {
        NSLog( @"selfSuccessBlock %lu", (unsigned long)models.count);
        self.tableData  = models;
        [self.bucketListTableView reloadData];
        
    };//end selfSuccessBlock
    
    //Get a local representation of the model type
    LBModelRepository *objectB = [[self adapter] repositoryWithModelName:prototypename];
    
    
    // Invoke the allWithSuccess message for the LBModelRepository
    // Equivalent http JSON endpoint request : http://buzztep.com:3000/api
    
    [objectB allWithSuccess: loadSuccessBlock failure: loadErrorBlock];
}


-(void)createNewModel
{
    // Uncomment the comment block below to call a custom method on the server
   
    //Get a local representation of the model type
    LBModelRepository *prototype = [[self adapter] repositoryWithModelName:prototypename];
    
    //create new LBModel of type
    LBModel *model = [prototype modelWithDictionary:@{ @"status": @"message", @"name" : @99 }];
    
    // Define the load error functional block
    void (^saveNewErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error on Save %@", error.description);
    };
    
    // Define the load success block for saveNewSuccessBlock message
    void (^saveNewSuccessBlock)() = ^() {
        
        // call a 'local' refresh to update the tableView
        [self getModels];
    };
    
    //Persist the newly created Model to the LoopBack node server
    [model saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
};

-(void)updateExistingModel
{
    // Uncomment the comment block below to call a custom method on the server
    // Define the find error functional block
    void (^findErrorBlock)(NSError *) = ^(NSError *error)
    {
        NSLog( @"Error No model found with ID %@", error.description);
    };
    
    // Define your success functional block
    void (^findSuccessBlock)(LBModel *) = ^(LBModel *model) {
        //dynamically add an 'inventory' variable to this model type before saving it to the server
        model[@"name"] = @"UPDATED NAME";
        
        //Define the save error block
        void (^saveErrorBlock)(NSError *) = ^(NSError *error) {
            NSLog( @"Error on Save %@", error.description);
        };
        void (^saveSuccessBlock)() = ^() {
            NSLog( @"Success on updateExistingModel ");
            // call a 'local' refresh to update the tableView
            [self getModels];
        };
        [model saveWithSuccess:saveSuccessBlock failure:saveErrorBlock];
    };
    
    //Get a local representation of the model type
    LBModelRepository *prototype = [[self adapter] repositoryWithModelName:prototypename];
    
    //Get the instance of the model with ID = 2
    // Equivalent http JSON endpoint request : http://buzztep.com:3000/api
    [prototype findById:@2 success:findSuccessBlock failure:findErrorBlock];
    
}//end updateExistingModelAndPushToServer

-(void)deleteExistingModel
{
    // Uncomment the comment block below to call a custom method on the server
    // Define the find error functional block
    void (^findErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error No model found with ID %@", error.description);
    };
    
    // Define your success functional block
    void (^findSuccessBlock)(LBModel *) = ^(LBModel *model) {
        
        //Define the save error block
        void (^removeErrorBlock)(NSError *) = ^(NSError *error) {
            NSLog( @"Error on Save %@", error.description);
        };
        void (^removeSuccessBlock)() = ^() {
            NSLog( @"Success deleteExistingModel");
            // call a 'local' refresh to update the tableView
            [self getModels];
        };
        
        //Destroy this model instance on the LoopBack node server
        [model destroyWithSuccess:removeSuccessBlock failure:removeErrorBlock];
    };
    
    //Get a local representation of the model type
    LBModelRepository *prototype = [ [self adapter] repositoryWithModelName:prototypename];
    
    //Get the instance of the model with ID = 2
    // Equivalent http JSON endpoint request : http://buzztep.com:3000/api
    [prototype findById:@2 success:findSuccessBlock failure:findErrorBlock];
    
}//end deleteExistingModel
#pragma mark

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // return [self.bucketListArray count];
    
    return [_bucketListItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MyBucketList";
    
    
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
     cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
    cell.backgroundColor=[UIColor  colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Rightgreenarrow1.png" ]];
    [cell.accessoryView setFrame:CGRectMake(0, 0, 10, 15)];

    BTBucketItemModel *item = [[BTBucketItemModel alloc]initBucketItemWithDict:[_bucketListItem objectAtIndex:indexPath.row]];

    cell.textLabel.text = [NSString stringWithFormat:@"%d.     %@",(int)indexPath.row + 1,item.bucketitem_title];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    DetailsVC *details=[self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
        details.bucketListItemArray = _bucketListItem;
    [self.navigationController pushViewController:details animated:YES];
  
}

- (IBAction)pinAction:(id)sender
{
    MyBuzzListVC *buzzlist=[self.storyboard instantiateViewControllerWithIdentifier:@"mybuzzlist"];
    [self.navigationController pushViewController:buzzlist animated:YES];
    
    NSLog(@"Attach pin Action");
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadServerData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"order" : @"createdOn DESC"};
    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSString *paramsStr = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
    NSString* filterQuery = [NSString stringWithFormat:@"filter=%@", paramsStr];

    [[BTAPIClient sharedClient] getBucketItemPeople:@"people" withPersonId:MyPersonModelID withFilter:filterQuery withBlock:^(NSArray *models, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error ==  nil) {
            if ([models isKindOfClass:[NSArray class]]) {
                _bucketListItem = [[NSMutableArray alloc]initWithArray:models];
                [_bucketListTableView reloadData];
            }
        }
    }];
}
@end
