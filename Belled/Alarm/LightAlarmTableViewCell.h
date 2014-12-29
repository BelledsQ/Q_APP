//
//  LightSceneTableViewCell.h
//  Belled
//
//  Created by Bellnet on 14-4-25.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightAlarmTableViewCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *sn;

@property (nonatomic,retain) IBOutlet UILabel *model;

@property (nonatomic,retain) IBOutlet UIImageView *imagesel;

@property (nonatomic,retain) NSString *groupbanding;
@end
