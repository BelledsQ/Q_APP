//
//  SCTableViewController.m
//  Belled
//
//  Created by Bellnet on 14-6-3.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "SCTableViewController.h"

@interface SCTableViewController ()

@end

@implementation SCTableViewController
{

    NSString                    *token;
    NSMutableDictionary         *me;
 
    NSArray *res;
    NSMutableArray *datasource;
    NSInteger pageNum;
    NSInteger CountNum;
        
    EGORefreshTableHeaderView *_refreshHeaderView;
    UITableView *lightTableView;
    BOOL _reloading;
  
}
@synthesize  datasource;

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
    
    //全局变量
    GlobalSet *gt = [GlobalSet bellSetting];
    token = gt.apitoken;
    me = gt.apime;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@-%@",NSLocalizedString(@"Play",nil),NSLocalizedString(@"Lists",nil)];
    
    [self api_playlist];
    
    datasource = [[NSMutableArray alloc] init];
    datasource = [res copy];
    
    //lightTableView = [self.storyboard instantiateViewControllerWithIdentifier:@"lighttableview"];
    //datasource = [res_dictionary valueForKey:@"data"];
    
    NSLog(@"datasource : %@",datasource);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    static NSString *CellIdentifier = @"SCMainCell";
    SCTableViewCell *cell = (SCTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SCTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
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
    NSLog(@"rows : %@ , %@",[datarow objectForKey:@"permalink"],[datarow objectForKey:@"id"]);
    
    
    cell.sn.text = [NSString stringWithFormat:@"%@", [datarow objectForKey:@"permalink"]];
    cell.model.text = [NSString stringWithFormat:@"%@", [datarow objectForKey:@"id"]];
    //Arrow
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    return cell;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *detailIdentifier = @"sc_trackstable";
    
    SC_tracksTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:detailIdentifier];
    
    NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
    datarow = [datasource objectAtIndex:indexPath.row];
    detail.playListId = [NSString stringWithFormat:@"%@", [datarow objectForKey:@"id"]];
    
    [self.navigationController pushViewController:detail animated:YES];
    
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
        
        res = [[NSArray alloc] init];
        
        res = [NetWorkHttp arrjsonParser:resdata];
 
    }
    
}
@end