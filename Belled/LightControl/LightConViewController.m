//
//  HomeViewController.m
//  Belled
//
//  Created by Bellnet on 14-4-18.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "LightConViewController.h"

@interface LightConViewController ()

@end

@implementation LightConViewController

{
    NSMutableArray *rgbS;
    AsyncUdpSocket *clientSocket;
    NSMutableArray *datasource;
    AsyncUdpSocket *udpSocket;
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
    NSString *iswitch;
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
    UIButton                *speakerstop;   //录音停止按钮
    NSMutableArray          *ledcmd;        //录音回放的控制指令
    
    UITabBar                *tabbars;
    UIBarButtonItem         *rButton;      //右边按钮
    
    NSString                *devip;
    NSTimer                 *timer;
    NSMutableDictionary     *res_dictionary;
    NSMutableArray          *datalightlist;
    
    NSMutableDictionary     *itemLight1;
    NSMutableDictionary     *itemLight2;
    NSMutableDictionary     *itemLight3;
    NSInteger               lightrows;
    BOOL                    lightlock;
    float brighta;
}

@synthesize  sn,model,contrlType,wanip,groupid,scenetype,toolbar,tabBarItem1;
@synthesize  selectEffect,switchslider,stopBtn,colorRGBr;

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
    [self creatTabBar];
    [self openUDPServer];
    datasource = [[NSMutableArray alloc] init];
    res_dictionary = [[NSMutableDictionary alloc] init];
    
    itemLight1 = [[NSMutableDictionary alloc] init];
    itemLight2 = [[NSMutableDictionary alloc] init];
    itemLight3 = [[NSMutableDictionary alloc] init];
    lightlock = YES;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(sendUDP) userInfo:nil repeats:YES];
    
    [self.view insertSubview:colorRGBr atIndex:1];
    firsttime = 0;
    
    isRes = NO;
    if([contrlType isEqualToString:@"3"]){
    iswitch = [[NSString alloc] initWithFormat:@"%@",@"1"];
    }else{
    iswitch = [[NSString alloc] initWithFormat:@"%@",@"0"];
    }
    NSLog(@"iswitch:%@",iswitch);
    if([scenetype isEqualToString:@"group"]){
       
    }else{
     groupid = [[NSString alloc]initWithFormat:@"%@",@"null" ];
    }

    model = [[NSString alloc] initWithFormat:@"%@",@"9"];
    modelc= [[NSString alloc] initWithFormat:@"%@",@"9"];
    red= [[NSString alloc] initWithFormat:@"%@",@"128"];
    green= [[NSString alloc] initWithFormat:@"%@",@"0"];
    blue= [[NSString alloc] initWithFormat:@"%@",@"0"];
    lighting= [[NSString alloc] initWithFormat:@"%@",@"50"];
    brighta = 50.0;
    
    UIImage* img1=[UIImage imageNamed:@"set.png"];
    UIBarButtonItem *cButton = [[UIBarButtonItem alloc] //initWithTitle:@"Back"
                                initWithImage:img1
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(doClickedBack)];
    
    self.navigationItem.leftBarButtonItem = cButton;

    
    
    rButton = [[UIBarButtonItem alloc] initWithTitle:@"White"
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:@selector(doClicked1)];
    
    self.navigationItem.rightBarButtonItem = rButton;
    self.navigationItem.title = [NSString stringWithFormat:@"%@",VERSION];
    
    //彩色盘
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
    [self.view addSubview:colorRGB];
    
    [colorRGB addTarget:self action:@selector(updateLightColorRGB:) forControlEvents:UIControlEventValueChanged];
    
    
    //关灯图片
    speaker = [[UIButton alloc] initWithFrame:CGRectMake(104, 136, 110, 110)];
    [speaker setBackgroundImage:[UIImage imageNamed:@"off@2x.png"] forState:UIControlStateNormal];
    if([contrlType isEqualToString:@"3"]){
    
    }else{
    [self.view insertSubview:speaker atIndex:99];
    }
    
    //开灯图片
    speakerstop = [[UIButton alloc] initWithFrame:CGRectMake(104, 136, 110, 110)];
    [speakerstop setBackgroundImage:[UIImage imageNamed:@"on@2x.png"] forState:UIControlStateNormal];
    if([contrlType isEqualToString:@"3"]){
        [self.view insertSubview:speakerstop atIndex:98];
    }

    
    [speaker addTarget:self action:@selector(sendButtonPressedOnLight) forControlEvents:UIControlEventTouchDown];
    
    [speakerstop addTarget:self action:@selector(sendButtonPressedOffLight) forControlEvents:UIControlEventTouchDown];
    
    [switchslider addTarget:self action:@selector(updateBrightness) forControlEvents:UIControlEventValueChanged];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    [self.view addSubview:HUD];

}

