//
//  LightTableViewController.m
//  Belled
//
//  Created by Bellnet on 14-4-18.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "SceneTableViewController.h"

@interface SceneTableViewController ()

@end


@implementation SceneTableViewController

@synthesize  scenetype,wanip,lightTableView,groupone;


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
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view insertSubview:HUD atIndex:0];
    if([scenetype isEqualToString:@"group"]){
        [self.navigationController setNavigationBarHidden:NO animated:TRUE];
        self.navigationItem.title = [NSString stringWithFormat:@"Group List"];
        
        if([groupone isEqualToString:@"one"]){
        UIBarButtonItem *cButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(doClickedBack2)];
        
        self.navigationItem.leftBarButtonItem = cButton;
        }
        
    }else{
    self.navigationItem.title = [NSString stringWithFormat:@"Scene List"];
    }
    UIBarButtonItem *rButton = [[UIBarButtonItem alloc] initWithTitle:@"ADD"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(doClicked1)];
    
    self.navigationItem.rightBarButtonItem = rButton;
    
    res_dictionary = [[NSMutableDictionary alloc] init];
    if([scenetype isEqualToString:@"group"]){
        [self dataList_udp];
    }else{
        [self dataList];
        datasource = [res_dictionary objectForKey:@"data"];
    }
    
    UILongPressGestureRecognizer *longPrees = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tableviewCellLongPressed:)];
    longPrees.delegate = self;
    longPrees.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:longPrees];
    
    [self setupRefresh];
}

-(void) doClickedBack2
{
    [self.navigationController setNavigationBarHidden:YES animated:TRUE];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doClicked1
{
    static NSString *detailIdentifier = @"addsceneview";
    ADDSceneViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:detailIdentifier];
    detail.scenetype = @"group";
    detail.wanip = wanip;
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
    
    static NSString *CellIdentifier = @"SceneMainCell";
    SceneTableViewCell *cell = (SceneTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SceneTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //---------- CELL BACKGROUND IMAGE -----------------------------
    //UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    //UIImage *image = [UIImage imageNamed:@"LightGrey@2x.png"];
    //imageView.image = image;
    //cell.backgroundView = imageView;
    //[[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    //[[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
    
    NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
    
    //NSString *rows = [NSString stringWithFormat:@"%d",indexPath.row];
    
    //NSLog(@"rows : %@",rows);
    
    datarow = [datasource objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = [datarow objectForKey:@"sn"];
    
    if([scenetype isEqualToString:@"group"]){
        cell.sn.text = [datarow objectForKey:@"group_title"];
        cell.model.text = [datarow objectForKey:@"description"];
        cell.iswitch_value = [datarow objectForKey:@"iswitch"];
    }else{
        cell.sn.text = [datarow objectForKey:@"name"];
        cell.model.text = [datarow objectForKey:@"description"];
        cell.iswitch_value = [datarow objectForKey:@"iswitch"];
        cell.effect = [datarow objectForKey:@"effect"];
        cell.light_List = [datarow objectForKey:@"light_List"];
        cell.url = [datarow objectForKey:@"url"];
    }
    //Arrow
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    return cell;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([scenetype isEqualToString:@"group"]){
        static NSString *detailIdentifier = @"lightdetail";
        
        LightConViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:detailIdentifier];
        
        NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
        datarow = [datasource objectAtIndex:indexPath.row];
        
        detail.sn = [datarow objectForKey:@"group_title"];
        detail.wanip = wanip;
        detail.groupid = [datarow objectForKey:@"group_id"];
        detail.contrlType = @"2";
        detail.scenetype = @"group";
        //NSLog(@"%@,%@",detail.sn,detail.contrlType);
        [self.navigationController pushViewController:detail animated:YES];
        
    }else{
        
        static NSString *detailIdentifier = @"lightViewList";
        LightSceneTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:detailIdentifier];
        NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
        datarow = [datasource objectAtIndex:indexPath.row];
        detail.groupid = [datarow objectForKey:@"id"];
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
        
        static NSString *detailIdentifier = @"modsceneview";
        MODSceneViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:detailIdentifier];
         if([scenetype isEqualToString:@"group"]){
             detail.sceneID = [datarow objectForKey:@"group_id"];
             detail.soldtit = [datarow objectForKey:@"group_title"];
             detail.solddes = [datarow objectForKey:@"description"];
             detail.scenetype = @"group";
             detail.wanip = wanip;
         }else{
             detail.sceneID = [datarow objectForKey:@"id"];
             detail.soldtit = [datarow objectForKey:@"name"];
             detail.solddes = [datarow objectForKey:@"description"];
         }
        
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

//滑动点击
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    NSUInteger row = [indexPath row];
    NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
    datarow = [datasource objectAtIndex:row];
    if([scenetype isEqualToString:@"group"]){
        aid = [[NSString alloc ]initWithFormat:@"%@",[datarow objectForKey:@"group_id"]];
        [self delgroup_udp];
    }else{
        aid = [[NSString alloc ]initWithFormat:@"%@",[datarow objectForKey:@"id"]];
        [self doSubmit];
    }
    
     NSLog(@"del----------%@",datarow);
    [datasource removeObjectAtIndex:row];//bookInfo为当前table中显示的array
    [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationRight];
}

