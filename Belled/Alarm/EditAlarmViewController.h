//
//  EditAlarmViewController.h
//  Belled
//
//  Created by Bellnet on 14/10/21.
//  Copyright (c) 2014年 Belled. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkHttp.h"
#import "AlarmTableViewCell.h"
#import "AlarmTableViewCell.h"
#import "LeveyPopListView.h"
#import "LightConViewController.h"

@interface EditAlarmViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,LeveyPopListViewDelegate,UITextFieldDelegate>

@property (strong,nonatomic) IBOutlet UITableView *scantableView;
@property (strong,nonatomic) IBOutlet UIDatePicker *dataPicker;
@property(nonatomic,retain) NSArray *datasource;
@property (strong, nonatomic) NSMutableArray *celloptions;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UILabel *infoLabel;

@property (strong, nonatomic) NSString *aid;
@property (strong, nonatomic) NSString *atitle;
@property (strong, nonatomic) NSString *aactiontime;
@property (strong, nonatomic) NSString *acontrol;
@property (strong, nonatomic) NSString *aweeks;
@property (strong, nonatomic) NSString *atimezone;

@end
