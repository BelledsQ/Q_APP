//
//  DetailSCViewController.m
//  Belled
//
//  Created by Bellnet on 14-6-3.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "DetailSCViewController.h"

@interface DetailSCViewController ()

@end

@implementation DetailSCViewController
{
    AVAudioPlayer           *player;
    NSMutableDictionary     *res;
    AudioStreamer           *streamer;
    
}
static int PlayAndPause=1;

@synthesize  snlab,idlab;
@synthesize  snstr,idstr,token,playbtn;

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
    snlab.text = snstr;
    idlab.text = idstr;
    [self api_track];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//播放
-(IBAction) play
{
    
    if(PlayAndPause==1){
        PlayAndPause=0;
        
        [playbtn setTitle:@"Pause" forState:UIControlStateNormal];
        
        NSString *Path = [NSString stringWithFormat:@"%@", [res objectForKey:@"stream_url"]];
        NSString *wavPath = [[NSString alloc ]initWithFormat:@"%@.json?oauth_token=%@",Path,token];
        NSLog(@"stream_url----%@",wavPath);
        
        if (!streamer) {
            //streamer = [[AudioStreamer alloc]init];
            [self createStreamer:wavPath];
        }
        [streamer start];

    /*NSError *error =nil;
    //初始化播放器
    player = [[AVAudioPlayer alloc]init];

    NSString *Path = [NSString stringWithFormat:@"%@", [res objectForKey:@"stream_url"]];
    NSString *wavPath = [NSString stringWithFormat:@"%@.json?oauth_token=%@",Path,token];
    NSURL *url = [[NSURL alloc]initWithString:wavPath];
    NSData * audioData = [NSData dataWithContentsOfURL:url];
    
    //将数据保存到本地指定位置
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath , @"temp"];
    [audioData writeToFile:filePath atomically:YES];
    
    //player = [player initWithContentsOfURL:[NSURL URLWithString:wavPath] error:&error];
    player = [player initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&error];
    if (error)
    {
        NSLog(@"%@",[error localizedDescription]);
    }
    NSLog(@"stream_url : %@",wavPath);
    [player prepareToPlay];
    [player play];*/
        
    }else{
        //[player pause];
        [playbtn setTitle:@"Play" forState:UIControlStateNormal];
        [streamer pause];
         PlayAndPause =1;
    }
}


- (void)createStreamer:(NSString *)wavPath
{
	[self destroyStreamer];
    
	//NSString *escapedValue = ( NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( nil,(CFStringRef)wavPath,NULL,NULL,kCFStringEncodingUTF8));
	NSURL *url = [NSURL URLWithString:wavPath];
	streamer = [[AudioStreamer alloc] initWithURL:url];

}

- (void)destroyStreamer
{
	if (streamer)
	{
		[[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:ASStatusChangedNotification
         object:streamer];
		
		[streamer stop];
		streamer = nil;
	}
}

-(void)api_track
{
    NSLog(@"sclist");
    
    if(token==nil){
        
        [Tools showMsg:@"Error" message:@"token is null"];
        
    }else{
        
        NSString *cmd = [NSString stringWithFormat:@"https://api.soundcloud.com/tracks/%@.json?oauth_token=%@",idstr,token];
        
        NSString *resdata = [NetWorkHttp httpGet_SC:cmd];
        
        //NSLog(@"resdata:%@",resdata);
        
        //[HUD hide:YES];
        
        res = [[NSMutableDictionary alloc] init];
        
        res = [NetWorkHttp httpjsonParser:resdata];
        
    }
    
}
@end
