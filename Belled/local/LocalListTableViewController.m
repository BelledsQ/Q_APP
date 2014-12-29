//
//  LocalListTableViewController.m
//  yinyuebang
//
//  Created by Bellnet on 14/10/23.
//  Copyright (c) 2014年 yyb. All rights reserved.
//

#import "LocalListTableViewController.h"

@interface LocalListTableViewController ()

@end

@implementation LocalListTableViewController
{
    NSMutableArray *datasource;
    //UITableView *songsTableView;
}

@synthesize  typeCtrl;
- (void)viewDidLoad {
    [super viewDidLoad];
    if([typeCtrl isEqualToString:@"index"]){
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
        UIBarButtonItem *cButton = [[UIBarButtonItem alloc] initWithTitle:@"Welcome"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(doClickedBack)];
        
        self.navigationItem.leftBarButtonItem = cButton;
        
    }
    
    self.navigationItem.title = [NSString stringWithFormat:@"Local Music List"];
    //songsTableView.delegate = self;
    //songsTableView.dataSource = self;
    
    datasource = [[NSMutableArray alloc] init];
    datasource = [self findArtistList];
    NSLog(@"ArtistList %@",datasource);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) doClickedBack
{
    [self.navigationController setNavigationBarHidden:YES animated:TRUE];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [datasource count];
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSInteger row = [indexPath row];
    //static NSString *MyIdentifier = @"reuseIdentifier";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    
    static NSString *CellIdentifier = @"localcell";
    MusicTableViewCell *cell = (MusicTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MusicTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
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
    cell.songtitle.text = [datarow objectForKey:@"title"];
    cell.songartist.text = [datarow objectForKey:@"artist"];
    //Arrow
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
    return cell;
}

//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *detailIdentifier = @"localmuiscview";
    
    LocalMusicViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:detailIdentifier];
    
    NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
    datarow = [datasource objectAtIndex:indexPath.row];
    
    detail.itemid = [datarow objectForKey:@"itemid"];
    detail.nowIndex = [NSString stringWithFormat:@"%d",indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(NSMutableArray*) findArtistList {
    
    //MPMediaQuery *musicItemInIpod = [MPMediaQuery playlistsQuery];
    //NSMutableArray *musicItemArr = [NSMutableArray arrayWithArray:[musicItemInIpod items]];
    //MPMediaItemCollection *songItemCollection = [[MPMediaItemCollection alloc] initWithItems:musicItemArr];
    //gt.musicItems = [musicItemArr copy];
    NSMutableArray *artistList = [[NSMutableArray alloc]init];
    MPMediaQuery *listQuery = [MPMediaQuery songsQuery];//播放列表

    NSArray *playlist = [listQuery collections];//播放列表数组
    
    for (MPMediaPlaylist * list in playlist) {
        NSArray *songs = [list items];//歌曲数组
        NSMutableDictionary *itemsong = [[NSMutableDictionary alloc] init];
        
        for (MPMediaItem *song in songs) {
            //歌曲ID
            NSString *itemid = [[NSString alloc ]initWithFormat:@"%@",[song valueForProperty:MPMediaItemPropertyPersistentID]];
            
            //歌曲名
            NSString *title = [[NSString alloc ]initWithFormat:@"%@",[song valueForProperty:MPMediaItemPropertyTitle]];
            
            //歌手名
            NSString *artist = [[NSString alloc ]initWithFormat:@"%@",[[song valueForProperty:MPMediaItemPropertyArtist] uppercaseString]];
            
            itemsong = [[NSMutableDictionary alloc] initWithObjectsAndKeys:itemid,@"itemid",title,@"title",artist,@"artist",nil];
            
            //NSLog(@"title %@",title);
            [artistList addObject:itemsong];
        }
    }

    return artistList;
}
@end