-(void)creatTabBar{
    
    NSInteger viewsize;
    if(DEVICE_IS_IPHONE5){
        viewsize = 519;
    }else{
        viewsize = 431;
    }
    
    tabbars = [[UITabBar alloc] initWithFrame:CGRectMake(0,viewsize,320,30)];
    [self.view addSubview:tabbars];
    
    [tabbars setDelegate:self];
    
    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"ALL" image:[UIImage imageNamed:@"light.png"] tag:0];
    UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"LIGHT A" image:[UIImage imageNamed:@"light.png"] tag:1];
    UITabBarItem *tabBarItem3 = [[UITabBarItem alloc] initWithTitle:@"LIGHT B" image:[UIImage imageNamed:@"light.png"] tag:2];
    UITabBarItem *tabBarItem4 = [[UITabBarItem alloc] initWithTitle:@"LIGHT C" image:[UIImage imageNamed:@"light.png"] tag:3];
    NSArray *tabBarItemArray = [[NSArray alloc] initWithObjects:tabBarItem1,tabBarItem2, tabBarItem3,tabBarItem4,nil];
    [tabbars setItems: tabBarItemArray];
}

-(void)showTabBarP
{
    NSInteger viewsize;
    if(DEVICE_IS_IPHONE5){
        viewsize = 519;
    }else{
        viewsize = 431;
    }
    [toolbar setFrame:CGRectMake(0, 300, toolbar.frame.size.width, toolbar.frame.size.height)];
    [self.view addSubview:toolbar];
}

#pragma mark -- UITabBarDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)Item{
    if (Item.tag == 0) {
        [self tabBarItem1click];
    }else if(Item.tag == 1){
        [self tabBarItem2click];
    }else if(Item.tag == 2){
        [self tabBarItem3click];
    }else if(Item.tag == 3){
        [self tabBarItem4click];
    }
}

-(void)tabBarItem1click
{
    NSLog(@"tabBarItem1");
    sn = @"zzzzzzzzzzzzzzzz";
    self.navigationItem.title = [NSString stringWithFormat:@"ALL Light"];
}

-(void)tabBarItem2click
{
    NSLog(@"tabBarItem2");
    if(lightrows >= 1){
    sn = [itemLight1 objectForKey:@"sn"];
    self.navigationItem.title = [NSString stringWithFormat:@"%@",sn];
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"%@",@"None Light"];
    }
}

-(void)tabBarItem3click
{
    NSLog(@"tabBarItem3");
    if(lightrows >= 2){
    sn = [itemLight2 objectForKey:@"sn"];
    self.navigationItem.title = [NSString stringWithFormat:@"%@",sn];
    }else{
        self.navigationItem.title = [NSString stringWithFormat:@"%@",@"None Light"];
    }
}

-(void)tabBarItem4click
{
    NSLog(@"tabBarItem4");
    if(lightrows == 3){
    sn = [itemLight3 objectForKey:@"sn"];
    self.navigationItem.title = [NSString stringWithFormat:@"%@",sn];
    }else{
    self.navigationItem.title = [NSString stringWithFormat:@"%@",@"None Light"];
    }
}

