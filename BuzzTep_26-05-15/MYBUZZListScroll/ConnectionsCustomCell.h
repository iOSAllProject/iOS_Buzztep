//
//  ConnectionsCustomCell.h
//  Animation
//
//  Created by Sanchit Thakur on 22/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ConectCustomCellDelegate;
@interface ConnectionsCustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *flightImageView;
@property (nonatomic, assign) NSInteger indexPath;
@property (nonatomic, retain) id<ConectCustomCellDelegate> delegate;
- (void)configureNotificationCell:(NSDictionary *)dict;
@property (nonatomic, strong) NSString* url;
@property (weak, nonatomic) IBOutlet UIButton *btn_follow;
- (IBAction)doFollow:(id)sender;
@end
@protocol ConectCustomCellDelegate <NSObject>

- (void)clickFollow:(NSInteger)index;

@end
