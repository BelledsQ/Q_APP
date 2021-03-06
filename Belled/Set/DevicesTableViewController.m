//
//  LightSceneTableViewController.m
//  Belled
//
//  Created by Bellnet on 14-4-18.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "DevicesTableViewController.h"

@interface DevicesTableViewController ()

@end


@implementation DevicesTableViewController
{
    GlobalSet *gt;
    MBProgressHUD *HUD;
    NSString *aid;
    NSMutableArray *devices;
}
@synthesize  datasource,effect,groupid,lightSceneTableView;


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
    self.navigationItem.title = [NSString stringWithFormat:@"Devices List"];
    
    //self.navigationItem.backBarButtonItem.title =[NSString stringWithFormat:@"Return"];


    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    res_dictionary = [self dataList];
    
    devices = [[NSMutableArray alloc] init];
    
    datasource = [[NSMutableArray alloc] init];
    datasource = [res_dictionary objectForKey:@"data"];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    NSLog(@"datasource ---- %@",datasource);
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
    NSLog(@"rows : %d",[datasource count]);
    return [datasource count];
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DevicesCell";
    
    DevicesTableViewCell *cell = (DevicesTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[DevicesTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
    datarow = [datasource objectAtIndex:indexPath.row];
   
    NSLog(@"datarow--%@",datarow);
    
    cell.sn.text = [datarow objectForKey:@"sn"];
    cell.model.text = [datarow objectForKey:@"ip"];
    
    NSString *groupband = [[NSString alloc] initWithFormat:@"%@",[datarow objectForKey:@"status"]];
    UIImage *image = [UIImage alloc];
    if([groupband isEqualToString:@"0"]){
        image = [UIImage imageNamed:@"selon.png"];
    }else if([groupband isEqualToString:@"2"]){
        image = [UIImage imageNamed:@"selerror.png"];
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
    aid = [[NSString alloc ]initWithFormat:@"%@",[datarow objectForKey:@"sn"]];
    NSString *status = [[NSString alloc ]initWithFormat:@"%@",[datarow objectForKey:@"status"]];
    NSLog(@"status -----%@",status);
    if([status isEqualToString:@"1"] ){
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
    res_dictionary = [self httpBanding];
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

-(NSMutableDictionary *)httpBanding
{
    gt = [GlobalSet bellSetting];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"username_id"]];
    NSString *token = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"accesstoken"]];
    
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    NSString *cmd = [NSString stringWithFormat:@"bangding"];
    NSMutableArray *idArr = [[NSMutableArray arrayWithObjects:
                                   [NSMutableDictionary dictionaryWithObjectsAndKeys:aid,@"sn", nil],
                                   nil] retain];
    
    //封装mutableDictionary
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uid,@"username_id",token,@"accesstoken",idArr,@"devices",nil];
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
    res_dictionary = [self httpNoBanding];
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

-(NSMutableDictionary *)httpNoBanding
{
    gt = [GlobalSet bellSetting];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"username_id"]];
    NSString *token = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"accesstoken"]];
    
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    NSString *cmd = [NSString stringWithFormat:@"nobangding"];
    NSMutableArray *idArr = [[NSMutableArray arrayWithObjects:
                              [NSMutableDictionary dictionaryWithObjectsAndKeys:aid,@"sn", nil],
                              nil] retain];
    
    //封装mutableDictionary
    NSMutableDictionary *postdata = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uid,@"username_id",token,@"accesstoken",idArr,@"devices",nil];
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
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
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
    NSString *cmd = [NSString stringWithFormat:@"bangding_status"];
    
    GlobalSet *gt = [GlobalSet bellSetting];
    devices = [gt.devices copy];
    
    //封装mutableDictionary
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uid,@"username_id",token,@"accesstoken",devices,@"devices",nil];
    
    //mutableDictionary转NSString
    NSString *postdata = [[[SBJsonWriter alloc] init] stringWithObject:userInfo];
    
    //NSLog(@"封装mutableDictionary:%@",postdata);
    
    NSString *resdata = [NetWorkHttp httpGet:cmd Postdata:postdata];
    
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    res_dictionary = [NetWorkHttp httpjsonParser:resdata];
    
    NSLog(@"res_dictionary :%@",res_dictionary);
    return res_dictionary;
}

@end
