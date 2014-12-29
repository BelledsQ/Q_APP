//
//  OauthTokenViewController.m
//  Belled
//
//  Created by Bellnet on 14-5-27.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "OauthTokenViewController.h"

@interface OauthTokenViewController ()

@end

@implementation OauthTokenViewController
{
    MBProgressHUD *HUD;
    NSMutableDictionary         *tokenME;
    NSString                    *token;
    NSMutableDictionary         *me;
}

@synthesize  webview;

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
    // Do any additional setup after loading the view.
    /*[SCSoundCloud setClientID:@"25432515caaf0623ebf6c5d383a11714"
                       secret:@"840077db9734a222a3c0b0b3a25b557f"
                  redirectURL:[NSURL URLWithString:@"http://asiat.avalaa.com/soundcloud/SDapi.php"]];*/
    webview.delegate = self;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];

    [self.view addSubview:HUD];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showMsgs
{
    
    UIAlertView *helloWorldAlert = [[UIAlertView alloc]initWithTitle:@"Login" message:@"username or password" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [helloWorldAlert show];
}

-(void)showMsg:(NSString *)title message:(NSString *)tmessage
{
    
    UIAlertView *helloWorldAlert = [[UIAlertView alloc]initWithTitle:title message:tmessage delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [helloWorldAlert show];
}

-(IBAction)connectSC
{
    [self http_connect];
}

-(IBAction)gethtml
{
    //NSString *lJs = @"document.documentElement.innerHTML";
    
    NSString *lJs = @"document.body.innerText";
    NSString *lHtml1 = [webview stringByEvaluatingJavaScriptFromString:lJs];
    tokenME = [[NSMutableDictionary alloc] init];
    tokenME = [NetWorkHttp httpjsonParser:lHtml1];
    token = [NSString stringWithFormat:@"%@", [tokenME objectForKey:@"access_token"]];
    [self api_Me];
    [self changeSCTableView];
    NSLog(@"lHtml1:%@",lHtml1);
}

-(void)http_connect{
    NSURL *url =[NSURL URLWithString:@"http://asiat.avalaa.com/soundcloud/"];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
   [webview loadRequest:request];
}


//实现界面的切换  并把值传递过去
-(void)changeSCTableView
{
    //要从此类界面转换到HomeViewController类的界面,storyboard
    SCBViewController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"scTableView"];
    
    //全局变量
    GlobalSet *gt = [GlobalSet bellSetting];
    gt.apime = [me copy];
    gt.apitoken = [token copy];
    
    //设置翻页效果
    tmpEdit.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    /*
     其他翻页效果：
     UIModalTransitionStyleCoverVertical
     UIModalTransitionStyleFlipHorizontal
     UIModalTransitionStyleCrossDissolve
     UIModalTransitionStylePartialCurl
     */
    
    //试图切换
    //[self presentModalViewController:tmpEdit animated:YES];
    
    //带导航的试图切换
    [self.navigationController pushViewController:tmpEdit animated:YES];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [HUD show:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HUD hide:YES];
}

-(IBAction)loginAction
{
    SCLoginViewControllerCompletionHandler handler = ^(NSError *error) {
        if (SC_CANCELED(error)) {
            NSLog(@"Canceled!");
        } else if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        } else {
            NSLog(@"Done!");
        }
    };
    
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
        SCLoginViewController *loginViewController;
        
        loginViewController = [SCLoginViewController
                               loginViewControllerWithPreparedURL:preparedURL
                               completionHandler:handler];
        [self presentModalViewController:loginViewController animated:YES];
    }];
    //[self successLogin];
    //NSLog(@"%@",[SCSoundCloud account]);
}

//实现界面的切换  并把值传递过去
-(void)successLogin
{
    //要从此类界面转换到HomeViewController类的界面,storyboard
    SCBViewController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"SCBViewController"];
    //- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated;
    
    //打印movie对象里面的值
    //NSLog(@"%@",movie);
    
    //把movie里面的值（name price summary）赋给 EditViewController 类里面的movie对象editMovie
    //tmpEdit.editMovie = movie;
    
    //设置翻页效果
    tmpEdit.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    /*
     其他翻页效果：
     UIModalTransitionStyleCoverVertical
     UIModalTransitionStyleFlipHorizontal
     UIModalTransitionStyleCrossDissolve
     UIModalTransitionStylePartialCurl
     */
    
    //实现页面的切换
    [self presentModalViewController:tmpEdit animated:YES];
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
//点击Return键盘按键，触发
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

-(void)api_Me
{
    NSLog(@"scME");
    
    //[HUD show:YES];
    
    if(token==nil){
        
        [Tools showMsg:@"Error" message:@"token is null"];
        
    }else{
        NSString *cmd = [NSString stringWithFormat:@"https://api.soundcloud.com/me.json?oauth_token=%@",token];
        
        NSString *resdata = [NetWorkHttp httpGet_SC:cmd];
        
        //NSLog(@"resdata:%@",resdata);
        
        //[HUD hide:YES];
        
        me = [[NSMutableDictionary alloc] init];
        
        me = [NetWorkHttp httpjsonParser:resdata];
        
        //NSString *uid = [me objectForKey:@"id"];
        
        //NSLog(@"res_dictionary :%@ , id: %@",me,uid);
        
    }
}


@end
