//
//  DropboxCreateFolderFileVC.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 11/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "DropboxCreateFolderFileVC.h"
#import "MBProgressHUD.h"
#import "DropboxCell.h"
#import "DropboxIntegrationVC.h"

@interface DropboxCreateFolderFileVC ()

- (IBAction)backButton:(id)sender;

@end

@implementation DropboxCreateFolderFileVC

@synthesize tableCreateFolder;
@synthesize loadData;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableCreateFolder.delegate=self;
    self.tableCreateFolder.dataSource=self;
    
    if (!loadData)
    {
        loadData = @"";
    }
    
    CreateFolderData = [NSMutableArray new];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self performSelector:@selector(fetchAllDropboxData) withObject:nil afterDelay:.1];
}

#pragma mark - Dropbox Methods
- (DBRestClient *)restClient
{
	if (restClient == nil)
    {
		restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
		restClient.delegate = self;
	}
	return restClient;
}

-(void)fetchAllDropboxData
{
    [self.restClient loadMetadata:loadData];
}

-(void)createFolderInDropBox:(NSString *)filePath
{
    [self.restClient createFolder:filePath];
}

#pragma mark - DBRestClientDelegate Methods for Load Data
- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata *)metadata
{
    for (int i = 0; i < [metadata.contents count]; i++) {
        DBMetadata *data = [metadata.contents objectAtIndex:i];
        if (data.isDirectory) {
            [CreateFolderData addObject:data];
        }
    }
    [tableCreateFolder reloadData];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    [tableCreateFolder reloadData];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
}

#pragma mark - DBRestClientDelegate Methods for Create Folder
- (void)restClient:(DBRestClient*)client createdFolder:(DBMetadata*)folder
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:@"Folder created successfully."
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
    [alert show];
}

- (void)restClient:(DBRestClient*)client createFolderFailedWithError:(NSError*)error
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
    return [CreateFolderData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Dropbox_Cell"];
    
    DBMetadata *metadata = [CreateFolderData objectAtIndex:indexPath.row];
    
    [cell.button setTitle:metadata.path forState:UIControlStateDisabled];
    [cell.button addTarget:self action:@selector(createFolderPress:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.title.text = metadata.filename;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DBMetadata *metadata = [CreateFolderData objectAtIndex:indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    DropboxCreateFolderFileVC *dropboxCreateFolderFileViewControlller = [storyboard instantiateViewControllerWithIdentifier:@"DropboxCreateFolderFile"];
    dropboxCreateFolderFileViewControlller.loadData = metadata.path;
    [self.navigationController pushViewController:dropboxCreateFolderFileViewControlller animated:YES];
}

#pragma mark - Action Methods
-(void)createFolderPress:(id)sender
{
    UIButton *createFolder = (UIButton *)sender;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Enter Folder Name : " delegate:self cancelButtonTitle:@"Create" otherButtonTitles:@"Cancel", nil];
    alert.accessibilityLabel = [createFolder titleForState:UIControlStateDisabled];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show]; alert = nil;
}

#pragma mark - AlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self performSelector:@selector(createFolderInDropBox:) withObject:[alertView.accessibilityLabel stringByAppendingPathComponent:[alertView textFieldAtIndex:0].text] afterDelay:.1];
    }
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end