-(void)doClicked1
{
    if([model isEqualToString:@"8"]){
        model = [[NSString alloc] initWithFormat:@"%@",@"9"];
        [rButton setTitle:@"White"];
    }else{
        model = [[NSString alloc] initWithFormat:@"%@",@"8"];
        [rButton setTitle:@"Color"];
    }
    
    if([model isEqualToString:@"8"]){
        [colorRGB removeFromSuperview];
    }else{
        [self.view insertSubview:colorRGB atIndex:3];
    }
    
    NSString *message = [[NSString alloc] initWithFormat:@"%@",[self NSString2Json:1]];
    [self sendSearchBroadcast:message tag:5];
}

- (void)switchChanged:(UISwitch *)sender
{
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


-(NSString *)NSString2Json:(int)value
{
    NSMutableDictionary *device = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *snLight = [[NSMutableDictionary alloc] init];
    snLight = [[NSMutableDictionary alloc] initWithObjectsAndKeys:sn,@"sn",nil];
    NSArray *arraysnLight = [[NSArray alloc] initWithObjects:snLight,nil];
    
    switch (value) {
        case 1:
            //封装mutableDictionary
            device = [[NSMutableDictionary alloc] initWithObjectsAndKeys:arraysnLight,@"sn_list",@"5",@"model",model,@"effect",@"0",@"matchValue",red,@"r",green,@"g",blue,@"b",lighting,@"bright",iswitch,@"iswitch",@"light_ctrl",@"cmd",nil];
            break;
            
        case 2:
            //封装mutableDictionary
            device = [[NSMutableDictionary alloc] initWithObjectsAndKeys:arraysnLight,@"sn_list",@"5",@"model",model,@"effect",@"0",@"matchValue",@"0",@"r",@"0",@"g",@"0",@"b",lighting,@"bright",iswitch,@"iswitch",@"light_ctrl",@"cmd",nil];
            break;
            
        default:
            //封装mutableDictionary
            device = [[NSMutableDictionary alloc] initWithObjectsAndKeys:arraysnLight,@"sn_list",@"5",@"model",model,@"effect",@"0",@"matchValue",red,@"r",green,@"g",blue,@"b",lighting,@"bright",iswitch,@"iswitch",@"light_ctrl",@"cmd",nil];
            break;
    }
    
    //NSLog(@"device指令：%@",device);
    NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:device];
    //NSLog(@"data指令：%@",data);
    return data;
  
}

-(void)NSStringFormt
{

    //封装mutableDictionary
    NSString *data = [[NSString alloc] initWithFormat:@"%@,%@:%@:%@,%@",iswitch,red,green,blue,lighting];
    
    GlobalSet *gt = [GlobalSet bellSetting];
    gt.alarmLight = data;
    gt.alarmLight_switch = iswitch;
    gt.alarmLight_red = red;
    gt.alarmLight_green = green;
    gt.alarmLight_blue = blue;
    gt.alarmLight_bright = lighting;
    
}

- (void)sendButtonPressedOnLight
{
    //[self connect];
    NSLog(@"发送开灯");
    [speaker removeFromSuperview];
    [self.view insertSubview:speakerstop atIndex:98];
    iswitch = @"1";
    NSString *message = [[NSString alloc] initWithFormat:@"%@",[self NSString2Json:1]];
    [self sendSearchBroadcast:message tag:1];
    
}

- (void)sendButtonPressedOffLight
{
    //[self connect];
    NSLog(@"发送关灯");
    [speakerstop removeFromSuperview];
    [self.view insertSubview:speaker atIndex:99];
    iswitch = @"0";
    NSString *message = [[NSString alloc] initWithFormat:@"%@",[self NSString2Json:1]];
    [self sendSearchBroadcast:message tag:2];
}


