//
//  WebViewViewController.h
//  Belled
//
//  Created by Bellnet on 14-7-30.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkHttp.h"
#import "ScanViewController.h"
@interface WebViewViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic,retain) IBOutlet UIWebView *setuiwebView;
@property (nonatomic,retain)    NSString *wanip;
@end
