//
//  DropboxDownloadFileVC.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 11/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "DropboxDownloadFileVC.h"
#import "MBProgressHUD.h"
#import "DropboxCell.h"
#import "DropboxIntegrationVC.h"
#import "ProjectHandler.h"

@interface DropboxDownloadFileVC ()<UITableViewDelegate,UITableViewDataSource>

- (IBAction)backButton:(id)sender;

@end

@implementation DropboxDownloadFileVC

@synthesize tableDownload;
@synthesize loadData;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableDownload.delegate=self;
    self.tableDownload.dataSource=self;
    
    if (!loadData) {
        loadData = @"";
    }
    
    DownloadData = [NSMutableArray new];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(fetchAllDropboxData) withObject:nil afterDelay:.1];
}

#pragma mark - Dropbox Methods
- (DBRestClient *)restClient
{
	if (restClient == nil) {
		restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
		restClient.delegate = self;
	}
	return restClient;
}

-(void)fetchAllDropboxData
{
    [self.restClient loadMetadata:loadData];
}


#pragma mark - DBRestClientDelegate Methods for Load Data
- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata *)metadata
{
    for (int i = 0; i < [metadata.contents count]; i++) {
        DBMetadata *data = [metadata.contents objectAtIndex:i];
        [DownloadData addObject:data];
    }
    
//   NSLog(@"downloaded data%@",DownloadData);
    [tableDownload reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    [tableDownload reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
}

#pragma mark - DBRestClientDelegate Methods for Download Data
- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath
{
   
    NSLog(@"destination path=%@",destPath);
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:@"File downloaded successfully."
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
    [alert show];
}

-(void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:[error localizedDescription]
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [DownloadData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Dropbox_Cell"];
    DBMetadata *metadata = [DownloadData objectAtIndex:indexPath.row];
    
    [cell.button setTitle:metadata.path forState:UIControlStateDisabled];
    [cell.button addTarget:self action:@selector(downloadPress:) forControlEvents:UIControlEventTouchUpInside];
    
    if (metadata.isDirectory)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.button.hidden = YES;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.button.hidden = NO;
    }
    
    cell.title.text = metadata.filename;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DBMetadata *metadata = [DownloadData objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DropboxDownloadFileVC *dropboxDownloadFile = [storyboard instantiateViewControllerWithIdentifier:@"DropboxDownloadFile"];
    dropboxDownloadFile.loadData = metadata.path;
    [self.navigationController pushViewController:dropboxDownloadFile animated:YES];
}

#pragma mark - Action Methods
-(void)downloadPress:(id)sender
{
    UIButton *download = (UIButton *)sender;
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(downloadFileFromDropBox:) withObject:[download titleForState:UIControlStateDisabled] afterDelay:0.1];
}

-(void)downloadFileFromDropBox:(NSString *)filePath
{
//    NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *newDir = MyPicturesDirPath;
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:newDir])
    {
        NSData *data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/myPictures"]];
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:newDir withIntermediateDirectories:YES attributes:nil error:&error];
        [data writeToFile:newDir atomically:YES];
    }

    
    [self.restClient loadFile:filePath intoPath:[newDir stringByAppendingPathComponent:[filePath lastPathComponent]]];
    
    NSLog(@"download file path=%@",filePath);
    
}
- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end