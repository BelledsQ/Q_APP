//
//  DetailLightViewController.h
//  Belled
//
//  Created by Bellnet on 14-4-25.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkHttp.h"

@interface DetailSceneViewController : UIViewController

{
    NSString *sn;
    NSString *model;
    
}

@property (nonatomic,retain) NSString *sn,*model;

@property (nonatomic,retain) IBOutlet UILabel *snlab,*modellab;

- (IBAction)sendButtonPressedOnLight:(id)sender;
- (IBAction)sendButtonPressedOffLight:(id)sender;
@end
