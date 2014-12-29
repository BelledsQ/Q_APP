//
//  LightTableViewController.m
//  Belled
//
//  Created by Bellnet on 14-4-18.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "AlarmTypeTableViewController.h"

@interface AlarmTypeTableViewController ()

@end


@implementation AlarmTypeTableViewController

@synthesize  scantableView,datasource,alarmid;


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
    self.navigationItem.title = [NSString stringWithFormat:@"AlarmType List"];
    
    //datasource = [[NSArray alloc] initWithObjects:@"Light",@"Scene",@"BellCloud",nil];
    datasource = [[NSArray alloc] initWithObjects:@"Light",@"Scene",nil];
    NSLog(@"%@",datasource);
    // Do any additional setup after loading the view.
    
    scantableView.delegate = self;
    scantableView.dataSource = self;

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
    
    return [datasource count];
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AlarmtypeCell";
    AlarmTableViewCell *cell = (AlarmTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AlarmTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSString *datarow = [[NSString alloc] init];
    datarow = [datasource objectAtIndex:indexPath.row];
    NSLog(@"%@",datarow);
    cell.sn.text = datarow;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    return cell;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *detailIdentifier = @"LightAlarmView";
    
    LightAlarmTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:detailIdentifier];
    
    NSString *datarow = [[NSString alloc] init];
    datarow = [datasource objectAtIndex:indexPath.row];
    
    detail.alarmid = alarmid;
    if([datarow isEqualToString:@"Light"]){
        detail.bandtype = [NSString stringWithFormat:@"1"];
    }
    
    if([datarow isEqualToString:@"Scene"]){
        detail.bandtype = [NSString stringWithFormat:@"2"];
    }
    
    if([datarow isEqualToString:@"BellCloud"]){
        detail.bandtype = [NSString stringWithFormat:@"3"];
    }
    
    [self.navigationController pushViewController:detail animated:YES];
    
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	
}

- (void)doneLoadingTableViewData{
	
}

@end
