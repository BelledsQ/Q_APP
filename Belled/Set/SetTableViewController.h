//
//  SetTableViewController.h
//  Belled
//
//  Created by Bellnet on 14-4-18.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkHttp.h"
#import "SetTableViewCell.h"
#import "IndexViewController.h"
#import "LightConViewController.h"
#import "DevicesTableViewController.h"
@interface SetTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *res_dictionary;
    NSMutableArray *datasource;
    NSInteger pageNum;
	NSInteger CountNum;
    
    UITableView *lightTableView;
    BOOL _reloading;
    NSMutableString *networks;
}

@property(nonatomic,retain) NSMutableArray *datasource;



//@property(nonatomic,retain) NSMutableDictionary *data;
@end
