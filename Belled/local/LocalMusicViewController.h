//
//  LocalMusicViewController.h
//  Belled
//
//  Created by Bellnet on 14-8-11.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkHttp.h"
#import "LightTableViewController.h"

@interface LocalMusicViewController : UIViewController <MPMediaPickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *song;
@property (weak, nonatomic) IBOutlet UILabel *artist;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UILabel *status;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *play;
@property (strong, nonatomic)          UIBarButtonItem *pause;

@property (strong, nonatomic) NSString *itemid;
@property (strong, nonatomic) NSString *nowIndex;

@property (strong, nonatomic) MPMusicPlayerController *player;

@property (strong, nonatomic) MPMediaItemCollection *collection;
@property (strong, nonatomic) MPMediaItemCollection *collection2;

@property (weak, nonatomic) NSString *typeCtrl;
- (IBAction)rewindPressed:(id)sender;
- (IBAction)playPausePressed:(id)sender;
- (IBAction)fastForwardPressed:(id)sender;

- (void)nowPlayingItemChanged:(NSNotification *)notification;

@end
