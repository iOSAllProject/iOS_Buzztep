//
//  DetailsVC.h
//  MyBuzzVC
//
//  Created by Sanchit Thakur on 21/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTBucketItemModel.h"
@interface DetailsVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray* bucketListItemArray;
@end
