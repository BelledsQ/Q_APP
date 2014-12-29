//
//  Config.h
//  Belled
//
//  Created by Bellnet on 14-5-4.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <Foundation/Foundation.h>


//#define __HOSTNAME__ @"http://192.168.3.121/led_server/api/api.php"

//#define __HOSTNAME__ @"http://192.168.3.115/led_server/api/api.php"

#define __HOSTNAME__ @"http://121.40.90.86:8000/q/api/api.php"

#define PageCount 2

#define Counts "10"

#define UDP_IP @"192.168.3.49"

#define UDP_PORT 11600

#define BRO_IP @"224.0.0.88"

#define BRO_PORT 11608

#define WAN_IP @"172.16.0.1"

#define VERSION @"QLight"

#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
