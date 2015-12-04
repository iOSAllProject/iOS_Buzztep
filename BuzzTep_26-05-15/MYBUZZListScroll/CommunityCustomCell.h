//
//  CommunityCustomCell.h
//  Animation
//
//  Created by Sanchit Thakur on 22/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CommunicationCustomCellDelegate;
@interface CommunityCustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *flightImageView;
@property (nonatomic, assign) NSInteger indexPath;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, retain) id<CommunicationCustomCellDelegate> delegate;
- (IBAction)doFollow:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn_follow;
- (void)configureNotificationCell:(NSDictionary *)dict;
@end
@protocol CommunicationCustomCellDelegate <NSObject>

- (void)clickFollow :(NSInteger)index;

@end
