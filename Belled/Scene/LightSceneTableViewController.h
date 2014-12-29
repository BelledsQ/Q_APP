//
//  LightTableViewController.h
//  Belled
//
//  Created by Bellnet on 14-4-18.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkHttp.h"
#import "LightTableViewCell.h"
#import "LightConViewController.h"
#import "SetTableViewController.h"
#import "LightSceneTableViewCell.h"
@interface LightSceneTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *res_dictionary;
    NSMutableArray *datasource;
    NSInteger pageNum;
	NSInteger CountNum;
    
    UITableView *lightTableView;
    BOOL _reloading;
    AsyncUdpSocket *clientSocket;
    AsyncUdpSocket *udpSocket;
}

@property(nonatomic,retain) NSMutableArray *datasource;
@property (nonatomic,retain) NSString *effect;
@property (nonatomic,retain) NSString *groupid;
@property (strong,nonatomic) NSString *scenetype;
@property (strong,nonatomic) NSString *wanip;
@property (strong,nonatomic) IBOutlet UITableView *lightSceneTableView;

//@property(nonatomic,retain) NSMutableDictionary *data;
@end
