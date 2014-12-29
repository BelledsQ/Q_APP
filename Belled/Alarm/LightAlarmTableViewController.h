//
//  LightTableViewController.h
//  Belled
//
//  Created by Bellnet on 14-4-18.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkHttp.h"
#import "LightAlarmTableViewCell.h"
@interface LightAlarmTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *res_dictionary;
    NSMutableArray *datasource;
    NSInteger pageNum;
	NSInteger CountNum;
    UITableView *lightTableView;
    BOOL _reloading;
}

@property(strong,nonatomic) NSMutableArray *datasource;
@property (strong,nonatomic) NSString *effect;
@property (strong,nonatomic) NSString *bandtype;
@property (strong,nonatomic) NSString *alarmid;
@property (strong,nonatomic) IBOutlet UITableView *lightSceneTableView;

//@property(nonatomic,retain) NSMutableDictionary *data;
@end
