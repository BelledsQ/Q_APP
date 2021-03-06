//
//  HomeViewController.h
//  Belled
//
//  Created by Bellnet on 14-4-18.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetWorkHttp.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "LCVoice.h"
#import "LCVoiceHud.h"

@interface SoundViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,RSCameraRotatorDelegate>

//@property (strong,nonatomic) IBOutlet UISlider *brightness;

@property (strong,nonatomic)    IBOutlet UIPickerView      *selectEffect;
@property (retain, nonatomic)   IBOutlet UIButton          *recordBtn;         //录音按钮
@property (retain, nonatomic)   IBOutlet UISwitch          *switchBtn;         //开关灯
@property (retain, nonatomic)   IBOutlet UISlider          *switchslider;      //灯亮度
@property (retain, nonatomic)   IBOutlet UIButton          *stopBtn;           //停止按钮
@property (retain, nonatomic)   IBOutlet UIImageView       *colorRGBr;
@property (nonatomic,retain)    NSString *sn,*model;

@end
