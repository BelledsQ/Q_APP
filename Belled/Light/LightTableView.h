//
//  LightTableView.h
//  Belled
//
//  Created by Bellnet on 14-4-18.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkHttp.h"
#import "LightTableViewCell.h"

@interface LightTableView: UITableView<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *_res_dictionary;
    NSMutableDictionary *_data;
    
}
@property (nonatomic,retain) IBOutlet NSMutableDictionary *data;

@end
