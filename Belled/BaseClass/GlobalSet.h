//
//  GlobalSet.h
//  Belled
//
//  Created by Bellnet on 14-6-4.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalSet : NSObject

+(id)bellSetting;
//soundcloud
@property (nonatomic, retain) NSMutableDictionary *apime;
@property (nonatomic, retain) NSString *apitoken;


//网关
@property (nonatomic, retain) NSArray *gatewaysn;


//alarm
@property (nonatomic, retain) NSString *alarmTitle;
@property (nonatomic, retain) NSString *alarmMusic;
@property (nonatomic, retain) NSString *alarmLight;
@property (nonatomic, retain) NSString *alarmWeek;

@property (nonatomic, retain) NSString *alarmLight_switch;
@property (nonatomic, retain) NSString *alarmLight_red;
@property (nonatomic, retain) NSString *alarmLight_green;
@property (nonatomic, retain) NSString *alarmLight_blue;
@property (nonatomic, retain) NSString *alarmLight_bright;

@property (nonatomic, retain) NSMutableArray *devices;
@property (strong, nonatomic) NSMutableArray *musicItems;

@property (nonatomic, retain) NSString *backitemid;
@end
