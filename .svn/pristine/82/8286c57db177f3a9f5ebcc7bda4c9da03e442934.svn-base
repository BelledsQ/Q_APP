//
//  SetTableViewController.m
//  Belled
//
//  Created by Bellnet on 14-4-18.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "SetTableViewController.h"

@interface SetTableViewController ()

@end


@implementation SetTableViewController

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
    self.navigationItem.title = [NSString stringWithFormat:@"Setting"];
    [self setList];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *net = [[NSString alloc] init];
    net = [ud objectForKey:@"network_in"];
    if( [net isEqualToString:@"0"]){
        networks = [[NSMutableString alloc]initWithFormat:@"out"];
        
    }else{
        networks = [[NSMutableString alloc]initWithFormat:@"in"];
    }
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
    
    static NSString *CellIdentifier = @"SetCell";
    SetTableViewCell *cell = (SetTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SetTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.sn.text = [datasource objectAtIndex:indexPath.row];
    if(indexPath.row==2){
        cell.net.text = networks;
    }else{
        cell.net.text = @"";
    }
    //Arrow
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    return cell;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*static NSString *detailIdentifier = @"lightdetail";
    
    SoundViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:detailIdentifier];*/
    
    //NSString *datarow = [[NSString alloc] init];
    //datarow = [datasource objectAtIndex:indexPath.row];
    if(indexPath.row==0){
        [self pageChange];
    }
    
    
    if(indexPath.row==1){
        [self pageChangeToDevices];
    }
    
    if(indexPath.row==2){
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *net = [[NSString alloc] init];
        net = [ud objectForKey:@"network_in"];
        if( [net isEqualToString:@"0"]){
            [self saveNetworkin];
            
        }else{
            [self saveNetworkout];
        }
        [self.tableView reloadData];
    }
    
    if(indexPath.row==3){
        [self saveUser];
        [self pageChange];
    }
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

-(void)setList
{
    datasource = [[NSMutableArray alloc] initWithObjects:@"Home",@"Devices",@"NetWork",@"Logout",VERSION,nil];
    NSLog(@"%@",datasource);
}


//实现界面的切换  并把值传递过去
-(void)pageChange
{
    //LightConViewController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    UINavigationController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"indexView"];
    //实现页面的切换
    [self presentModalViewController:tmpEdit animated:YES];
    //[self pushViewController:tmpEdit animated:YES];
}



-(void)pageChangeToDevices
{
    //要从此类界面转换到HomeViewController类的界面,storyboard
    DevicesTableViewController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"DevicesViewList"];
    
    //实现页面的切换
    [self.navigationController pushViewController:tmpEdit animated:YES];
}

-(void)saveUser
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"" forKey:@"username_id"];
    [ud setObject:@"" forKey:@"username_name"];
    [ud setObject:@"" forKey:@"accesstoken"];
    [ud synchronize];
    
    NSString *testStr = [ud objectForKey:@"accesstoken"];
    NSLog(@"saveUser is: %@",testStr);
}

-(void)saveNetworkout
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"0" forKey:@"network_in"];
    [ud setObject:@"1" forKey:@"network_out"];
    [ud synchronize];
    networks = [[NSMutableString alloc]initWithFormat:@"out"];
}

-(void)saveNetworkin
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@"1" forKey:@"network_in"];
    [ud setObject:@"0" forKey:@"network_out"];
    [ud synchronize];
    networks = [[NSMutableString alloc]initWithFormat:@"in"];
}
@end