//控制杆调节
- (void)updateBrightness
{
    NSString *message;
    
    brighta = switchslider.value;

    lighting = [[NSString alloc] initWithFormat:@"%.0f",brighta];
    
    UIColor *myColorHue = [[UIColor alloc] initWithHue:colorRGB.currentValue/360 saturation:1.0 brightness:brighta/120 alpha:1.0];
    NSLog(@"亮度 %f",brighta/120);
    const CGFloat *components = CGColorGetComponents(myColorHue.CGColor);
    red = [[NSString alloc] initWithFormat:@"%.0f",components[0]*255];
    green = [[NSString alloc] initWithFormat:@"%.0f",components[1]*255];
    blue = [[NSString alloc] initWithFormat:@"%.0f",components[2]*255];
    
    NSString *rgbV = [[NSString alloc] initWithFormat:@"%@|%@|%@",red,green,blue];
    NSLog(@"带亮度的RGB %@",rgbV);
    if([model isEqualToString:@"8"]){
        message = [[NSString alloc] initWithFormat:@"%@",[self NSString2Json:2]];
    }else{
        message = [[NSString alloc] initWithFormat:@"%@",[self NSString2Json:1]];
    }
    [self sendSearchBroadcast:message tag:2];
}

//灯的颜色
- (void)updateLightColorRGB:(id)sender
{
   
    UIColor *myColorHue = [[UIColor alloc] initWithHue:colorRGB.currentValue/360 saturation:1.0 brightness:brighta/120 alpha:1.0];
    NSLog(@"色相：%.0f  亮度：%.0f 开关：%@",colorRGB.currentValue,brighta,iswitch);
    const CGFloat *components = CGColorGetComponents(myColorHue.CGColor);
    red = [[NSString alloc] initWithFormat:@"%.0f",components[0]*255];
    green = [[NSString alloc] initWithFormat:@"%.0f",components[1]*255];
    blue = [[NSString alloc] initWithFormat:@"%.0f",components[2]*255];
    
    NSString *message = [[NSString alloc] initWithFormat:@"%@",[self NSString2Json:1]];
    [self sendSearchBroadcast:message tag:3];
    [message release];

}

- (void)connectHost:(NSString *)ip port:(NSUInteger)port
{
    if (![clientSocket isConnected])
    {

        
        NSError *errors = nil;
        [clientSocket connectToHost:ip onPort:port error:&errors];
        
        if (errors)
        {
            NSLog(@"connectToHost error %@",errors);
  
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
	NSMutableArray *strings = [NSMutableArray arrayWithCapacity:2];
    [strings addObject:@"Color"];
    [strings addObject:@"White"];
    /*[strings addObject:@"Green color"];
    [strings addObject:@"Blue color"];
    [strings addObject:@"Red color"];
    [strings addObject:@"RGB colors"];
    [strings addObject:@"Flashing color"];
    [strings addObject:@"More colors randomly"];
    [strings addObject:@"Gray"];*/

	return [strings objectAtIndex:(row%2)];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSUInteger)row inComponent:(NSUInteger)component {
	
    [self pickerViewLoaded:nil];
    
    model = [[NSString alloc] initWithFormat:@"%d",9-row];
    if([model isEqualToString:@"1"] || [model isEqualToString:@"2"] || [model isEqualToString:@"4"] || [model isEqualToString:@"5"] || [model isEqualToString:@"6"] || [model isEqualToString:@"7"] || [model isEqualToString:@"8"]){
        [colorRGB removeFromSuperview];
    }else{
        [self.view insertSubview:colorRGB atIndex:3];
    }
   
    NSString *message = [[NSString alloc] initWithFormat:@"%@",[self NSString2Json:1]];
    [self sendSearchBroadcast:message tag:5];
}

- (NSUInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSUInteger)component {
	return 2;
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
    [voice stopRecordWithCompletionBlock:^{}];

}

//取消录音
-(IBAction) recordCancel
{
    [voice cancelled];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"取消了" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    
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
        //NSLog(@"saveLightCMD2 : %@", cmdLight);
    }
}

//发送数据到服务器
- (void)sendFiles{
    
    [NetWorkHttp httpPost:@"soundupfile" Postdata:cmdLight Files:mp3Path];
    cmdLight = [[NSMutableString alloc]initWithString:@""];
    
}

- (void)sendtest
{
    NSLog(@"sendtest");
}

#pragma mark - 获取文件大小
- (NSInteger) getFileSize:(NSString*) path{
    NSFileManager * filemanager = [[[NSFileManager alloc]init] autorelease];
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
    NSDateFormatter *dateformat=[[[NSDateFormatter  alloc]init]autorelease];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}

/**
 生成当前时间字符串
 @returns 当前时间字符串
 */
- (NSString *)getTimeString
{
    NSDateFormatter *dateformat=[[[NSDateFormatter  alloc]init]autorelease];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateformat stringFromDate:[NSDate date]];
}

