//
//  ViewController.m
//  Belled
//
//  Created by Bellnet on 14-4-15.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
{
    MBProgressHUD *HUD;
    NSString *username_id;
    NSString *username_name;
    NSString *accesstoken;
    
}
@synthesize  username = _username;
@synthesize  password = _password;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    self.navigationItem.title = [NSString stringWithFormat:@"Login"];
    UIBarButtonItem *cButton = [[UIBarButtonItem alloc] initWithTitle:@"Welcome"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(doClickedBack)];
    
    self.navigationItem.leftBarButtonItem = cButton;
    
	// Do any additional setup after loading the view, typically from a nib.
    [_username setDelegate:self];
    [_password setDelegate:self];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"username_id"]];
    if([uid isEqualToString:@""]||[uid isEqualToString:@"(null)"]){
    }else{
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(chkLogin) userInfo:nil repeats:NO];
    }
}

-(void) doClickedBack
{
    [self.navigationController setNavigationBarHidden:YES animated:TRUE];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//开始输入文本，触发
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	
	return YES;
	
}

-(IBAction)loginAction
{
    [HUD show:YES];
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    res_dictionary = [self httpLogin];
    NSString *res = [res_dictionary objectForKey:@"res"];
    
    if([res isEqualToString:@"200"]){
        //成功
        username_id = [res_dictionary objectForKey:@"username_id"];
        username_name = [res_dictionary objectForKey:@"username"];
        accesstoken = [res_dictionary objectForKey:@"accesstoken"];
        //NSLog(@"username_id----%@", username_id);
        [self saveUser];
        [self successLogin];
    }else if([res isEqualToString:@"100"]){
        //失败
        [self showMsg:@"Warning" message:@"Username or Password is error."];
    }else{
        //服端端或网络异常
        [self showMsg:@"Warning" message:@"Network is error."];
    }
    [HUD hide:YES];
    
    NSLog(@"res_dictionary :%@",res_dictionary);
}

-(IBAction)regAction
{
    UIViewController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"regView"];
    tmpEdit.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:tmpEdit animated:YES];
    //[self presentModalViewController:tmpEdit animated:YES];

}

-(void)chkLogin
{
    [HUD show:YES];
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    res_dictionary = [self httpAutoLogin];
    NSString *res = [res_dictionary objectForKey:@"res"];
    if([res isEqualToString:@"200"]){
        //成功
        //[self saveUser];
        [self successLogin];
    }else if([res isEqualToString:@"100"]){
        //失败
        //[self showMsg:@"Warning" message:@"Username or Password is error."];
        NSLog(@"Username or Password is error.");
    }else{
        //服端端或网络异常
        //[self showMsg:@"Warning" message:@"Network is error."];
        NSLog(@"Network is error.");
    }
    [HUD hide:YES];
    
    NSLog(@"res_dictionary :%@",res_dictionary);
}

-(NSMutableDictionary *)httpLogin
{
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    NSString *cmd = [NSString stringWithFormat:@"login"];
    //封装mutableDictionary
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:_username.text,@"username",[Tools md5 :_password.text],@"password",nil];
    //mutableDictionary转NSString
    NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:userInfo];
    NSString *resdata = [NetWorkHttp httpGet:cmd Postdata:data];
    //NSLog(@"resdata:%@",resdata);
    if([resdata isEqualToString:@"999"]==false){
        res_dictionary = [NetWorkHttp httpjsonParser:resdata];
    }
    return res_dictionary;
}

-(NSMutableDictionary *)httpAutoLogin
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //NSString *testStr = [ud objectForKey:@"accesstoken"];
    //NSLog(@"httpAutoLogin accesstoken %@",testStr);
    NSString *uid = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"username_id"]];
    //NSString *uname = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"username_name"]];
    NSString *token = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"accesstoken"]];
    
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    NSString *cmd = [NSString stringWithFormat:@"checktoken"];
    //封装mutableDictionary
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uid,@"username_id",token,@"accesstoken",nil];
    //mutableDictionary转NSString
    NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:userInfo];
    NSString *resdata = [NetWorkHttp httpGet:cmd Postdata:data];
    //NSLog(@"resdata:%@",resdata);
    if([resdata isEqualToString:@"999"]==false){
        res_dictionary = [NetWorkHttp httpjsonParser:resdata];
    }
    return res_dictionary;
}

-(void)saveUser
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:username_id forKey:@"username_id"];
    [ud setObject:username_name forKey:@"username_name"];
    [ud setObject:accesstoken forKey:@"accesstoken"];
    [ud synchronize];
    
    NSString *testStr = [ud objectForKey:@"accesstoken"];
    NSLog(@"saveUser is: %@",testStr);
}

//点击Return键盘按键，触发
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

//实现界面的切换  并把值传递过去
-(void)successLogin
{
    //要从此类界面转换到HomeViewController类的界面,storyboard
    UITabBarController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
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
    //[self pushViewController:tmpEdit animated:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
	HUD = nil;
}


-(void)showMsg:(NSString *)title message:(NSString *)tmessage
{
    
    UIAlertView *helloWorldAlert = [[UIAlertView alloc]initWithTitle:title message:tmessage delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [helloWorldAlert show];
}
@end
