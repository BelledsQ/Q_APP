//
//  HomeViewController.m
//  Belled
//
//  Created by Bellnet on 14-4-18.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "SoundViewController.h"

@interface SoundViewController ()

@end

@implementation SoundViewController

{
    AsyncUdpSocket *clientSocket;
    EFCircularSlider *colorRGB;
    EFCircularSlider *brightness;
    NSMutableArray *valueRGB;
    UIPickerView *selectEffect;
    RSCameraRotator *rotator;
    RSCameraRotator *colorSwitch;
    NSString *model;
    NSString *modelc;
    NSString *red;
    NSString *green;
    NSString *blue;
    NSString *lighting;
    MBProgressHUD *HUD;
    NSTimer *myTimer;                       //定时器
    //LCVoiceHud *lcvHud;                     //麦克风
    
    LCVoice * voice;
    AVAudioPlayer           *player;
    NSString                *nameFile;      //文件名
    NSString                *mp3Path;       //mp3文件路径
    NSString                *wavPath;       //wav文件路径
    
    NSString                *sTime;         //开始录制时间
    NSString                *SSSTime;       //时间流
    BOOL                    isRes;          //录制状态   YES是录制状态
    
    NSMutableString         *cmdLight;      //录制的灯空指令
    NSMutableString         *pcmdLight;     //本地用的录制的灯空指令格式
    
    long long               firsttime;      //上次时间
    
    UIButton                *speaker;       //录音按钮
    UIButton                *speakerstop;       //录音停止按钮
    NSMutableArray          *ledcmd;        //录音回放的控制指令
}

