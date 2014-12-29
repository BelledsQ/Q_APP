//
//  RegViewController.m
//  Belled
//
//  Created by Bellnet on 14-6-25.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "RegViewController.h"

@interface RegViewController ()

@end

@implementation RegViewController
{
    MBProgressHUD *HUD;
    BOOL checkRes;
}

@synthesize username,password,passwordag;

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
    self.navigationItem.title = [NSString stringWithFormat:@"Register"];
    checkRes = YES;
    
    [username setDelegate:self];
    [password setDelegate:self];
    [passwordag setDelegate:self];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];

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

//点击Return键盘按键，触发
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
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

-(void)regUser
{
    [HUD show:YES];
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    res_dictionary = [self httpReg];
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

-(NSMutableDictionary *)httpReg
{
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    NSString *cmd = [NSString stringWithFormat:@"reg"];
    //封装mutableDictionary
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:username.text,@"username",[Tools md5 :password.text],@"password",nil];
    //mutableDictionary转NSString
    NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:userInfo];
    NSString *resdata = [NetWorkHttp httpGet:cmd Postdata:data];
    //NSLog(@"resdata:%@",resdata);
    if([resdata isEqualToString:@"999"]==false){
        res_dictionary = [NetWorkHttp httpjsonParser:resdata];
    }
    return res_dictionary;
}

-(IBAction)regAction
{
    //[HUD show:YES];
    [self checkSubmit];
    if(checkRes){
    NSLog(@"checkRes ok");
    [self regUser];
    }else{
    
    }
    
}

-(void)checkSubmit
{
    //NSMutableString *str = [NSString alloc];
    checkRes = YES;
    if([username.text isEqualToString:@"USERNAME"] || [password.text isEqualToString:@"PASSWORD"] || [passwordag.text isEqualToString:@"AGAIN PASSWORD"]){
        //str = [NSMutableString appendString:@"NO NULL"];
        NSLog(@"checkSubmit");
        checkRes = NO;
    }
    
    if([password.text isEqualToString:passwordag.text]==false){
        NSLog(@"password and passwordag nosame");
        checkRes = NO;
    }
    
    
    if([username.text length] < 6 || [username.text length] > 50 ){
        NSLog(@"username min 6 or max 50");
        checkRes = NO;
    }
    
    if([password.text length] < 6 || [password.text length] > 20 ){
        NSLog(@"password min 6 or max 20");
        checkRes = NO;
    }
    
}

- (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

-(void)showMsg:(NSString *)title message:(NSString *)tmessage
{
    
    UIAlertView *helloWorldAlert = [[UIAlertView alloc]initWithTitle:title message:tmessage delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [helloWorldAlert show];
}

-(void)showMsgs
{
    
    UIAlertView *helloWorldAlert = [[UIAlertView alloc]initWithTitle:@"Login" message:@"username or password" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [helloWorldAlert show];
}

-(void)successLogin
{
    //要从此类界面转换到HomeViewController类的界面,storyboard
    UITabBarController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    //设置翻页效果
    tmpEdit.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //实现页面的切换
    [self presentModalViewController:tmpEdit animated:YES];
}
@end
