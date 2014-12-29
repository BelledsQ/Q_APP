//
//  LightTableViewCell.h
//  Belled
//
//  Created by Bellnet on 14-4-25.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkHttp.h"
@interface LightTableViewCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *sn;

@property (nonatomic,retain) IBOutlet UILabel *model;

@property (nonatomic,retain) IBOutlet UISwitch *iswitch;

@property (nonatomic,retain)  NSString *red;
@property (nonatomic,retain)  NSString *green;
@property (nonatomic,retain)  NSString *blue;
@property (nonatomic,retain)  NSString *bright;
@property (nonatomic,retain)  NSString *iswitch_value;
@property (nonatomic,retain)  NSString *effect;
@property (nonatomic,retain)  NSString *model_value;
@property (nonatomic,retain)  NSString *devicesn;
@property (nonatomic,retain)  NSString *wanip;
@property (nonatomic,retain)  NSString *typeCtrl;
@property (nonatomic,retain)  NSString *syncCtrl;
@end
