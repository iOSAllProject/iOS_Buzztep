//
//  DropboxDownloadFileVC
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 11/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface DropboxDownloadFileVC : UIViewController<DBRestClientDelegate>
{
    NSMutableArray *DownloadData;
    DBRestClient *restClient;
}

@property (nonatomic, strong) IBOutlet UITableView *tableDownload;
@property (nonatomic, readonly) DBRestClient *restClient;
@property (nonatomic, strong) NSString *loadData;

@end
