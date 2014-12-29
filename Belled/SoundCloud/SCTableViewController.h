//
//  SCTableViewController.h
//  Belled
//
//  Created by Bellnet on 14-6-3.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkHttp.h"
#import "SCTableViewCell.h"
#import "DetailSCViewController.h"
#import "SC_tracksTableViewController.h"
#import "SCTBViewController.h"

@interface SCTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,retain) NSMutableArray *datasource;

@end
