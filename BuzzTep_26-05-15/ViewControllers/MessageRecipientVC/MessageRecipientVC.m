//
//  MessageRecipientVC.m
//  CocaColaVC
//
//  Created by Sanchit Thakur on 22/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "MessageRecipientVC.h"
#import "MessageRecipientCell.h"
#import "MessageFilledVC.h"
#import "MessagesVC.h"
#import "AppDelegate.h"

@interface MessageRecipientVC ()<UITableViewDelegate, UITableViewDataSource>

@property NSArray *namesArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backButton:(id)sender;

@end

@implementation MessageRecipientVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    
    
    self.namesArray=@[
                      
                      @{@"nameLabel" : @"Brendan Weish"},
                      @{@"nameLabel" : @"Lisa Gaida"},
                      @{@"nameLabel" : @"Katelyn Harper"},
                      @{@"nameLabel" : @"Justin Kempiak"},
                      @{@"nameLabel" : @"Faheem Hasan"},
                      @{@"nameLabel" : @"Dave beamish"},
                      @{@"nameLabel" : @"Ismail Akram"},
                      @{@"nameLabel" : @"Dave Beamish"},
                      @{@"nameLabel" : @"isamil Akram"},
                      @{@"nameLabel" : @"Justin Kempiak"},
                      @{@"nameLabel" : @"Faheem Hasan"},
                      @{@"nameLabel" : @"Dave Beamish"},
                      
                      
                      ];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureRight)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeGesture];
    
}
-(void)handleSwipeGestureRight
{
    MessagesVC *BPVC=[self.storyboard instantiateViewControllerWithIdentifier:@"addrecipient"];
    [self.navigationController pushViewController:BPVC animated:YES];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.namesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MessageRecipientCell";
    
    
    MessageRecipientCell *cell = (MessageRecipientCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageRecipientCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell configureNotificationCell:self.namesArray[indexPath.row]];
    
    if (indexPath.row==2) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"greeen"]];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ((indexPath.row % 2) == 0)
    {
        cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    }
    else
    {
        cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==2)
    {
        NSLog(@"selected tick");
        
        MessageFilledVC *MFVC=[self.storyboard instantiateViewControllerWithIdentifier:@"meetup"];
        
        [self.navigationController pushViewController:MFVC animated:YES];
    }
}

- (IBAction)backButton:(id)sender
{
    MessagesVC *BPVC=[self.storyboard instantiateViewControllerWithIdentifier:@"addrecipient"];
    
    [self.navigationController pushViewController:BPVC
                                         animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