- (NSString *)getTimemiaoString
{
    NSDateFormatter *dateformat=[[[NSDateFormatter  alloc]init]autorelease];
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
    WebViewViewController *tmpEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"set_webView"];
    tmpEdit.wanip = devip;
    [self.navigationController pushViewController:tmpEdit animated:YES];
}

-(void)sendSearchBroadcast:(NSString*) msg tag:(long)tag{
    [self sendToUDPServer:msg address:devip port:UDP_PORT tag:tag];
}

-(void)sendToUDPServer:(NSString*) msg address:(NSString*)address port:(int)port tag:(long)tag{
    
    udpSocket=[[[AsyncUdpSocket alloc]initWithDelegate:self] autorelease];
    NSLog(@"address:%@,port:%d,msg:%@",address,port,msg);
    //receiveWithTimeout is necessary or you won't receive anything
    [udpSocket receiveWithTimeout:10 tag:tag]; //设置超时10秒
    [udpSocket enableBroadcast:YES error:nil]; //如果你发送广播，这里必须先enableBroadcast
    NSData *data=[msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:address port:port withTimeout:10 tag:tag];//发送udp
}

-(NSMutableArray *)rgbSoure{
    NSMutableArray *rgbSp = [[NSMutableArray alloc]init];
    rgbSp = [NSMutableArray arrayWithObjects:@"222|0|33",@"219|0|36",@"216|0|39",@"213|0|42",@"210|0|45",@"207|0|48",@"204|0|51",@"201|0|54",@"198|0|57",@"195|0|60",@"192|0|63",@"189|0|66",@"186|0|69",@"183|0|72",@"180|0|75",@"177|0|78",@"174|0|81",@"171|0|84",@"168|0|87",@"165|0|90",@"162|0|93",@"159|0|96",@"156|0|99",@"153|0|102",@"150|0|105",@"147|0|108",@"144|0|111",@"141|0|114",@"138|0|117",@"135|0|120",@"132|0|123",@"129|0|126",@"126|0|129",@"123|0|132",@"120|0|135",@"117|0|138",@"114|0|141",@"111|0|144",@"108|0|147",@"105|0|150",@"102|0|153",@"99|0|156",@"96|0|159",@"93|0|162",@"90|0|165",@"87|0|168",@"84|0|171",@"81|0|174",@"78|0|177",@"75|0|180",@"72|0|183",@"69|0|186",@"66|0|189",@"63|0|192",@"60|0|195",@"57|0|198",@"54|0|201",@"51|0|204",@"48|0|207",@"45|0|210",@"42|0|213",@"39|0|216",@"36|0|219",@"33|0|222",@"30|0|225",@"27|0|228",@"24|0|231",@"21|0|234",@"18|0|237",@"15|0|240",@"12|0|243",@"9|0|246",@"6|0|249",@"3|0|252",@"0|0|255",@"0|3|252",@"0|6|249",@"0|9|246",@"0|12|243",@"0|15|240",@"0|18|237",@"0|21|234",@"0|24|231",@"0|27|228",@"0|30|225",@"0|33|222",@"0|36|219",@"0|39|216",@"0|42|213",@"0|45|210",@"0|48|207",@"0|51|204",@"0|54|201",@"0|57|198",@"0|60|195",@"0|63|192",@"0|66|189",@"0|69|186",@"0|72|183",@"0|75|180",@"0|78|177",@"0|81|174",@"0|84|171",@"0|87|168",@"0|90|165",@"0|93|162",@"0|96|159",@"0|99|156",@"0|102|153",@"0|105|150",@"0|108|147",@"0|111|144",@"0|114|141",@"0|117|138",@"0|120|135",@"0|123|132",@"0|126|129",@"0|129|126",@"0|132|123",@"0|135|120",@"0|138|117",@"0|141|114",@"0|144|111",@"0|147|108",@"0|150|105",@"0|153|102",@"0|156|99",@"0|159|96",@"0|162|93",@"0|165|90",@"0|168|87",@"0|171|84",@"0|174|81",@"0|177|78",@"0|180|75",@"0|183|72",@"0|186|69",@"0|189|66",@"0|192|63",@"0|195|60",@"0|198|57",@"0|201|54",@"0|204|51",@"0|207|48",@"0|210|45",@"0|213|42",@"0|216|39",@"0|219|36",@"0|222|33",@"0|225|30",@"0|228|27",@"0|231|24",@"0|234|21",@"0|237|18",@"0|240|15",@"0|243|12",@"0|246|9",@"0|249|6",@"0|252|3",nil];
    return rgbSp;
}

