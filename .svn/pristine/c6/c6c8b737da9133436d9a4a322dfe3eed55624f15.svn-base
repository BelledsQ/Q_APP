//
//  LocalMusicViewController.m
//  Belled
//
//  Created by Bellnet on 14-8-11.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "LocalMusicViewController.h"

@interface LocalMusicViewController ()
{
    GlobalSet *gt;
    NSUInteger nowPlayingIndex;
    NSString *devip;
}
@end

@implementation LocalMusicViewController
@synthesize  typeCtrl,itemid,nowIndex;

- (void)viewDidLoad
    {NSLog(@"mu----%s", __func__);
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    devip = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"dev_ip"]];
    [Tools hideTabBar:self.tabBarController];
    gt = [GlobalSet bellSetting];
    /*UIBarButtonItem *cButton = [[UIBarButtonItem alloc] initWithTitle:@"ADD"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(addPressed)];
    
    self.navigationItem.rightBarButtonItem = cButton;*/
    
    
    UIBarButtonItem *lButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(doClickedBack)];
    self.navigationItem.leftBarButtonItem = lButton;
    
    //if([gt.musicItems count]>0){
        //self.collection = [[MPMediaItemCollection alloc] initWithItems:gt.musicItems];
    //}else{
    //self.collection = [self findItem:itemid];
    self.collection = [self findArtistList];
    self.pause = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(playPausePressed:)];
    
    [self.pause setStyle:UIBarButtonItemStyleBordered];
    self.player = [MPMusicPlayerController iPodMusicPlayer];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(nowPlayingItemChanged:)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.player];
    
    [self.player beginGeneratingPlaybackNotifications];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(itemChanged) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(barChanged) userInfo:nil repeats:NO];
    [self playitem];
    //NSLog(@"startLocalMusic %@",[self findArtistList]);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doClickedBack
{
    gt = [GlobalSet bellSetting];
    gt.backitemid = itemid;

    //tabbar显示
    [Tools showTabBar:self.tabBarController];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)playitem {
    nowPlayingIndex =  [nowIndex intValue];
    NSLog(@"%d",nowPlayingIndex);
    if([gt.backitemid isEqualToString:itemid]){
    }else{
        //定位歌曲
        MPMediaItem *item = [[self.collection items] objectAtIndex:nowPlayingIndex];
        [self.player setNowPlayingItem:item];
        [self.player play];
    }
    [self.pause setTintColor:[UIColor blackColor]];
    NSMutableArray *baritems = [NSMutableArray arrayWithArray:[self.toolbar items]];
    [baritems replaceObjectAtIndex:3 withObject:self.pause];
    [self.toolbar setItems:baritems animated:YES];
    [self itemChanged];
}

- (IBAction)rewindPressed:(id)sender {
    if ([self.player indexOfNowPlayingItem] == 0) {
        [self.player skipToBeginning];
        //[self.player setQueueWithItemCollection:self.collection];
        //MPMediaItem *item = [[self.collection items] objectAtIndex:[self.collection count]];
        //[self.player setNowPlayingItem:item];
        //[self.player play];
    } else {
        [self.player endSeeking];
        [self.player skipToPreviousItem];
    }
}

- (IBAction)playPausePressed:(id)sender {
    [self.pause setTintColor:[UIColor blackColor]];
    MPMusicPlaybackState playbackState = [self.player playbackState];
    NSLog(@"playbackState - %d",playbackState);
    NSMutableArray *items = [NSMutableArray arrayWithArray:[self.toolbar items]];
    if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
        [self.player play];
        [items replaceObjectAtIndex:3 withObject:self.pause];
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        [self.player pause];
        [items replaceObjectAtIndex:3 withObject:self.play];
    }
    [self.toolbar setItems:items animated:YES];
    [self itemChanged];
}

- (IBAction)fastForwardPressed:(id)sender {
    //NSUInteger nowPlayingIndex = [self.player indexOfNowPlayingItem];
    [self.player endSeeking];
    [self.player skipToNextItem];
    if ([self.player nowPlayingItem] == nil) {
        if ([self.collection count] > nowPlayingIndex+1) {
            // added more songs while playing
            //[self.player setQueueWithItemCollection:self.collection];
            MPMediaItem *item = [[self.collection items] objectAtIndex:nowPlayingIndex+1];
            [self.player setNowPlayingItem:item];
            [self.player play];
        }
        else {
            // no more songs
            [self.player stop];
            //循环
            [self.player setQueueWithItemCollection:self.collection];
            MPMediaItem *item = [[self.collection items] objectAtIndex:0];
            [self.player setNowPlayingItem:item];
            [self.player play];
        }
    }
}

