//
//  AlarmTypeTableViewController.h
//  Belled
//
//  Created by Bellnet on 14-4-18.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkHttp.h"
#import "AlarmTableViewCell.h"
#import "ADDAlarmViewController.h"
#import "LightAlarmTableViewController.h"
@interface AlarmTypeTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) IBOutlet UITableView *scantableView;
@property(nonatomic,retain) NSArray *datasource;

@property(nonatomic,retain) NSString *alarmid;
@end