@synthesize  sn,model;
@synthesize  selectEffect,switchslider,stopBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    [self.view insertSubview:_colorRGBr atIndex:1];
    
    firsttime = 0;
    
    clientSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    
    isRes = NO;
    
    model = [[NSString alloc] initWithFormat:@"%@",@"8"];
    modelc= [[NSString alloc] initWithFormat:@"%@",@"8"];
    red= [[NSString alloc] initWithFormat:@"%@",@"0"];
    green= [[NSString alloc] initWithFormat:@"%@",@"0"];
    blue= [[NSString alloc] initWithFormat:@"%@",@"0"];
    lighting= [[NSString alloc] initWithFormat:@"%@",@"100"];
    
    //cmdLight = [[NSMutableString alloc] initWithString:@"0====,0,0,0,0,0,0,===\n"];
    cmdLight = [[NSMutableString alloc] init];
    pcmdLight = [[NSMutableString alloc] init];
    
    //初始化录音vc
    voice = [[LCVoice alloc]init];
    
    //初始化播放器
    player = [[AVAudioPlayer alloc]init];
    
    //隐藏NAV
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    
    UIBarButtonItem *cButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(doClickedBack)];
    self.navigationItem.leftBarButtonItem = cButton;
    
    [Tools hideTabBar:self.tabBarController];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@",sn];
    /*
    //灯亮度开关
    rotator = [[RSCameraRotator alloc] initWithFrame:CGRectMake(20, 42, 80, 30)];
    rotator.tintColor = [UIColor blackColor];
    rotator.offColor = [[self class] colorWithARGBHex:0xff498e14];
    rotator.onColorLight = [[self class] colorWithARGBHex:0xff9dd32a];
    rotator.onColorDark = [[self class] colorWithARGBHex:0xff66a61b];
    rotator.delegate = self;
    [self.view addSubview:rotator];
    */
    
    //彩色
    CGRect sliderFrame = CGRectMake(35, 70, 250, 250);
    colorRGB = [[EFCircularSlider alloc] initWithFrame:sliderFrame];
    colorRGB.minimumValue = 1;
    colorRGB.maximumValue = 360;
    colorRGB.lineWidth = 0;

    colorRGB.unfilledColor = [[UIColor alloc] initWithRed:9/255.0f green:136/255.0f blue:201/255.0f alpha:1.0f];
    colorRGB.filledColor = [[UIColor alloc] initWithRed:9/255.0f green:136/255.0f blue:201/255.0f alpha:1.0f];
    colorRGB.handleType = nullBigCircle;
    //colorRGB.handleType = nullCircle;
    colorRGB.handleColor = [[UIColor alloc] initWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    //[self.view addSubview:colorRGB];
    
    [colorRGB addTarget:self action:@selector(updateLightColorRGB:) forControlEvents:UIControlEventValueChanged];
    
    //明暗
    /*CGRect sliderFrame2 = CGRectMake(85, 120, 150, 150);
    brightness = [[EFCircularSlider alloc] initWithFrame:sliderFrame2];
    brightness.minimumValue = 1;
    brightness.maximumValue = 200;
    brightness.lineWidth = 10;
    brightness.unfilledColor = [[UIColor alloc] initWithRed:155/255.0f green:155/255.0f blue:155/255.0f alpha:1.0f];
    brightness.filledColor = [[UIColor alloc] initWithRed:155/255.0f green:155/255.0f blue:155/255.0f alpha:1.0f];
    brightness.handleType = bigCircle;
    brightness.handleColor = [[UIColor alloc] initWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    [self.view addSubview:brightness];
    
    //[brightness addTarget:self action:@selector(updateLightBrightness:) forControlEvents:UIControlEventValueChanged];
     */
    
    //录音开始按钮
    speaker = [[UIButton alloc] initWithFrame:CGRectMake(115, 146, 90, 90)];
    [speaker setBackgroundImage:[UIImage imageNamed:@"mic_normal_358x358@2x.png"] forState:UIControlStateNormal];
    [self.view insertSubview:speaker atIndex:99];
    
    //录音停止按钮
    speakerstop = [[UIButton alloc] initWithFrame:CGRectMake(115, 146, 90, 90)];
    [speakerstop setBackgroundImage:[UIImage imageNamed:@"mic_red_358x358@2x.png"] forState:UIControlStateNormal];
    //[self.view insertSubview:speaker atIndex:98];
    
    //[self showVoiceHudOrHide:YES];
    
    //[self.view insertSubview:speakerstop atIndex:98];
    
    //添加长按手势
    //UILongPressGestureRecognizer *longPrees = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(recordBtnLongPressed:)];
    /*longPrees.delegate = self;
    [speaker addGestureRecognizer:longPrees];*/
    
    [speaker addTarget:self action:@selector(recordStart) forControlEvents:UIControlEventAllTouchEvents];
    
    [speakerstop addTarget:self action:@selector(recordEnd) forControlEvents:UIControlEventAllTouchEvents];
    
    [switchslider addTarget:self action:@selector(updateBrightness) forControlEvents:UIControlEventValueChanged];
    
    [_switchBtn addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    //[switchslider removeFromSuperview];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    //[HUD show:YES];
}

- (void)switchChanged:(UISwitch *)sender
{
    // When using GPUImage, put [self.videoCamera rotateCamera]; here,
    // Otherwise do:
    if (sender.on) {
        NSLog(@"back button selected");
        [self sendButtonPressedOnLight];
    } else {
        NSLog(@"front button selected");
        [self sendButtonPressedOffLight];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSString *)NSString2Json:(int)value
{
    NSMutableDictionary *device = [[NSMutableDictionary alloc] init];
    switch (value) {
        case 1:
            //封装mutableDictionary
            device = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"DEVLED00001133",@"sn",@"colorLed",@"model",@"1",@"online",model,@"modeOption",@"0",@"matchValue",red,@"redValue",green,@"greenValue",blue,@"blueValue",lighting,@"lightValue",nil];
            break;
            
        case 2:
            //封装mutableDictionary
            device = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"DEVLED00001133",@"sn",@"colorLed",@"model",@"1",@"online",model,@"modeOption",@"0",@"matchValue",@"0",@"redValue",@"0",@"greenValue",@"0",@"blueValue",lighting,@"lightValue",nil];
            break;
            
        default:
            //封装mutableDictionary
            device = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"DEVLED00001133",@"sn",@"colorLed",@"model",@"1",@"online",model,@"modeOption",@"0",@"matchValue",red,@"redValue",green,@"greenValue",blue,@"blueValue",lighting,@"lightValue",nil];
            break;
    }
    
    NSArray *array = [[NSArray alloc] initWithObjects:device,nil];
    
    NSMutableDictionary *dev = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"65385e5bc813500ead2a8f0f710bd49a",@"accesstoken",array,@"led",nil];
    
    //mutableDictionary转NSString
    NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:dev];
    return data;
  
}


