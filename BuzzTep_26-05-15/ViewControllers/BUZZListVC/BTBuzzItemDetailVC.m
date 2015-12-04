//
//  BTBuzzItemDetailVC.m
//  BUZZtep
//
//  Created by Lin on 6/29/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTBuzzItemDetailVC.h"
#import "BTBuzzItemModel.h"
#import "BTBuzzItemDetailCell.h"
#import "BTMediaModel.h"
#import "AnimationVC.h"
#import "BTBuzzEditVC.h"

#import "AppDelegate.h"
#import "Global.h"
#import "Constant.h"
#import "BTAPIClient.h"
#import "MBProgressHUD.h"

#import "JTSImageViewController.h"
#import "JTSImageInfo.h"

@interface BTBuzzItemDetailVC ()

@end

@implementation BTBuzzItemDetailVC

@synthesize buzzitem_model;
@synthesize buzzitem_MediaArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.buzzitem_model.buzzitem_BuzzDict objectForKeyedSubscript:@"title"])
    {
        self.buzzitem_title.text = [self.buzzitem_model.buzzitem_BuzzDict objectForKeyedSubscript:@"title"];
    }
    
    [self.btn_Chrono setTitleColor:kBTMilestoneTitleColor
                          forState:UIControlStateNormal];
    
    [self.btn_Trending setTitleColor:[UIColor blackColor]
                            forState:UIControlStateNormal];
    
    [self loadMediaList];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:@"kBTBuzzUpdated"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)onBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onEdit:(id)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshMediaList) name:@"kBTBuzzUpdated"
                                               object:Nil];
    
    UIStoryboard *btBuzzEdit_storyboard = [UIStoryboard storyboardWithName:@"BTBuzzEdit" bundle:nil];
    
    BTBuzzEditVC *buzzEditVC = [btBuzzEdit_storyboard instantiateViewControllerWithIdentifier:@"BTBuzzEditVC"];
    
    buzzEditVC.buzzitem_model = self.buzzitem_model;
    
    buzzEditVC.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:buzzEditVC animated:YES completion:nil];
}

- (IBAction)onChronoLogical:(id)sender
{
    [self.btn_Chrono setTitleColor:kBTMilestoneTitleColor
                          forState:UIControlStateNormal];
    [self.btn_Trending setTitleColor:[UIColor blackColor]
                            forState:UIControlStateNormal];
}

- (IBAction)onTrending:(id)sender
{
    [self.btn_Chrono setTitleColor:[UIColor blackColor]
                          forState:UIControlStateNormal];
    [self.btn_Trending setTitleColor:kBTMilestoneTitleColor
                            forState:UIControlStateNormal];
}

- (IBAction)onMainManu:(id)sender
{
    AnimationVC *animation =[self.storyboard instantiateViewControllerWithIdentifier:@"AnimationView"];
    
    [self.navigationController pushViewController:animation animated:YES];
}

#pragma mark - Utility Function

- (void)refreshMediaList
{
    if (self.buzzitem_model)
    {
        NSString* modelId = [self.buzzitem_model.buzzitem_BuzzDict objectForKeyedSubscript:@"id"];
        
        NSString* modelName = Nil;
        
        __block GlobalBuzzType buzzType = Global_BuzzType_Adventure;
        
        if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Adventure)
        {
            modelName = @"adventures";
            
            buzzType = Global_BuzzType_Adventure;
            
        }
        else if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Milestone)
        {
            modelName = @"milestones";
            
            buzzType = Global_BuzzType_Milestone;
            
        }
        else if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Event)
        {
            modelName = @"events";
            
            buzzType = Global_BuzzType_Event;
        }
        
        NSDictionary *params = @{@"include":@"media"};
        
        NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
        
        NSString *paramsStr = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
        
        NSString* filterQuery = [NSString stringWithFormat:@"filter=%@", paramsStr];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[BTAPIClient sharedClient] refreshBuzzFor:modelName
                                       withModelID:modelId withFilter:filterQuery
                                         withBlock:^(NSDictionary *model, NSError *error)
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            
            if (error == Nil)
            {
                self.buzzitem_model = Nil;
                
                self.buzzitem_model = [[BTBuzzItemModel alloc] initBuzzItemWithDict:model
                                                                           withType:buzzType];
                
                [self loadMediaList];
            }
        }];
        
    }
}

- (void)loadMediaList
{
    // Fill Array with media object
    
    if (self.buzzitem_model)
    {
        NSInteger mCount = [self.buzzitem_model buzzMediaCount];
        
        if (mCount)
        {
            self.buzzitem_MediaArray = [[NSMutableArray alloc] init];
            
            NSArray* mediaArray = [self.buzzitem_model.buzzitem_BuzzDict objectForKeyedSubscript:@"media"];
            
            for (int i = 0; i < mCount ; i ++)
            {
                NSDictionary* mediaDict = [mediaArray objectAtIndex:i];
                
                BTMediaModel* media = [[BTMediaModel alloc] initMediaWithDict:mediaDict];
                
                [self.buzzitem_MediaArray addObject:media];
            }
        }
    }
    
    // Reload Tableview
    
    [self.detailTableView reloadData];
}

#pragma mark - UITableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.buzzitem_MediaArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"BTBuzzItemDetailCell";
    
    // DataSource
    
    BTMediaModel* cellModel = [self.buzzitem_MediaArray objectAtIndex:indexPath.row];
    
    BTBuzzItemDetailCell* detailCell = (BTBuzzItemDetailCell* )[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (detailCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        detailCell = [nib objectAtIndex:0];
    }
    
    detailCell.delegate = self;
    [detailCell initCellWithBuzzItemModel:cellModel];
    
    [detailCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return detailCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 310;
}

#pragma mark - BTBuzzItemDetailCellDelegate

- (void)expandImage:(UIImageView* )mediaImageView
{
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    
    imageInfo.image = mediaImageView.image;
    
    imageInfo.referenceRect = mediaImageView.frame;
    imageInfo.referenceView = mediaImageView.superview;
    imageInfo.referenceContentMode = mediaImageView.contentMode;
    imageInfo.referenceCornerRadius = mediaImageView.layer.cornerRadius;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
    
    // Present the view controller.
    [imageViewer showFromViewController:self
                             transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

@end
