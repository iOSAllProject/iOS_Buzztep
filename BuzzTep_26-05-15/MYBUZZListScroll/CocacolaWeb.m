//
//  CocacolaWeb.m
//  CocaColaVC
//
//  Created by Sanchit Thakur on 22/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "CocacolaWeb.h"

#import "AppDelegate.h"

@interface CocacolaWeb ()<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityind;
@property (strong, nonatomic) IBOutlet UITextField *urlTextField;
- (IBAction)webCancelAction:(id)sender;
- (IBAction)webReload:(id)sender;

@property  NSTimer *timer;


@end

@implementation CocacolaWeb

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.webView.delegate=self;
    
    NSString *urlString=@"http://www.coca-colacompany.com/";
    NSURL *url=[NSURL URLWithString:urlString];
    //NSURL*url=[NSURL URLWithString:[NSString stringWithFormat:@"http://www.%@.com",self.urlTextField.text]];
    NSURLRequest *obj=[NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:obj];
    [_webView addSubview:_activityind];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityind startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [self.activityind stopAnimating];
    self.activityind.hidden=YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error loading the requested URL" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [self.activityind stopAnimating];
      self.activityind.hidden=YES;

}
- (IBAction)webReload:(id)sender
{
    [self.activityind startAnimating];
    [self.webView reload];
}
- (IBAction)webCancelAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

@end
