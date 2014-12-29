//
//  LightTitleViewController.m
//  Belled
//
//  Created by Bellnet on 14-8-21.
//  Copyright (c) 2014年 Belled. All rights reserved.
//

#import "LightTitleViewController.h"

@interface LightTitleViewController ()

@end

@implementation LightTitleViewController
{
    MBProgressHUD *HUD;
}
@synthesize  sn,oldtitle,ssn,soldtitle,lightTitle,lightID;

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
    sn.text = ssn;
    oldtitle.text = soldtitle;
    lightTitle.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)submit
{
    if([lightTitle.text isEqualToString:@""]){
        [Tools showMsg:@"Warning" message:@"LightTitle is NULL."];
    }else{
        [self doSubmit];
        [self pageChange];
    }
    NSLog(@"%@",@"submit");
}

//点击Return键盘按键，触发
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

-(void)doSubmit
{
    //全局变量
    [HUD show:YES];
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    res_dictionary = [self httpRequest];
    NSString *res = [res_dictionary objectForKey:@"res"];
    
    if([res isEqualToString:@"200"]){
        //成功
        [Tools showMsg:@"OK" message:@"SUCCESS!"];
    }else if([res isEqualToString:@"100"]){
        //失败
        [Tools showMsg:@"Warning" message:@"Miss"];
    }else{
        //服端端或网络异常
        [Tools showMsg:@"Warning" message:@"Network is error."];
    }
    [HUD hide:YES];
    
    NSLog(@"res_dictionary :%@",res_dictionary);
    
}

-(NSMutableDictionary *)httpRequest
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"username_id"]];
    NSString *token = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"accesstoken"]];
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    NSString *cmd = [NSString stringWithFormat:@"light_title_mod"];

    //封装mutableDictionary
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uid,@"username_id",token,@"accesstoken",lightTitle.text,@"title",lightID,@"lightID",nil];
        //mutableDictionary转NSString
    NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:postdata];
    NSString *resdata = [NetWorkHttp httpGet:cmd Postdata:data];
        //NSLog(@"resdata:%@",resdata);
    if([resdata isEqualToString:@"999"]==false){
            res_dictionary = [NetWorkHttp httpjsonParser:resdata];
    }
    return res_dictionary;
}

-(void)pageChange
{
    UITabBarController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    //设置翻页效果
    tmpEdit.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //实现页面的切换
    [self presentModalViewController:tmpEdit animated:YES];
}

@end
