//
//  WebViewViewController.m
//  Belled
//
//  Created by Bellnet on 14-7-30.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "WebViewViewController.h"

@interface WebViewViewController ()
{
    MBProgressHUD *HUD;
}

@end

@implementation WebViewViewController

@synthesize setuiwebView,wanip;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    /*UIBarButtonItem *cButton = [[UIBarButtonItem alloc] initWithTitle:@"Welcome"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(doClickedBack)];
    
    self.navigationItem.leftBarButtonItem = cButton;
    
    UIBarButtonItem *rButton = [[UIBarButtonItem alloc] initWithTitle:@"Scan"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(doClickedBack3)];
    
    self.navigationItem.rightBarButtonItem = rButton;*/
    
    setuiwebView.delegate = self;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    [self http_connect];
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doClickedBack3
{
    ScanViewController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"scanView"];
    [self.navigationController pushViewController:tmpEdit animated:YES];
}

-(void)http_connect{
    NSString *str = [[NSString alloc]initWithFormat:@"http://%@",wanip];
    NSURL *url =[NSURL URLWithString:str];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [setuiwebView loadRequest:request];
}

-(void) doClickedBack
{
    [self.navigationController setNavigationBarHidden:YES animated:TRUE];
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [HUD show:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HUD hide:YES];
}


@end
