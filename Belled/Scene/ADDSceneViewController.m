//
//  ADDSceneViewController.m
//  Belled
//
//  Created by Bellnet on 14-10-13.
//  Copyright (c) 2014年 Belled. All rights reserved.
//

#import "ADDSceneViewController.h"

@interface ADDSceneViewController ()

@end

@implementation ADDSceneViewController
{
    MBProgressHUD *HUD;
}

@synthesize tit,des,scenetype,wanip;
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
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    tit.delegate = self;
    des.delegate = self;
    if([scenetype isEqualToString:@"group"]){
        self.navigationItem.title = [NSString stringWithFormat:@"ADD Group"];
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"ADD Scene"];
    }
}

//点击Return键盘按键，触发
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

-(IBAction)submit
{
    if([tit.text isEqualToString:@""]){
        [Tools showMsg:@"Warning" message:@"Title is NULL."];
    }else{
        if([scenetype isEqualToString:@"group"]){
            [self doSubmit_udp];
        }else{
            [self doSubmit];
        }
        
        [self pageChange];
    }
    NSLog(@"%@",@"submit");
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
    NSString *cmd = [NSString stringWithFormat:@"scene_add"];
    
    //封装mutableDictionary
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uid,@"username_id",token,@"accesstoken",tit.text,@"title",des.text,@"des",nil];
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
    static NSString *detailIdentifier = @"sceneListview";
    SceneTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:detailIdentifier];
    if([scenetype isEqualToString:@"group"]){
       detail.scenetype = @"group";
       detail.wanip = wanip;
    }
    //[self presentModalViewController:detail animated:YES];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//udp发送
-(NSString *)NSString2Json:(int)value
{
    NSMutableDictionary *cmdctrl = [[NSMutableDictionary alloc] init];
    
    switch (value) {
        case 1:
            //获取组列表
            cmdctrl = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"add_group",@"cmd",tit.text,@"group_title",des.text,@"description",nil];
            break;
            
    }
    
    NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:cmdctrl];
    return data;
    
}

-(void)doSubmit_udp
{
    [HUD show:YES];
    NSString *message = [[NSString alloc] initWithFormat:@"%@",[self NSString2Json:1]];
    [self sendSearchBroadcast:message tag:1];
}

-(void)sendSearchBroadcast:(NSString*) msg tag:(long)tag{
    [self sendToUDPServer:msg address:wanip port:UDP_PORT tag:tag];
}

-(void)sendToUDPServer:(NSString*) msg address:(NSString*)address port:(int)port tag:(long)tag{
    AsyncUdpSocket *udpSocket = [[AsyncUdpSocket alloc]init];
    udpSocket=[[AsyncUdpSocket alloc]initWithDelegate:self];
    //clientSocket = [[AsyncUdpSocket alloc]initWithDelegate:self];
    NSLog(@"address:%@,port:%d,msg:%@",address,port,msg);
    //receiveWithTimeout is necessary or you won't receive anything
    [udpSocket receiveWithTimeout:10 tag:tag]; //设置超时10秒
    [udpSocket enableBroadcast:YES error:nil]; //如果你发送广播，这里必须先
    NSData *data=[msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:address port:port withTimeout:10 tag:tag];//发送udp
    [HUD hide:YES];
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

@end