- (BOOL)findStrForArray_rgb:(NSString *)theName
{
    bool is;
    NSMutableArray *rgbSp = [[NSMutableArray alloc]init];
    
    rgbSp = [self rgbSoure];
    for(NSString *string in rgbSp){
        NSLog(@"%@",theName);
        if([string isEqualToString:theName])
        {
            is = YES;
            break;
        }else{
            is = NO;
        }
        
    }
    return is;
}


- (NSString *)findIndexForArray:(int)ints
{
    NSMutableArray *rgbSp = [[NSMutableArray alloc]init];
    rgbSp = [self rgbSoure];
    NSString *str = [[NSString alloc] init];
    str = [rgbSp objectAtIndex:ints];
    return str;
}

-(void)openUDPServer
{
    //初始化udp
    clientSocket=[[AsyncUdpSocket alloc] initWithDelegate:self];
    
    //绑定端口
    NSError *error = nil;
    [clientSocket bindToPort:BRO_PORT error:&error];
    
    //发送广播设置
    [clientSocket enableBroadcast:YES error:&error];
    
    //加入群里，能接收到群里其他客户端的消息
    [clientSocket joinMulticastGroup:BRO_IP error:&error];
    
   	//启动接收线程
    [clientSocket receiveWithTimeout:-1 tag:0];
}

-(NSArray *)jiexiData:(NSString *)str
{
    NSCharacterSet *characterSet1 = [NSCharacterSet characterSetWithCharactersInString:@","];
    NSArray *array1 = [str componentsSeparatedByCharactersInSet:characterSet1];
    return array1;
}

-(void)comperData:(NSString *)str
{
    NSArray *array1 = [self jiexiData:str];
    NSString *cmd = [[NSString alloc] init];
    cmd = [array1 objectAtIndex:0];
    
    NSString *dev_sn = [[NSString alloc] init];
    dev_sn = [array1 objectAtIndex:1];
    
    NSString *dev_ip = [[NSString alloc] init];
    dev_ip = [array1 objectAtIndex:2];
    
    NSString *dev_iswitch = [[NSString alloc] init];
    if([array1 count] > 3){
        dev_iswitch = [array1 objectAtIndex:3];
    }else{
        dev_iswitch = @"1";
    }
    
    if([cmd isEqualToString:@"belled"]){
        
        NSMutableDictionary *device = [[NSMutableDictionary alloc] init];
        device = [[NSMutableDictionary alloc] initWithObjectsAndKeys:dev_sn,@"sn",dev_ip,@"ip",dev_iswitch,@"iswitch",nil];
        if([self findStrForArray:dev_sn]){
            if([datasource count]==0){
                [datasource addObject:device];
            }else{
                NSInteger dev_row = [self indexForArray:dev_sn];
                NSMutableDictionary *deviceitem = [[NSMutableDictionary alloc] init];
                deviceitem = [[NSMutableDictionary alloc] initWithObjectsAndKeys:dev_sn,@"sn",dev_ip,@"ip",dev_iswitch,@"iswitch",nil];
                //NSLog(@"%d  %@",row,deviceitem);
                [datasource replaceObjectAtIndex:dev_row withObject:deviceitem];
            }
        }else{
            [datasource addObject:device];
        }
        
        NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
        datarow = [datasource objectAtIndex:0];
        NSLog(@"datasource 0 %@",datarow);
        devip = [datarow objectForKey:@"ip"];
        [clientSocket close];
        [timer invalidate];
        [self lightList_local];
        
    }
    
}

