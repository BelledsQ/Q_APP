//
//  IndexViewController.m
//  Belled
//
//  Created by Bellnet on 14-7-29.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "IndexViewController.h"

@interface IndexViewController ()

@end

@implementation IndexViewController
{
    NSMutableArray *datasource;
    AsyncUdpSocket *clientSocket;
    AsyncUdpSocket *udpSocket;
    GlobalSet *gt;
    NSTimer *timer;
    NSString *devsn;
    NSString *devip;
}
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
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    devsn = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"dev_sn"]];
    devip = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"dev_ip"]];
    [clientSocket close];
    self.navigationItem.title = [NSString stringWithFormat:@"Welcome"];
    datasource = [[NSMutableArray alloc] init];
    [self openUDPServer];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(sendUDP) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)wifiBtn
{
    //要从此类界面转换到HomeViewController类的界面,storyboard
    [timer invalidate];
    [udpSocket close];
    [clientSocket close];
    WebViewViewController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"set_webView"];
    
    [self.navigationController pushViewController:tmpEdit animated:YES];
    //实现页面的切换
    //[self presentModalViewController:tmpEdit animated:YES];
}

-(IBAction)playBtn
{
    [timer invalidate];
    [udpSocket close];
    [clientSocket close];
    
    LocalListTableViewController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"locallist"];
    tmpEdit.typeCtrl = @"index";
    [self.navigationController pushViewController:tmpEdit animated:YES];
}

-(IBAction)ledBtn
{
    [timer invalidate];
    [udpSocket close];
    [clientSocket close];
    
    if([devsn isEqualToString:@""]||[devsn isEqualToString:@"(null)"]){
        //要从此类界面转换到HomeViewController类的界面,storyboard
        ScanViewController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"scanView"];
        tmpEdit.typeCtrl = @"scan";
        [self.navigationController pushViewController:tmpEdit animated:YES];
    }else{
        //[self changeLightView];
        [self changeGroupView];
    }
}

-(IBAction)pageChange
{
    //要从此类界面转换到HomeViewController类的界面,storyboard
    [timer invalidate];
    [udpSocket close];
    [clientSocket close];
    LoginViewController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
 
    [self.navigationController pushViewController:tmpEdit animated:YES];
    //实现页面的切换
    //[self presentModalViewController:tmpEdit animated:YES];
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
-(void)openUDPServer
{
    //初始化udp
	clientSocket=[[AsyncUdpSocket alloc] initWithDelegate:self];
	
	//绑定端口
	NSError *error = nil;
	[clientSocket bindToPort:BRO_PORT error:&error];
    
    //发送广播设置
    [clientSocket enableBroadcast:YES error:&error];
    
    //加入群里，能接收到群里其他客户端的消息
    [clientSocket joinMulticastGroup:BRO_IP error:&error];
    
   	//启动接收线程
	[clientSocket receiveWithTimeout:-1 tag:0];
}

-(NSArray *)jiexiData:(NSString *)str
{
    NSCharacterSet *characterSet1 = [NSCharacterSet characterSetWithCharactersInString:@","];
    NSArray *array1 = [str componentsSeparatedByCharactersInSet:characterSet1];
    return array1;
}

-(void)comperData:(NSString *)str
{
    NSArray *array1 = [self jiexiData:str];
    NSString *cmd = [[NSString alloc] init];
    cmd = [array1 objectAtIndex:0];
    
    NSString *sn = [[NSString alloc] init];
    sn = [array1 objectAtIndex:1];
    
    NSString *ip = [[NSString alloc] init];
    ip = [array1 objectAtIndex:2];
    
     NSString *iswitch = [[NSString alloc] init];
    if([array1 count] > 3){
        iswitch = [array1 objectAtIndex:3];
    }else{
        iswitch = @"1";
    }
    
    if([cmd isEqualToString:@"belled"]){
        
        NSMutableDictionary *device = [[NSMutableDictionary alloc] init];
        device = [[NSMutableDictionary alloc] initWithObjectsAndKeys:sn,@"sn",ip,@"ip",iswitch,@"iswitch",nil];
        
        if([self findStrForArray:sn]){
            if([datasource count]==0){
                [datasource addObject:device];
            }else{
                NSInteger row = [self indexForArray:sn];
                NSMutableDictionary *deviceitem = [[NSMutableDictionary alloc] init];
                deviceitem = [[NSMutableDictionary alloc] initWithObjectsAndKeys:sn,@"sn",ip,@"ip",iswitch,@"iswitch",nil];
                //NSLog(@"%d  %@",row,deviceitem);
                [datasource replaceObjectAtIndex:row withObject:deviceitem];
            }
        }else{
            [datasource addObject:device];
            
        }
        
        [self reRoadTableView];
        
    }
    
}


- (BOOL)findStrForArray:(NSString *)theName
{
    bool is;
    int m = [datasource count];
    for(int i=0;i<m;i++ ){
        NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
        datarow = [datasource objectAtIndex:i];
        NSString *sn = [[NSString alloc]init];
        sn = [NSString stringWithFormat:@"%@",[datarow objectForKey:@"sn"]];
        if([sn isEqualToString:theName])
        {
            is = YES;
            break;
        }else{
            is = NO;
        }
        
    }
    
    return is;
}

- (NSInteger)indexForArray:(NSString *)theName
{
    NSInteger is = 0;
    int m = [datasource count];
    for(int i=0;i < m;i++ ){
        NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
        datarow = [datasource objectAtIndex:i];
        NSString *sn = [[NSString alloc]init];
        sn = [NSString stringWithFormat:@"%@",[datarow objectForKey:@"sn"]];
        if([sn isEqualToString:theName])
        {
            is = i;
            break;
        }
        
    }
    
    return is;
}

- (void) reRoadTableView
{
    gt = [GlobalSet bellSetting];
    gt.devices = [datasource copy];
}

-(void)sendUDP
{
    [self sendSearchBroadcast:@"{\"cmd\":\"ping\"}" tag:1];
}

-(void)changeLightView{
    static NSString *detailIdentifier = @"lightTableList";
    LightTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:detailIdentifier];
    detail.deviceip = devip;
    detail.typeCtrl = @"in";
    detail.typeCtrl2 = @"in2";
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)changeGroupView{
    SceneTableViewController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"sceneListview"];
    tmpEdit.scenetype = @"group";
    tmpEdit.wanip = devip;
    tmpEdit.groupone = @"one";
    [self.navigationController pushViewController:tmpEdit animated:YES];
}

-(void)sendSearchBroadcast:(NSString*) msg tag:(long)tag{
    [self sendToUDPServer:msg address:WAN_IP port:UDP_PORT tag:tag];
}

-(void)sendToUDPServer:(NSString*) msg address:(NSString*)address port:(int)port tag:(long)tag{
    
    udpSocket=[[AsyncUdpSocket alloc]initWithDelegate:self];
    //clientSocket = [[AsyncUdpSocket alloc]initWithDelegate:self];
    NSLog(@"address:%@,port:%d,msg:%@",address,port,msg);
    //receiveWithTimeout is necessary or you won't receive anything
    [udpSocket receiveWithTimeout:10 tag:tag]; //设置超时10秒
    [udpSocket enableBroadcast:YES error:nil]; //如果你发送广播，这里必须先
    NSData *data=[msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:address port:port withTimeout:10 tag:tag];//发送udp
}
-(BOOL) onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSString * info=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self comperData:info];
    NSLog(@"组播消息---%@",info);
    NSLog(@"更新消息---%@",datasource);
    [clientSocket receiveWithTimeout:-1 tag:0];
    return YES;
}
@end
