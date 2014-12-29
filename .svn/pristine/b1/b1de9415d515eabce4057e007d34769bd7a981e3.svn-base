//
//  ScanViewController.m
//  Belled
//
//  Created by Bellnet on 14-6-26.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()

@end

@implementation ScanViewController
{
    NSMutableArray *datasource;
    AsyncUdpSocket *clientSocket;
    AsyncUdpSocket *udpSocket;
    NSTimer *timer;
    NSString *devsn;
    NSString *devip;
    
}

@synthesize  scantableView,datasource,typeCtrl;

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
    /*[[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(openUDPServer)
                                                name:@"openUDPServer"//消息名
                                              object:nil];//注意是nil*/
    self.navigationItem.title = [NSString stringWithFormat:@"Scan GateWay"];
    
    [self openUDPServer];
    datasource = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    
    scantableView.delegate = self;
    scantableView.dataSource = self;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(sendUDP) userInfo:nil repeats:YES];
    
    if([typeCtrl isEqualToString:@"scan"]){
        [self.navigationController setNavigationBarHidden:NO animated:TRUE];
        UIBarButtonItem *cButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(doClickedBack)];
        
        self.navigationItem.leftBarButtonItem = cButton;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        devsn = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"dev_sn"]];
        //devip = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"dev_ip"]];
        NSLog(@"devsn %@",devsn);
        /*if([devsn isEqualToString:@""]||[devsn isEqualToString:@"(null)"]){
            
        }else{
            [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scanDevView) userInfo:nil repeats:NO];
        }*/
    }else{
        
        UIBarButtonItem *bButton = [[UIBarButtonItem alloc] initWithTitle:@"Home"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(doClickedBack2)];
        
        self.navigationItem.leftBarButtonItem = bButton;
    }
    //[self sendUDP];
}

-(void)scanDevView{
    
    if([self findStrForArray:devsn]){
        [self changeLightView];
    }else{
        [self cleanDevsn];
    }
}

-(void)cleanDevsn{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"" forKey:@"dev_sn"];
}

-(void)changeLightView{
    static NSString *detailIdentifier = @"lightTableList";
    LightTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:detailIdentifier];
    
    detail.deviceip = devip;
    detail.typeCtrl = @"in";
    
    [timer invalidate];
    [udpSocket close];
    [clientSocket close];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) doClickedBack2
{
    [timer invalidate];
    [udpSocket close];
    [clientSocket close];
    [self.navigationController setNavigationBarHidden:YES animated:TRUE];
    UINavigationController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"indexView"];
    [self presentModalViewController:tmpEdit animated:YES];
}

-(void) doClickedBack
{
    [timer invalidate];
    [udpSocket close];
    [clientSocket close];
    if([typeCtrl isEqualToString:@"scan"]){
        [self.navigationController setNavigationBarHidden:YES animated:TRUE];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

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
        NSString *ip = [[NSString alloc]init];
        sn = [NSString stringWithFormat:@"%@",[datarow objectForKey:@"sn"]];
        ip = [NSString stringWithFormat:@"%@",[datarow objectForKey:@"ip"]];
        if([sn isEqualToString:theName])
        {
           devip = [ip copy];
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
    scantableView.delegate = self;
    scantableView.dataSource = self;
    GlobalSet *gt = [GlobalSet bellSetting];
    gt.devices = datasource;
    [self.scantableView reloadData];
}
//实现界面的切换  并把值传递过去
-(IBAction)pageChange
{

    [clientSocket close];
    //要从此类界面转换到HomeViewController类的界面,storyboard
    LoginViewController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    
    //设置翻页效果
    tmpEdit.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
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

//Delegate tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [datasource count];
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"ScanCell";
    ScanTableViewCell *cell = (ScanTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ScanTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
    
    datarow = [datasource objectAtIndex:indexPath.row];
    
    cell.sn.text = [datarow objectForKey:@"sn"];
    cell.ip.text = [datarow objectForKey:@"ip"];
    cell.iswitch_value = [datarow objectForKey:@"iswitch"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    return cell;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *detailIdentifier = @"lightTableList";
    LightTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:detailIdentifier];
    NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
    datarow = [datasource objectAtIndex:indexPath.row];
    detail.deviceip = [datarow objectForKey:@"ip"];
    detail.typeCtrl = @"in";
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[datarow objectForKey:@"sn"] forKey:@"dev_sn"];
    [ud setObject:[datarow objectForKey:@"ip"] forKey:@"dev_ip"];
    
    [timer invalidate];
    [udpSocket close];
    [clientSocket close];
    [self.navigationController pushViewController:detail animated:YES];
}

-(BOOL) onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSString * info=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self comperData:info];
    NSLog(@"组播消息---%@",info);
    [clientSocket receiveWithTimeout:-1 tag:0];
    return YES;
}
-(void)sendUDP
{
    [self sendSearchBroadcast:@"{\"cmd\":\"ping\"}" tag:1];
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
@end
