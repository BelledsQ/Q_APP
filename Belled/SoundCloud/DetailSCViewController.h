//
//  DetailSCViewController.h
//  Belled
//
//  Created by Bellnet on 14-6-3.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkHttp.h"

@interface DetailSCViewController : UIViewController

@property (nonatomic,retain) NSString *snstr,*idstr,*token;

@property (nonatomic,retain) IBOutlet UILabel *snlab,*idlab;

@property (nonatomic,retain) IBOutlet UIButton *playbtn;
@end