- (void)matchLight:(id)sender{
    NSLog(@"发送匹配");
    //sTime = [[NSString alloc] initWithFormat:@"%@",[Tools getTimeSp]];
    NSString *message = @"===,2,0,0,0,0,0,===";
    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"message : %@",message);
    [clientSocket sendData:cmdData toHost:UDP_IP port:UDP_PORT withTimeout:-1 tag:1];
    [self play];
    
    //[myTimer setFireDate:[NSDate distantPast]];  //开启定时器
}

- (void)sendButtonPressedOnLight
{
    //[self connect];
    NSLog(@"发送开灯");
    //===,P,M,R,G,B,L,===    L:1-100   P:0,2  M:1-9
    //[myTimer setFireDate:[NSDate distantFuture]];   //关闭定时器
    lighting = @"100";
    
    NSString *message = [[NSString alloc] initWithFormat:@"%@",[self NSString2Json:1]];
    
    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    //组接灯控指令
    [self saveLightCMD];
    
    NSLog(@"message : %@",message);
    [clientSocket sendData:cmdData toHost:UDP_IP port:UDP_PORT withTimeout:-1 tag:1];
}

- (IBAction)sendButtonPressedOffLight
{
    //[self connect];
    NSLog(@"发送关灯");
    //NSString *message = @"===,0,0,0,0,0,0,===";
    lighting = @"0";
    
    NSString *message = [[NSString alloc] initWithFormat:@"%@",[self NSString2Json:1]];
    
    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    //组接灯控指令
    [self saveLightCMD];
    
    NSLog(@"message : %@",message);
    [clientSocket sendData:cmdData toHost:UDP_IP port:UDP_PORT withTimeout:-1 tag:1];
}

/*- (void)updateLightBrightness:(id)sender
{
    //NSLog(@"brightness : %.0f",brightness.currentValue);
    NSString *message;
    float bright = brightness.currentValue;
    float brighta;
    if(bright > 100){
        brighta = 200 - bright;
    }else{
        brighta = bright;
    }
    lighting = [[NSString alloc] initWithFormat:@"%.0f",brighta];
    //NSLog(@"brighta : %.0f",brighta);
    
    //NSString *message = [[NSString alloc] initWithFormat:@"===,0,0,0,0,0,%@,===",lighting];
    
    if([model isEqualToString:@"8"]){
        message = [[NSString alloc] initWithFormat:@"===,0,%@,0,0,0,%@,===",model,lighting];
    }else{
        message = [[NSString alloc] initWithFormat:@"===,0,%@,%@,%@,%@,%@,===",model,red,green,blue,lighting];
    }
    NSLog(@"message: %@", message);
    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    //组接灯控指令
    [self saveLightCMD];
    
    //NSLog(@"cmdData : %@",cmdData);
    [clientSocket sendData:cmdData toHost:UDP_IP port:UDP_PORT withTimeout:-1 tag:1];
}*/

//控制杆调节
- (void)updateBrightness
{
    //NSLog(@"brightness : %.0f",brightness.currentValue);
    NSString *message;
    
    float brighta = switchslider.value;

    lighting = [[NSString alloc] initWithFormat:@"%.0f",brighta];
    //NSLog(@"brighta : %.0f",brighta);
    
    //NSString *message = [[NSString alloc] initWithFormat:@"===,0,0,0,0,0,%@,===",lighting];
    
    if([model isEqualToString:@"8"]){
        message = [[NSString alloc] initWithFormat:@"%@",[self NSString2Json:2]];
    }else{
        message = [[NSString alloc] initWithFormat:@"%@",[self NSString2Json:1]];
    }
    NSLog(@"message: %@", message);
    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    //组接灯控指令
    [self saveLightCMD];
    
    //NSLog(@"cmdData : %@",cmdData);
    [clientSocket sendData:cmdData toHost:UDP_IP port:UDP_PORT withTimeout:-1 tag:1];
}

