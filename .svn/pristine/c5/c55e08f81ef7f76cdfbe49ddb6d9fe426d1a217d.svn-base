//
//  SCBViewController.m
//  Belled
//
//  Created by Bellnet on 14-5-27.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "SCBViewController.h"

@interface SCBViewController ()

@end

@implementation SCBViewController

{
    MBProgressHUD               *HUD;
    NSString                    *token;
    NSMutableDictionary         *me;
}

@synthesize  UItoken,cmdToken;

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
    [UItoken setDelegate:self];
    UItoken.text = cmdToken;
    //HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //[HUD show:YES];
    //[self.view addSubview:HUD];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)gettoken
{
    token = [[NSString alloc] initWithFormat:@"%@",UItoken.text];
    NSLog(@"%@",token);
    [self api_Me];
   
}

-(IBAction)getPlaylists
{
    [self changeSCTableView];
}

-(IBAction)gettracks
{
    [self api_tracks];
}

-(IBAction)connectSC
{
    [self http_connect];
}

-(void)http_connect{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://asiat.avalaa.com/soundcloud/"]];
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

//实现界面的切换  并把值传递过去
-(void)changeSCTableView
{
    //要从此类界面转换到HomeViewController类的界面,storyboard
    UITabBarController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"scTabBar"];
    //- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated;
    
    //打印movie对象里面的值
    //NSLog(@"%@",movie);
    
    //把movie里面的值（name price summary）赋给 EditViewController 类里面的movie对象editMovie
    //tmpEdit.token = token;
    //tmpEdit.me = me;
    
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
    
    //实现页面的切换
    [self presentModalViewController:tmpEdit animated:YES];
}

-(void)api_playlist
{
    NSLog(@"sclist");
   
    if(token==nil){
        
        [Tools showMsg:@"Error" message:@"token is null"];
        
    }else{
        
        NSString *uid = [me objectForKey:@"id"];
        
        NSString *cmd = [NSString stringWithFormat:@"https://api.soundcloud.com/users/%@/playlists.json?oauth_token=%@",uid,token];
    
        NSString *resdata = [NetWorkHttp httpGet_SC:cmd];
    
        //NSLog(@"resdata:%@",resdata);
    
        //[HUD hide:YES];
    
        NSArray *res = [[NSArray alloc] init];
    
        res = [NetWorkHttp arrjsonParser:resdata];
        
        NSLog(@"res_dictionary :%@ %d",res,[res count]);
        
        /*NSArray *playlists = [[NSArray alloc] init];
        
        playlists = [res_dictionary objectForKey:@"playlists"];
        
        NSLog(@"playlists :%@",playlists);*/
        
        //NSMutableDictionary *resplaylist = [[NSMutableDictionary alloc] init];
        
        //resplaylist = [res objectAtIndex:0];

        //NSString *playlist_id = [resplaylist objectForKey:@"id"];
        
        //NSLog(@"playlist_id :%@",playlist_id);
        
    }

}

-(void)api_tracks
{
    NSLog(@"tracks");
    
    if(token==nil){
        
        [Tools showMsg:@"Error" message:@"token is null"];
        
    }else{
    
        NSString *uid = [me objectForKey:@"id"];
        
        NSString *cmd = [NSString stringWithFormat:@"https://api.soundcloud.com/users/%@/tracks?oauth_token=%@",uid,token];
    
        NSString *resdata = [NetWorkHttp httpGet_SC:cmd];
    
        // NSLog(@"resdata:%@",resdata);
    
        //[HUD hide:YES];
    
        NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    
        res_dictionary = [NetWorkHttp httpjsonParser:resdata];
    
        //NSString *res = [res_dictionary objectForKey:@"res"];
    
        NSLog(@"res_dictionary :%@",res_dictionary);
    }
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

@end
