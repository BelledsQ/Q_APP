//
//  GlobalSet.m
//  Belled
//
//  Created by Bellnet on 14-6-4.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "GlobalSet.h"

@implementation GlobalSet

@synthesize  apime,apitoken,alarmTitle,alarmLight,alarmLight_switch,alarmLight_red,alarmLight_green,alarmLight_blue,alarmLight_bright,alarmWeek,devices,backitemid;

static GlobalSet *singleton;

BOOL isFromSelf = NO;

//将单例实现

+(id)bellSetting

{
    
    if (singleton == nil) {
        
        isFromSelf = YES;
        
        singleton = [[GlobalSet alloc]init];
        
        isFromSelf = NO;
        
    }
    
    return singleton;
    
}

// 2. 单例在什么时候都不要释放 因为其实就是全局变量
// 3. 如何避免单例被alloc


+ (id) alloc {
    
    if (isFromSelf ) {
        
        return [super alloc];
        
    } else {
        
        return nil;
        
    }
    
}

- (void) dealloc {
    
    NSLog(@"in dealloc");
    
    // ARC 不用在写[super dealloc]
    
    // ARC 不能用autorelease 系统会自动加autorelease
    
     //[super dealloc];
    
}



@end
