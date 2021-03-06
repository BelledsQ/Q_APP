//
//  NetWorkHttp.h
//  Belled
//
//  Created by Bellnet on 14-4-17.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "Tools.h"
#import "SBJson.h"
#import "AsyncUdpSocket.h"
#import "EFCircularSlider.h"
#import "RSCameraRotator.h"
#import "ASIFormDataRequest.h"
#import "GlobalSet.h"
//#import "AudioStreamer.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "SoundViewController.h"
#import "MJRefresh.h"
#import <MediaPlayer/MediaPlayer.h>

@interface NetWorkHttp : NSObject

//http请求
+(NSString *)httpGet:(NSString *)cmd Postdata:(NSString *)postdata;
+(NSString *)httpPost:(NSString *)cmd Postdata:(NSString *)postdata Files:(NSString *)files;
+(NSMutableDictionary *)httpjsonParser:(NSString *)jsonString;
@end
