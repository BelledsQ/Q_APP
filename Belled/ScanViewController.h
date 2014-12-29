//
//  ScanViewController.h
//  Belled
//
//  Created by Bellnet on 14-6-26.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkHttp.h"
#import "ScanTableViewCell.h"
#import "LoginViewController.h"
#import "LightTableViewController.h"
@interface ScanViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) IBOutlet UITableView *scantableView;
@property(nonatomic,retain) NSArray *datasource;
@property(nonatomic,retain) NSString *typeCtrl;
@end
