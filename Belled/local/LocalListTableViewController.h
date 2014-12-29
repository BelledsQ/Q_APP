//
//  LocalListTableViewController.h
//  yinyuebang
//
//  Created by Bellnet on 14/10/23.
//  Copyright (c) 2014年 yyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkHttp.h"
#import "MusicTableViewCell.h"
#import "LocalMusicViewController.h"

@interface LocalListTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource,MPMediaPickerControllerDelegate>

@property (weak, nonatomic) NSString *typeCtrl;
//@property(nonatomic,retain) IBOutlet UITableView *songsTableView;
@end
