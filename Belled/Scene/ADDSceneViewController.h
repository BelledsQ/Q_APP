//
//  ADDSceneViewController.h
//  Belled
//
//  Created by Bellnet on 14-10-13.
//  Copyright (c) 2014年 Belled. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkHttp.h"
#import "SceneTableViewController.h"

@interface ADDSceneViewController : UIViewController<UITextFieldDelegate>
@property (strong,nonatomic) IBOutlet UITextField *tit;
@property (strong,nonatomic) IBOutlet UITextField *des;
@property (strong,nonatomic) NSString *scenetype;
@property (strong,nonatomic) NSString *wanip;
@end