-(BOOL)findStrForArray:(NSString *)theName
{
    bool is;
    int m = [datasource count];
    for(int i=0;i<m;i++ ){
        NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
        datarow = [datasource objectAtIndex:i];
        NSString *dev_sn = [[NSString alloc]init];
        NSString *dev_ip = [[NSString alloc]init];
        dev_sn = [NSString stringWithFormat:@"%@",[datarow objectForKey:@"sn"]];
        dev_ip = [NSString stringWithFormat:@"%@",[datarow objectForKey:@"ip"]];
        if([dev_sn isEqualToString:theName])
        {
            is = YES;
            break;
        }else{
            is = NO;
        }
        
    }
    
    return is;
}



- (NSInteger)indexForArray:(NSString *)theName
{
    NSInteger is = 0;
    int m = [datasource count];
    for(int i=0;i < m;i++ ){
        NSMutableDictionary *datarow = [[NSMutableDictionary alloc] init];
        datarow = [datasource objectAtIndex:i];
        NSString *dev_sn = [[NSString alloc]init];
        dev_sn = [NSString stringWithFormat:@"%@",[datarow objectForKey:@"sn"]];
        if([dev_sn isEqualToString:theName])
        {
            is = i;
            break;
        }
        
    }
    
    return is;
}

-(void)lightList_local
{
    [self sendSearchBroadcast:@"{\"cmd\":\"light_list\"}" tag:1];
}

-(void)sendUDP
{
    [self sendSearchBroadcast_locol:@"{\"cmd\":\"ping\"}" tag:1];
}

-(void)sendSearchBroadcast_locol:(NSString*) msg tag:(long)tag{
    [self sendToUDPServer:msg address:WAN_IP port:UDP_PORT tag:tag];
}

//下面是发送的相关回调函数
-(BOOL) onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSString * info=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if([datasource count] > 0){
        if(lightlock){
        res_dictionary = [NetWorkHttp httpjsonParser:info];
        datalightlist = [[NSMutableArray alloc] init];
        datalightlist = [res_dictionary objectForKey:@"led"];
        lightrows = [datalightlist count];
        if(lightrows >= 1){
        itemLight1 = [datalightlist objectAtIndex:0];
        }
        
        if(lightrows >= 2){
        itemLight2 = [datalightlist objectAtIndex:1];
        }
        
        if(lightrows >= 3){
        itemLight3 = [datalightlist objectAtIndex:2];
        }
        NSLog(@"LightList---%@",datalightlist);
        lightlock = NO;
        }
    }else{
        [self comperData:info];
    }
    NSLog(@"组播消息---%@",info);
    //[clientSocket receiveWithTimeout:-1 tag:0];
    return YES;
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"didNotSendDataWithTag----%ld---%@",tag,error);
}
-(void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"didNotReceiveDataWithTag----%ld---%@",tag,error);
}
-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
    NSLog(@"didSendDataWithTag----%ld",tag);
}
-(void)onUdpSocketDidClose:(AsyncUdpSocket *)sock{
    NSLog(@"onUdpSocketDidClose----");
}


@end