-(void)doSubmit
{
    //全局变量
    
    gt = [GlobalSet bellSetting];
    [HUD show:YES];
    NSMutableDictionary *rdictionary = [[NSMutableDictionary alloc] init];
    rdictionary = [self httpAlarmdel];
    NSString *res = [rdictionary objectForKey:@"res"];
    
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
    
    NSLog(@"rdictionary :%@",rdictionary);
    
}

-(NSMutableDictionary *)httpAlarmdel
{
    gt = [GlobalSet bellSetting];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"username_id"]];
    NSString *token = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"accesstoken"]];
    
    NSMutableDictionary *rdictionary = [[NSMutableDictionary alloc] init];
    NSString *cmd = [NSString stringWithFormat:@"scene_del"];
    NSMutableArray *sceneidArr = [NSMutableArray arrayWithObjects:
                                  [NSMutableDictionary dictionaryWithObjectsAndKeys:aid,@"id", nil],
                                  nil];
    
    //封装mutableDictionary
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uid,@"username_id",token,@"accesstoken",sceneidArr,@"sceneid",nil];
    //mutableDictionary转NSString
    NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:postdata];
    NSString *resdata = [NetWorkHttp httpGet:cmd Postdata:data];
    //NSLog(@"resdata:%@",resdata);
    if([resdata isEqualToString:@"999"]==false){
        rdictionary = [NetWorkHttp httpjsonParser:resdata];
    }
    return rdictionary;
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
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
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"username_id"]];
    NSString *token = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"accesstoken"]];
    //NSLog(@"username : %@",_username.text);
    NSString *cmd = [NSString stringWithFormat:@"scene_list"];
    //封装mutableDictionary
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uid,@"username_id",token,@"accesstoken",@"10",@"counts",nil];
    //mutableDictionary转NSString
    NSString *postdata = [[[SBJsonWriter alloc] init] stringWithObject:userInfo];
    //NSLog(@"封装mutableDictionary:%@",postdata);
    
    NSString *resdata = [NetWorkHttp httpGet:cmd Postdata:postdata];
    res_dictionary = [NetWorkHttp httpjsonParser:resdata];
    NSLog(@"res_dictionary :%@",res_dictionary);
}
-(NSString *)NSString2Json:(int)value
{
    NSMutableDictionary *cmdctrl = [[NSMutableDictionary alloc] init];
    
    switch (value) {
        case 1:
            //获取组列表
            cmdctrl = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"group_list",@"cmd",@"0",@"page",@"0",@"counts",nil];
            break;
        case 2:
            //获取组列表
            cmdctrl = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"del_group",@"cmd",aid,@"group_id",nil];
            break;

    }
    
    NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:cmdctrl];
    return data;
    
}
-(void)delgroup_udp
{
    NSString *message = [[NSString alloc] initWithFormat:@"%@",[self NSString2Json:2]];
    [self sendSearchBroadcast:message tag:1];
}

-(void)dataList_udp
{
    [HUD show:YES];
    NSString *message = [[NSString alloc] initWithFormat:@"%@",[self NSString2Json:1]];
    [self sendSearchBroadcast:message tag:1];
}

-(void)sendSearchBroadcast:(NSString*) msg tag:(long)tag{
    [self sendToUDPServer:msg address:wanip port:UDP_PORT tag:tag];
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

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    //warning 自动刷新(一进入程序就下拉刷新)
    //[self.tableView headerBeginRefreshing];
    
}



#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加假数据
    res_dictionary = [[NSMutableDictionary alloc] init];
    if([scenetype isEqualToString:@"group"]){
        [self dataList_udp];
    }else{
        [self dataList];
        datasource = [[NSMutableArray alloc] init];
        datasource = [res_dictionary objectForKey:@"data"];
    }

    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}


-(BOOL) onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSString* rData= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    res_dictionary = [NetWorkHttp httpjsonParser:rData];
    datasource = [[NSMutableArray alloc] init];
    datasource = [res_dictionary objectForKey:@"data"];
    NSLog(@"数组---%@",res_dictionary);
    NSLog(@"组播消息---%@",rData);
    [self.tableView reloadData];
    [HUD hide:YES];
    return YES;
}
@end
