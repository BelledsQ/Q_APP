//
//  LightTableViewController.h
//  Belled
//
//  Created by Bellnet on 14-4-18.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkHttp.h"
#import "AlarmTableViewCell.h"
#import "AlarmTypeTableViewController.h"
#import "ADDAlarmViewController.h"
#import "EditAlarmViewController.h"

@interface AlarmTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,retain) NSMutableArray *datasource;
@property (strong,nonatomic) IBOutlet UITableView *alarmtableView;

//@property(nonatomic,retain) NSMutableDictionary *data;
@end