//灯的颜色
- (void)updateLightColorRGB:(id)sender
{
    //NSLog(@"colorRGB : %.0f",colorRGB.value);
    //NSLog(@"colorRGB : %.0f",colorRGB.currentValue);
   
    UIColor *myColorHue = [[UIColor alloc] initWithHue:colorRGB.currentValue/360 saturation:1.0 brightness:1.0 alpha:1.0];
    //colorRGB.handleColor = myColorHue;
    //colorRGB.handleType = nullBigCircle;
    
    //valueRGB = [Tools changeUIColorToRGB:myColorHue];
    
    const CGFloat *components = CGColorGetComponents(myColorHue.CGColor);
    red = [[NSString alloc] initWithFormat:@"%.0f",components[0]*255];
    green = [[NSString alloc] initWithFormat:@"%.0f",components[1]*255];
    blue = [[NSString alloc] initWithFormat:@"%.0f",components[2]*255];
    
    //NSLog(@"UIColor: %@", myColorHue);
    //NSLog(@"Red: %@", red);
    //NSLog(@"Green: %@", green);
    //NSLog(@"Blue: %@", blue);
    
    //NSLog(@"model: %@", model);
    /*if([model isEqualToString:@"9"] || [model isEqualToString:@"3"]){
        modelc = [[NSString alloc] initWithFormat:@"%@",model];
    }else{
        modelc = [[NSString alloc] initWithFormat:@"%@",@"9"];
        model = [[NSString alloc] initWithFormat:@"%@",@"9"];
    }*/
    
    //NSString *message = [[NSString alloc] initWithFormat:@"===,0,%@,%@,%@,%@,%@,===",model,red,green,blue,lighting];
    NSString *message = [[NSString alloc] initWithFormat:@"%@",[self NSString2Json:1]];
    //组接灯控指令
    [self saveLightCMD];
    
    NSLog(@"message: %@", message);
    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"cmdData : %@",cmdData);
    [clientSocket sendData:cmdData toHost:UDP_IP port:UDP_PORT withTimeout:-1 tag:1];
    
}

- (void)connectHost:(NSString *)ip port:(NSUInteger)port
{
    if (![clientSocket isConnected])
    {
        //clientSocket = [[AsyncSocket alloc] initWithDelegate:self];
        
        NSError *errors = nil;
        [clientSocket connectToHost:ip onPort:port error:&errors];
        
        if (errors)
        {
            NSLog(@"connectToHost error %@",errors);
            //[clientSocket disconnect];
        }else{
            
            NSLog(@"connectToHost success");
            
        }

    }
}

+ (UIColor *)colorWithARGBHex:(UInt32)hex
{
    int b = hex & 0x000000FF;
    int g = ((hex & 0x0000FF00) >> 8);
    int r = ((hex & 0x00FF0000) >> 16);
    int a = ((hex & 0xFF000000) >> 24);
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:a / 255.f];
}

//pickerView
- (void)connect
{
    NSLog(@"ip,port : %@ : %d",UDP_IP,UDP_PORT);
    [self connectHost:UDP_IP port:UDP_PORT];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSUInteger)row forComponent:(NSUInteger)component; {
	NSMutableArray *strings = [NSMutableArray arrayWithCapacity:9];
    [strings addObject:@"Gray"];
	[strings addObject:@"More colors randomly"];
	[strings addObject:@"Flashing color"];
	[strings addObject:@"RGB colors"];
	[strings addObject:@"Red color"];
	[strings addObject:@"Blue color"];
    [strings addObject:@"Green color"];
    [strings addObject:@"White"];
    [strings addObject:@"Color"];
	return [strings objectAtIndex:(row%9)];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSUInteger)row inComponent:(NSUInteger)component {
	[self pickerViewLoaded:nil];
    model = [[NSString alloc] initWithFormat:@"%d",row+1];
    if([model isEqualToString:@"1"] || [model isEqualToString:@"2"] || [model isEqualToString:@"4"] || [model isEqualToString:@"5"] || [model isEqualToString:@"6"] || [model isEqualToString:@"7"] || [model isEqualToString:@"8"]){
        [colorRGB removeFromSuperview];
    }else{
        //[self.view addSubview:colorRGB];
        [self.view insertSubview:colorRGB atIndex:3];
    }
    
    /*if([model isEqualToString:@"3"] || [model isEqualToString:@"8"] || [model isEqualToString:@"9"])
    {
        [self.view addSubview:switchslider];
        
    }else{
        [switchslider removeFromSuperview];
    }*/
    NSString *message = [[NSString alloc] initWithFormat:@"%@",[self NSString2Json:1]];
    NSLog(@"message: %@", message);
    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"cmdData : %@",cmdData);
    
    //组接灯控指令
    [self saveLightCMD];
    
    [clientSocket sendData:cmdData toHost:UDP_IP port:UDP_PORT withTimeout:-1 tag:1];
    //NSLog(@"row : %d--%@",row,model);
}

