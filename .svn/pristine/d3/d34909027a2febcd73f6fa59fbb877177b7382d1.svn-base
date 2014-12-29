//
//  SceneTableViewController.h
//  Belled
//
//  Created by Bellnet on 14-4-18.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkHttp.h"
#import "SceneTableViewCell.h"
#import "DetailSceneViewController.h"
#import "LightSceneTableViewController.h"
#import "ADDSceneViewController.h"
#import "MODSceneViewController.h"
@interface SceneTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *res_dictionary;
    NSMutableArray *datasource;
    NSInteger pageNum;
	NSInteger CountNum;
    BOOL _reloading;
    GlobalSet *gt;
    MBProgressHUD *HUD;
    NSString *aid;
    
    AsyncUdpSocket *clientSocket;
    AsyncUdpSocket *udpSocket;
}
@property(nonatomic,retain) IBOutlet UITableView *lightTableView;
@property(nonatomic,retain) NSString *scenetype;
@property(nonatomic,retain) NSString *wanip;
@property(nonatomic,retain) NSString *groupone;

//@property(nonatomic,retain) NSMutableDictionary *data;
@end