- (void)addPressed {
    MPMediaType mediaType = MPMediaTypeMusic;
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:mediaType];
    picker.delegate = self;
    [picker setAllowsPickingMultipleItems:YES];
    picker.prompt = NSLocalizedString(@"Select items to play", @"");
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)itemChanged
{
    MPMediaItem *currentItem = [self.player nowPlayingItem];
    if (nil == currentItem) {
        [self.imageView setImage:nil];
        [self.imageView setHidden:YES];
        [self.artist setText:nil];
        [self.song setText:nil];
    }
    else {
        MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
        if (artwork) {
            UIImage *artworkImage = [artwork imageWithSize:CGSizeMake(320, 320)];
            [self.imageView setImage:artworkImage];
            [self.imageView setHidden:NO];
        }
        
        // Display the artist and song name for the now-playing media item
        NSString *artistStr = [currentItem valueForProperty:MPMediaItemPropertyArtist];
        //NSString *albumStr = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        [self.artist setText:[NSString stringWithFormat:@"%@", artistStr]];
        [self.song setText:[currentItem valueForProperty:MPMediaItemPropertyTitle]];
    }
}

-(IBAction)syncBtn
{
    
    /*ScanViewController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"scanView"];
     [self.navigationController pushViewController:tmpEdit animated:YES];*/
    [self changeLightView];
}

-(void)changeLightView{
    static NSString *detailIdentifier = @"lightTableList";
    LightTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:detailIdentifier];
    detail.deviceip = devip;
    detail.typeCtrl = @"in";
    detail.syncCtrl = @"sync";
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)barChanged
{
        [self.pause setTintColor:[UIColor blackColor]];
        MPMusicPlaybackState playbackState = [self.player playbackState];
        NSMutableArray *items = [NSMutableArray arrayWithArray:[self.toolbar items]];
        if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
            [items replaceObjectAtIndex:3 withObject:self.play];
        } else if (playbackState == MPMusicPlaybackStatePlaying) {
            [items replaceObjectAtIndex:3 withObject:self.pause];
        }
        [self.toolbar setItems:items animated:YES];
}
#pragma mark - Media Picker Delegate Methods

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    
    NSLog(@"%s", __func__);
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    
    /*if (self.collection == nil) {
        self.collection = mediaItemCollection;
        [self.player setQueueWithItemCollection:self.collection];
        MPMediaItem *item = [[self.collection items] objectAtIndex:0];
        [self.player setNowPlayingItem:item];
        [self playPausePressed:self];
        NSArray *pItems = [self.collection items];
        gt.musicItems = [pItems copy];
    } else {
        NSArray *oldItems = [self.collection items];
        NSArray *newItems = [oldItems arrayByAddingObjectsFromArray:[mediaItemCollection items]];
        self.collection = [[MPMediaItemCollection alloc] initWithItems:newItems];
        gt.musicItems = [newItems copy];
    }*/
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Notification Methods

- (void)nowPlayingItemChanged:(NSNotification *)notification
{
	/*MPMediaItem *currentItem = [self.player nowPlayingItem];
    if (nil == currentItem) {
        [self.imageView setImage:nil];
        [self.imageView setHidden:YES];
        [self.artist setText:nil];
        [self.song setText:nil];
    }
    else {
        MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
        if (artwork) {
            UIImage *artworkImage = [artwork imageWithSize:CGSizeMake(320, 320)];
            [self.imageView setImage:artworkImage];
            [self.imageView setHidden:NO];
        }
        
        // Display the artist and song name for the now-playing media item
        NSString *artistStr = [currentItem valueForProperty:MPMediaItemPropertyArtist];
        //NSString *albumStr = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        [self.artist setText:[NSString stringWithFormat:@"%@", artistStr]];
        [self.song setText:[currentItem valueForProperty:MPMediaItemPropertyTitle]];
    }*/
    [self itemChanged];
}
-(MPMediaItemCollection*) findArtistList {
    MPMediaQuery *musicItemInIpod = [MPMediaQuery songsQuery];
    NSMutableArray *musicItemArr = [NSMutableArray arrayWithArray:[musicItemInIpod items]];
    MPMediaItemCollection *songItemCollection = [[MPMediaItemCollection alloc] initWithItems:musicItemArr];
    return songItemCollection;
}

-(MPMediaItemCollection*) findItem:(NSString *)str {
    MPMediaQuery *musicItemInIpod = [MPMediaQuery songsQuery];
    // 添加Filter来选择某个特定的队列
    MPMediaPropertyPredicate *artistNamePredicate = [MPMediaPropertyPredicate predicateWithValue:str forProperty:MPMediaItemPropertyPersistentID];
    [musicItemInIpod addFilterPredicate:artistNamePredicate];
    NSMutableArray *musicItemArr = [NSMutableArray arrayWithArray:[musicItemInIpod items]];
    MPMediaItemCollection *songItemCollection = [[MPMediaItemCollection alloc] initWithItems:musicItemArr];
    return songItemCollection;
}



@end
