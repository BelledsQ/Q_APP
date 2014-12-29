//
//  LightTableViewController.m
//  Belled
//
//  Created by Bellnet on 14-4-18.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "AlarmTableViewController.h"

@interface AlarmTableViewController ()

@end


@implementation AlarmTableViewController
{
    NSMutableDictionary *res_dictionary;
    NSMutableArray *datasource;
    NSInteger pageNum;
	NSInteger CountNum;
    GlobalSet *gt;
    MBProgressHUD *HUD;
    NSString *aid;
}
@synthesize  datasource,alarmtableView;


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
    self.navigationItem.title = [NSString stringWithFormat:@"Alarm List"];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    //self.navigationItem.backBarButtonItem.title =[NSString stringWithFormat:@"Return"];


    res_dictionary = [[NSMutableDictionary alloc] init];
    res_dictionary = [self dataList];
    
    datasource = [[NSMutableArray alloc] init];
    datasource = [res_dictionary objectForKey:@"data"];
    
    
    UIBarButtonItem *cButton = [[UIBarButtonItem alloc] initWithTitle:@"ADD"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(doClickedAdd)];
    self.navigationItem.rightBarButtonItem = cButton;
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(reRoadTableView)
                                                name:@"reRoadTableViewAlarmid"//消息名
                                              object:nil];//注意是nil
    
    [self setupRefresh];
    
    NSLog(@"datasource : %@",datasource);
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UILongPressGestureRecognizer *longPrees = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(tableviewCellLongPressed:)];
    
    longPrees.delegate = self;
    longPrees.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:longPrees];
}

-(void)doClickedAdd
{
    ADDAlarmViewController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"addAlarm"];
    
    [self.navigationController pushViewController:tmpEdit animated:YES];
    NSLog(@"doClickedAdd");
    
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
    
    static NSString *CellIdentifier = @"AlarmMainCell";
    AlarmTableViewCell *cell = (AlarmTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AlarmTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
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
    
    cell.sn.text = [datarow objectForKey:@"actiontime"];
    cell.model.text = [datarow objectForKey:@"title"];
    cell.events = [datarow objectForKey:@"events"];
    cell.iswitch_value = [datarow objectForKey:@"iswitch"];
    cell.actiontime = [datarow objectForKey:@"actiontime"];
    cell.control = [datarow objectForKey:@"control"];
    cell.weeks = [datarow objectForKey:@"weeks"];
    //Arrow
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    return cell;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AlarmTypeTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"alarmTypeView"];
    
    NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
    datarow = [datasource objectAtIndex:indexPath.row];
    
    detail.alarmid = [datarow objectForKey:@"id"];
    
    [self.navigationController pushViewController:detail animated:YES];
    
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
        
        static NSString *detailIdentifier = @"editAlarm";
        EditAlarmViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:detailIdentifier];
        detail.aid = [datarow objectForKey:@"id"];
        detail.atitle = [datarow objectForKey:@"title"];
        detail.aactiontime = [datarow objectForKey:@"actiontime"];
        detail.acontrol = [datarow objectForKey:@"control"];
        detail.aweeks = [datarow objectForKey:@"weeks"];
        detail.atimezone = [datarow objectForKey:@"timezone"];
        
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
    aid = [[NSString alloc ]initWithFormat:@"%@",[datarow objectForKey:@"id"]];
    NSLog(@"del----------%@",datarow);
    [self doSubmit];
    [datasource removeObjectAtIndex:row];//bookInfo为当前table中显示的array
    [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationRight];
}

- (void) reRoadTableView
{
    res_dictionary = [[NSMutableDictionary alloc] init];
    res_dictionary = [self dataList];
    
    datasource = [[NSMutableArray alloc] init];
    datasource = [res_dictionary objectForKey:@"data"];
    alarmtableView.delegate = self;
    alarmtableView.dataSource = self;
    [alarmtableView reloadData];
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

-(NSMutableDictionary *)dataList
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"username_id"]];
    NSString *token = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"accesstoken"]];
    
    //NSLog(@"username : %@",_username.text);
    NSString *cmd = [NSString stringWithFormat:@"alarm_list"];
    
    //封装mutableDictionary
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uid,@"username_id",token,@"accesstoken",@"99",@"counts",nil];
    
    //mutableDictionary转NSString
    NSString *postdata = [[[SBJsonWriter alloc] init] stringWithObject:userInfo];
    
    //NSLog(@"封装mutableDictionary:%@",postdata);
    
    NSString *resdata = [NetWorkHttp httpGet:cmd Postdata:postdata];
    
    res_dictionary = [NetWorkHttp httpjsonParser:resdata];
    
    NSLog(@"res_dictionary :%@",res_dictionary);
    return res_dictionary;
}

-(void)doSubmit
{
    //全局变量
    
    gt = [GlobalSet bellSetting];
    [HUD show:YES];
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    res_dictionary = [self httpAlarmdel];
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

-(NSMutableDictionary *)httpAlarmdel
{
    gt = [GlobalSet bellSetting];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"username_id"]];
    NSString *token = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"accesstoken"]];
    
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    NSString *cmd = [NSString stringWithFormat:@"alarm_del"];
    NSMutableArray *alarmidArr = [NSMutableArray arrayWithObjects:
                            [NSMutableDictionary dictionaryWithObjectsAndKeys:aid,@"id", nil],
                            nil];
   
    //封装mutableDictionary
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uid,@"username_id",token,@"accesstoken",alarmidArr,@"alarmid",nil];
    //mutableDictionary转NSString
    NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:postdata];
    NSString *resdata = [NetWorkHttp httpGet:cmd Postdata:data];
    //NSLog(@"resdata:%@",resdata);
    if([resdata isEqualToString:@"999"]==false){
        res_dictionary = [NetWorkHttp httpjsonParser:resdata];
    }
    return res_dictionary;
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [alarmtableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
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
    datasource = [res_dictionary objectForKey:@"data"];
    
    // 刷新表格
    alarmtableView.delegate = self;
    alarmtableView.dataSource = self;
    [alarmtableView reloadData];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [alarmtableView headerEndRefreshing];
    });
}

@end
