//
//  LightSceneTableViewController.m
//  Belled
//
//  Created by Bellnet on 14-4-18.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "LightAlarmTableViewController.h"

@interface LightAlarmTableViewController ()

@end


@implementation LightAlarmTableViewController
{
    GlobalSet *gt;
    MBProgressHUD *HUD;
    NSString *aid;
}
@synthesize  datasource,effect,lightSceneTableView,bandtype,alarmid;


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


    res_dictionary = [[NSMutableDictionary alloc] init];
    res_dictionary = [self dataList];
    
    datasource = [[NSMutableArray alloc] init];
    datasource = [res_dictionary objectForKey:@"data"];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
     NSLog(@"bandtype ---- %@  ---  %@",bandtype,alarmid);
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
    
    static NSString *CellIdentifier = @"LightAlarmCell";
    LightAlarmTableViewCell *cell = (LightAlarmTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[LightAlarmTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
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
    if([bandtype isEqualToString:@"1"]){
        cell.sn.text = [datarow objectForKey:@"title"];
        cell.model.text = [datarow objectForKey:@"sn"];
    }else{
        cell.sn.text = [datarow objectForKey:@"name"];
        cell.model.text = [datarow objectForKey:@"description"];
    }
    NSString *groupband = [[NSString alloc] initWithFormat:@"%@",[datarow objectForKey:@"alarmband"]];
    UIImage *image = [UIImage alloc];
    if([groupband isEqualToString:@"1"]){
        image = [UIImage imageNamed:@"selon.png"];
        
    }else{
        image = [UIImage imageNamed:@"seloff.png"];
    }
    cell.imagesel.image = image;
    //Arrow
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    return cell;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
    datarow = [datasource objectAtIndex:indexPath.row];
    aid = [[NSString alloc ]initWithFormat:@"%@",[datarow objectForKey:@"id"]];
    NSString *alarmband = [[NSString alloc ]initWithFormat:@"%@",[datarow objectForKey:@"alarmband"]];
    NSLog(@"alarmband -----%@",alarmband);
    if([alarmband isEqualToString:@"0"]){
        [self doSubmit];
        NSLog(@"doSubmit");
    }else{
        [self doSubmitnobangding];
        NSLog(@"doSubmitnobangding");
    }
    [self reRoadTableView];
    
}


-(void)doSubmit
{
    //全局变量
    
    gt = [GlobalSet bellSetting];
    [HUD show:YES];
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    res_dictionary = [self httpBandingScene];
    NSString *res = [res_dictionary objectForKey:@"res"];
    
    if([res isEqualToString:@"200"]){
        //成功
        //[Tools showMsg:@"OK" message:@"SUCCESS!"];
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

-(NSMutableDictionary *)httpBandingScene
{
    gt = [GlobalSet bellSetting];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"username_id"]];
    NSString *token = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"accesstoken"]];
    
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    NSString *cmd = [NSString stringWithFormat:@"event_add"];
    //NSMutableArray *idArr = [[NSMutableArray arrayWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:aid,@"id", nil],nil] retain];
    
    //封装mutableDictionary
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uid,@"username_id",token,@"accesstoken",aid,@"bandid",bandtype,@"bandtype",alarmid,@"alarmid",nil];
    //mutableDictionary转NSString
    NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:postdata];
    NSString *resdata = [NetWorkHttp httpGet:cmd Postdata:data];
    //NSLog(@"resdata:%@",resdata);
    if([resdata isEqualToString:@"999"]==false){
        res_dictionary = [NetWorkHttp httpjsonParser:resdata];
    }
    return res_dictionary;
}


-(void)doSubmitnobangding
{
    //全局变量
    
    gt = [GlobalSet bellSetting];
    [HUD show:YES];
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    res_dictionary = [self httpNoBandingScene];
    NSString *res = [res_dictionary objectForKey:@"res"];
    
    if([res isEqualToString:@"200"]){
        //成功
        //[Tools showMsg:@"OK" message:@"SUCCESS!"];
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

-(NSMutableDictionary *)httpNoBandingScene
{
    gt = [GlobalSet bellSetting];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"username_id"]];
    NSString *token = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"accesstoken"]];
    
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    NSString *cmd = [NSString stringWithFormat:@"event_del"];
    //NSMutableArray *idArr = [[NSMutableArray arrayWithObjects:[NSMutableDictionary dictionaryWithObjectsAndKeys:aid,@"id", nil],nil] retain];
    
    //封装mutableDictionary
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uid,@"username_id",token,@"accesstoken",aid,@"bandid",bandtype,@"bandtype",alarmid,@"alarmid",nil];
    //mutableDictionary转NSString
    NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:postdata];
    NSString *resdata = [NetWorkHttp httpGet:cmd Postdata:data];
    //NSLog(@"resdata:%@",resdata);
    if([resdata isEqualToString:@"999"]==false){
        res_dictionary = [NetWorkHttp httpjsonParser:resdata];
    }
    return res_dictionary;
}

- (void) reRoadTableView
{
    res_dictionary = [[NSMutableDictionary alloc] init];
    res_dictionary = [self dataList];
    
    datasource = [[NSMutableArray alloc] init];
    datasource = [res_dictionary objectForKey:@"data"];
    lightSceneTableView.delegate = self;
    lightSceneTableView.dataSource = self;
    [lightSceneTableView reloadData];
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
    NSString *cmd = [NSString stringWithFormat:@"light_list_alarm"];
    
    //封装mutableDictionary
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uid,@"username_id",token,@"accesstoken",@"99",@"counts",bandtype,@"bandtype",alarmid,@"alarmid",nil];
    
    //mutableDictionary转NSString
    NSString *postdata = [[[SBJsonWriter alloc] init] stringWithObject:userInfo];
    
    //NSLog(@"封装mutableDictionary:%@",postdata);
    
    NSString *resdata = [NetWorkHttp httpGet:cmd Postdata:postdata];
    
    res_dictionary = [NetWorkHttp httpjsonParser:resdata];
    
    NSLog(@"res_dictionary :%@",res_dictionary);
    return res_dictionary;
}

@end
