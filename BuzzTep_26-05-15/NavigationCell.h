//
//  NavigationCell.h
//  NotificationVC1
//
//  Created by Sanchit Thakur on 21/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *dotColorImage;
@property (strong, nonatomic) IBOutlet UIImageView *verticalLineTop;
@property (strong, nonatomic) IBOutlet UIImageView *verticalLineBottom;

- (void)configureCellWith:(NSString *)title atIndex:(NSInteger)index;

@end
