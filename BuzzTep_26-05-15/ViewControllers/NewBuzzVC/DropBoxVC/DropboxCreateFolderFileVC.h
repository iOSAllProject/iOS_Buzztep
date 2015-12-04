//
//  DropboxCreateFolderFileVC.h
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 11/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface DropboxCreateFolderFileVC : UIViewController<DBRestClientDelegate, UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *CreateFolderData;
    DBRestClient *restClient;
}

@property (nonatomic, strong) IBOutlet UITableView *tableCreateFolder;
@property (nonatomic, readonly) DBRestClient *restClient;
@property (nonatomic, strong) NSString *loadData;

@end
