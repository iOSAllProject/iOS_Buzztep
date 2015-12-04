//
//  BTBuzzItemDetailVC.h
//  BUZZtep
//
//  Created by Lin on 6/29/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTBuzzItemModel.h"
#import "BTBuzzItemDetailCell.h"

@interface BTBuzzItemDetailVC : UIViewController<BTBuzzItemDetailCellDelegate>

@property (nonatomic, strong) BTBuzzItemModel*  buzzitem_model;

@property (strong, nonatomic) IBOutlet UILabel* buzzitem_title;
@property (strong, nonatomic) IBOutlet UITableView* detailTableView;

@property (strong, nonatomic) IBOutlet UIButton* btn_Chrono;
@property (strong, nonatomic) IBOutlet UIButton* btn_Trending;

@property (nonatomic, strong) NSMutableArray*   buzzitem_MediaArray;

- (IBAction)onBack:(id)sender;
- (IBAction)onEdit:(id)sender;
- (IBAction)onChronoLogical:(id)sender;
- (IBAction)onTrending:(id)sender;
- (IBAction)onMainManu:(id)sender;

- (void)loadMediaList;

@end
