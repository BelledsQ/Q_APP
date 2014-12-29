//
//  LightTableViewController.m
//  Belled
//
//  Created by Bellnet on 14-4-18.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "LightTableViewController.h"

@interface LightTableViewController ()

@end


@implementation LightTableViewController

@synthesize  datasource,lightTableView,deviceip,typeCtrl,typeCtrl2,syncCtrl;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"Light List"];
    
    //self.navigationItem.backBarButtonItem.title =[NSString stringWithFormat:@"Return"];
    lightTableView.delegate = self;
    lightTableView.dataSource = self;

    res_dictionary = [[NSMutableDictionary alloc] init];
    [self dataList];
    
    datasource = [[NSMutableArray alloc] init];
    
    if([typeCtrl isEqualToString:@"in"]){
        [self.navigationController setNavigationBarHidden:NO animated:TRUE];
        
        if([typeCtrl2 isEqualToString:@"in2"]){
            UIBarButtonItem *cButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(doClickedBack2)];
            
            self.navigationItem.leftBarButtonItem = cButton;
        }
        
        /*UIBarButtonItem *rButton = [[UIBarButtonItem alloc] initWithTitle:@"Group"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(doClickedBack3)];
        
        self.navigationItem.rightBarButtonItem = rButton;*/
        datasource = [res_dictionary objectForKey:@"led"];
    }else{
        datasource = [res_dictionary objectForKey:@"data"];
        UIImage* img1=[UIImage imageNamed:@"set.png"];
        UIBarButtonItem *cButton = [[UIBarButtonItem alloc] //initWithTitle:@"Back"
                                    initWithImage:img1
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(doClickedBack)];
        
        self.navigationItem.leftBarButtonItem = cButton;
    }
    
    UILongPressGestureRecognizer *longPrees = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tableviewCellLongPressed:)];
    longPrees.delegate = self;
    longPrees.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:longPrees];
    
    [self setupRefresh];

}

-(void) doClickedBack3
{
    SceneTableViewController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"sceneListview"];
    tmpEdit.scenetype = @"group";
    tmpEdit.wanip = deviceip;
    [self.navigationController pushViewController:tmpEdit animated:YES];
}

-(void) doClickedBack2
{
    [self.navigationController setNavigationBarHidden:YES animated:TRUE];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) doClickedBack
{
    SetTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"setTableView"];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    //NSLog(@"rows : %d",[data count]);
    return [datasource count];
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSInteger row = [indexPath row];
    //static NSString *MyIdentifier = @"reuseIdentifier";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"CMainCell";
    LightTableViewCell *cell = (LightTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[LightTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //---------- CELL BACKGROUND IMAGE -----------------------------
    //UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    //UIImage *image = [UIImage imageNamed:@"LightGrey@2x.png"];
    //imageView.image = image;
    //cell.backgroundView = imageView;
    //[[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    //[[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
    
    NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
    
    datarow = [datasource objectAtIndex:indexPath.row];
    
    cell.model.text = [datarow objectForKey:@"sn"];
    
    if([typeCtrl isEqualToString:@"in"]){
        cell.wanip = [deviceip copy];
        cell.typeCtrl = [typeCtrl copy];
    }
    
    if([syncCtrl isEqualToString:@"sync"]){
        cell.sn.text = [datarow objectForKey:@"title"];
        cell.model.text = [datarow objectForKey:@"sn"];
        cell.syncCtrl = syncCtrl;
        cell.iswitch_value = [datarow objectForKey:@"music_sync"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.model.text = [datarow objectForKey:@"sn"];
        cell.iswitch_value = [datarow objectForKey:@"iswitch"];
        cell.sn.text = [datarow objectForKey:@"title"];
        cell.red = [datarow objectForKey:@"r"];
        cell.green = [datarow objectForKey:@"g"];
        cell.blue = [datarow objectForKey:@"b"];
        cell.bright = [datarow objectForKey:@"bright"];
        cell.effect = [datarow objectForKey:@"effect"];
        cell.devicesn = [datarow objectForKey:@"devicesn"];
        cell.bright = [datarow objectForKey:@"bright"];
        //Arrow
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // Configure the cell...
    return cell;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([syncCtrl isEqualToString:@"sync"]){

    }else{
    
    static NSString *detailIdentifier = @"lightdetail";
    
    LightConViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:detailIdentifier];

    NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
    datarow = [datasource objectAtIndex:indexPath.row];
    
    detail.sn = [datarow objectForKey:@"sn"];
    detail.model = [datarow objectForKey:@"model"];
   
    if([typeCtrl isEqualToString:@"in"]){
        detail.wanip = [deviceip copy];
    }else{
        detail.wanip = [datarow objectForKey:@"wanip"];
    }
    
    detail.contrlType = @"2";
     //NSLog(@"%@,%@",detail.sn,detail.contrlType);
    [self.navigationController pushViewController:detail animated:YES];
    }
    
}

//长按cell
#pragma mark - 长按录音

-(void)tableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        CGPoint ponit=[gestureRecognizer locationInView:self.tableView];
        NSLog(@" CGPoint ponit=%f %f",ponit.x,ponit.y);
        NSIndexPath* path=[self.tableView indexPathForRowAtPoint:ponit];
        NSLog(@"row:%d",path.row);
        NSInteger currRow = path.row;
        NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
        datarow = [datasource objectAtIndex:currRow];
        NSLog(@"datarow:%@",datarow);
        
        static NSString *detailIdentifier = @"lightTitleView";
        LightTitleViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:detailIdentifier];
        detail.lightID = [datarow objectForKey:@"id"];
        detail.soldtitle = [datarow objectForKey:@"title"];
        detail.ssn = [datarow objectForKey:@"sn"];
        [self.navigationController pushViewController:detail animated:YES];
    }else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        //未用
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        //未用
    }
    
    
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    //_reloading = YES;
    //[self performSelector:@selector(refreshButtonPressd)];
	
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	//_reloading = NO;
    
    //[self.facebookNewsFeedTableView reloadData];
	//[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:lightTableView];
	
}
-(void)dataList
{
    NSLog(@"typeCtrl---%@",typeCtrl);
    if([typeCtrl isEqualToString:@"in"]){
        [self lightList_local];
    }else{
        [self lightList];
    }
}