- (NSUInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSUInteger)component {
	return 9;
}


-(void)pickerViewLoaded: (id)blah {
	//NSUInteger max = 9;
	//NSUInteger base10 = (max/2)-(max/2)%9;
	//[selectEffect selectRow:[selectEffect selectedRowInComponent:0]%9+base10 inComponent:0 animated:false];
}


- (NSUInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

#pragma mark - 长按录音
- (void)recordBtnLongPressed:(UILongPressGestureRecognizer*) longPressedRecognizer{
    //长按开始
    if(longPressedRecognizer.state == UIGestureRecognizerStateBegan) {
        
        [self recordStart];
        NSLog(@"recordStart");
    }//长按结束
    else if(longPressedRecognizer.state == UIGestureRecognizerStateEnded){
        //[self recordEnd];
        //NSLog(@"recordEnd");
        //[voice showVoiceHudOrHide:NO];
    }
}

//开始录音
-(void) recordStart
{
    isRes = YES;
    
    [speaker removeFromSuperview];
    [self.view insertSubview:speakerstop atIndex:98];

    
    [stopBtn setTitle:@"Stop" forState:UIControlStateNormal];
    sTime = [[NSString alloc] initWithFormat:@"%@",[Tools getTimeSp]];
    
    ledcmd = [[NSMutableArray alloc]init];
    
    nameFile = [self getCurrentTimeString];
    
    mp3Path = [[NSString alloc] initWithFormat:@"%@/Documents/%@.mp3", NSHomeDirectory(),nameFile];
    
    wavPath = [[NSString alloc] initWithFormat:@"%@/Documents/%@.wav", NSHomeDirectory(),nameFile];
    
    [voice startRecordWithPath:[NSString stringWithFormat:@"%@", wavPath]];

    
}

//停止录音
-(IBAction) recordEnd
{
    isRes = NO;
    
    [speakerstop removeFromSuperview];
    [self.view insertSubview:speaker atIndex:99];
    
    //[HUD show:YES];
    [stopBtn setTitle:@"Sent" forState:UIControlStateNormal];
    [voice stopRecordWithCompletionBlock:^{
        
        /*if (voice.recordTime > 0.0f) {
         UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"\nrecord finish ! \npath:%@ \nduration:%f",voice.recordPath,voice.recordTime] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
         [alert show];
         [alert release];
         }*/
        
    }];

}

//取消录音
-(IBAction) recordCancel
{
    [voice cancelled];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"取消了" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
    //[alert release];
    
}

//播放
-(IBAction) play
{
    
    player = [player initWithContentsOfURL:[NSURL URLWithString:wavPath] error:nil];
    NSString *size =[NSString stringWithFormat:@"%d", [self getFileSize:wavPath]/1024];
    //NSLog(@"ledcmd : %@",ledcmd);
    [player play];
    [self playcmdlight];
    NSLog(@"wav play size:%@ KB",size);
    
}

-(void)playcmdlight
{
    int counts = [ledcmd count];
    
    NSLog(@"ledcmd : %@", ledcmd);
    NSLog(@"ledcmd count:%d",[ledcmd count]);
    
    if(counts >0){
    for (int i = 0; i < counts; i++) {
        NSString *s1 = [NSString stringWithFormat:@"%@",[ledcmd objectAtIndex: i]];
        
        NSArray *a1 = [s1 componentsSeparatedByString:@"|"];
        
        NSString *m1 = [NSString stringWithFormat:@"%lld",[[a1 objectAtIndex: 0]longLongValue]/1000];
        NSString *m2 = [NSString stringWithFormat:@"%@",[a1 objectAtIndex: 1]];
        
        [NSTimer scheduledTimerWithTimeInterval:[m1 longLongValue] target:self selector:@selector(sendUDP:) userInfo:m2 repeats:NO];
        NSLog(@"playCMD time|cmd:%@|%@",m1,m2);
    }
    }
}

//保存灯控和声音的匹配
-(void)saveLightCMD
{
    if(isRes){
        long long sTimessp = [sTime longLongValue];
        
        NSString *nowTime = [[NSString alloc] initWithFormat:@"%@",[Tools getTimeSp]];
        
        long long nowTimessp = [nowTime longLongValue];
        
        long long ssssecond = nowTimessp - sTimessp;
        
        NSString *sssecond = [[NSString alloc] initWithFormat:@"%lld",ssssecond ];
        
        //NSString *hhmmss = [[NSString alloc] initWithFormat:@"%@",[self corTimehhmmss:sssecond]];

        NSString *msg =[[NSString alloc] initWithFormat:@"%@=%@\r\n",sssecond,[self NSString2Json:1]];
        
        NSString *msg2 =[[NSString alloc] initWithFormat:@"%@|%@;",sssecond,[self NSString2Json:1]];
        
        [cmdLight insertString:msg atIndex:[cmdLight length]];
        
        [ledcmd addObject:msg2];
        NSLog(@"saveLightCMD2 : %@", cmdLight);
    }
}

//发送数据到服务器
- (void)sendFiles{
    
    //NSString *postdata = [NSString stringWithFormat:@"===,0,%@,%@,%@,%@,%@,===",model,red,green,blue,lighting];
    //NetWorkHttp *reshttp = [[NetWorkHttp alloc]init];
    [NetWorkHttp httpPost:@"soundupfile" Postdata:cmdLight Files:mp3Path];
    cmdLight = [[NSMutableString alloc]initWithString:@""];
    
}

- (void)sendUDP:(NSString *)msg
{
    NSLog(@"sendUDP");
    NSData *cmdData = [[msg userInfo] dataUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"message : %@",[msg userInfo]);
    [clientSocket sendData:cmdData toHost:UDP_IP port:UDP_PORT withTimeout:-1 tag:1];
}

- (void)sendtest
{
    NSLog(@"sendtest");
}

#pragma mark - 获取文件大小
- (NSInteger) getFileSize:(NSString*) path{
    NSFileManager * filemanager = [[NSFileManager alloc]init];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue];
        else
            return -1;
    }
    else{
        return -1;
    }
}

/**
 生成当前时间字符串
 @returns 当前时间字符串
 */
- (NSString *)getCurrentTimeString
{
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}

/**
 生成当前时间字符串
 @returns 当前时间字符串
 */
- (NSString *)getTimeString
{
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateformat stringFromDate:[NSDate date]];
}

- (NSString *)getTimemiaoString
{
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateformat stringFromDate:[NSDate date]];
}

//秒转hhmmss
- (NSString *)corTimehhmmss:(NSString *)intime
{
    long long intimelong = [intime longLongValue];
    
    long long hh = floor(intimelong/3600);
    
    long long mm = floor(intimelong%3600/60);
    
    long long ss = intimelong%3600%60;
    NSLog(@"hh:%02lld  mm:%02lld  ss:%02lld",hh,mm,ss);
    
    NSString *hhmmmss = [[NSString alloc] initWithFormat:@"%02lld:%02lld:%02lld",hh,mm,ss];
    return hhmmmss;
}


-(void) doClickedBack
{
    //tabbar显示
    [Tools showTabBar:self.tabBarController];
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"showTabBar");
}
@end
