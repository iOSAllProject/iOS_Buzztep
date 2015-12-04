//
//  DropboxUploadFileVC.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 11/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "DropboxUploadFileVC.h"
#import "DropboxCell.h"
#import "MBProgressHUD.h"
#import "DropboxIntegrationVC.h"

@interface DropboxUploadFileVC ()<UITableViewDataSource,UITableViewDelegate>

- (IBAction)backButton:(id)sender;

@end

@implementation DropboxUploadFileVC

@synthesize tableUpload;
@synthesize loadData;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableUpload.delegate=self;
    self.tableUpload.dataSource=self;
    
    if (!loadData)
    {
        loadData = @"";
    }
    
    UploadData = [NSMutableArray new];
    
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
    for (int i = 0; i < [metadata.contents count]; i++)
    {
        DBMetadata *data = [metadata.contents objectAtIndex:i];
        if (data.isDirectory) {
            [UploadData addObject:data];
        }
    }
    [tableUpload reloadData];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    [tableUpload reloadData];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
}

#pragma mark - DBRestClientDelegate Methods for Upload Data
-(void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:@"File uploaded successfully."
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
    [alert show];
}

-(void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error
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
    return [UploadData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Dropbox_Cell"];
    
    DBMetadata *metadata = [UploadData objectAtIndex:indexPath.row];
    
    [cell.button setTitle:metadata.path forState:UIControlStateDisabled];
    [cell.button addTarget:self action:@selector(uploadPress:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.title.text = metadata.filename;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DBMetadata *metadata = [UploadData objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DropboxUploadFileVC *dropboxUploadFileViewControlller = [storyboard instantiateViewControllerWithIdentifier:@"DropboxUploadFile"];
    dropboxUploadFileViewControlller.loadData = metadata.path;
    [self.navigationController pushViewController:dropboxUploadFileViewControlller animated:YES];
}

#pragma mark - Action Methods
-(void)uploadPress:(id)sender
{
    UIButton *upload = (UIButton *)sender;
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelector:@selector(uploadFileToDropBox:) withObject:[upload titleForState:UIControlStateDisabled] afterDelay:.1];
}
-(void)uploadFileToDropBox:(NSString *)filePath
{
    [self.restClient uploadFile:@"BuzzTep.png" toPath:filePath withParentRev:@"" fromPath:[[NSBundle mainBundle] pathForResource:@"BuzzTep" ofType:@"png"]];
}





- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end