-(void)lightList
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"username_id"]];
    NSString *token = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"accesstoken"]];
    
    //NSLog(@"username : %@",_username.text);
    NSString *cmd = [NSString stringWithFormat:@"light_list"];
    
    //封装mutableDictionary
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uid,@"username_id",token,@"accesstoken",@"99",@"counts",nil];
    
    //mutableDictionary转NSString
    NSString *postdata = [[[SBJsonWriter alloc] init] stringWithObject:userInfo];
    
    //NSLog(@"封装mutableDictionary:%@",postdata);
    
    NSString *resdata = [NetWorkHttp httpGet:cmd Postdata:postdata];
    
    res_dictionary = [NetWorkHttp httpjsonParser:resdata];
    
    NSLog(@"res_dictionary :%@",res_dictionary);
}

-(void)lightList_local
{
    
    [self sendSearchBroadcast:@"{\"cmd\":\"light_list\"}" tag:1];

}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [lightTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    //warning 自动刷新(一进入程序就下拉刷新)
    //[self.tableView headerBeginRefreshing];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加假数据
    res_dictionary = [[NSMutableDictionary alloc] init];
    [self dataList];
    
    datasource = [[NSMutableArray alloc] init];
    
    if([typeCtrl isEqualToString:@"in"]){
        datasource = [res_dictionary objectForKey:@"led"];
    }else{
        datasource = [res_dictionary objectForKey:@"data"];
    }
    
    // 刷新表格
    lightTableView.delegate = self;
    lightTableView.dataSource = self;
    [lightTableView reloadData];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [lightTableView headerEndRefreshing];
    });
}

-(void)sendSearchBroadcast:(NSString*) msg tag:(long)tag{
    //NSString* bchost = @"192.168.3.83"; //这里发送广播
    //int BCPORT = 11600;
    [self sendToUDPServer:msg address:deviceip port:UDP_PORT tag:tag];
}

-(void)sendToUDPServer:(NSString*) msg address:(NSString*)address port:(int)port tag:(long)tag{
    AsyncUdpSocket *udpSocket=[[AsyncUdpSocket alloc]initWithDelegate:self]; //得到udp util
    NSLog(@"address:%@,port:%d,msg:%@",address,port,msg);
    //receiveWithTimeout is necessary or you won't receive anything
    [udpSocket receiveWithTimeout:10 tag:2]; //设置超时10秒
    [udpSocket enableBroadcast:YES error:nil]; //如果你发送广播，这里必须先enableBroadcast
    NSData *data=[msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:address port:port withTimeout:10 tag:tag]; //发送udp
}

//下面是发送的相关回调函数
-(BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    NSString* rData= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    res_dictionary = [NetWorkHttp httpjsonParser:rData];
    //NSLog(@"数组－－%@",res_dictionary);
    datasource = [[NSMutableArray alloc] init];
    
    if([typeCtrl isEqualToString:@"in"]){
        datasource = [res_dictionary objectForKey:@"led"];
    }else{
        datasource = [res_dictionary objectForKey:@"data"];
    }
    // 刷新表格
    lightTableView.delegate = self;
    lightTableView.dataSource = self;
    [lightTableView reloadData];
    NSLog(@"onUdpSocket:didReceiveData:---%@",rData);
    return YES;
}
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"didNotSendDataWithTag----%ld---%@",tag,error);
}
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"didNotReceiveDataWithTag----%ld---%@",tag,error);
}
-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    NSLog(@"didSendDataWithTag----%ld",tag);
}
-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    NSLog(@"onUdpSocketDidClose----");
}
@end
