//
//  DetailLightViewController.m
//  Belled
//
//  Created by Bellnet on 14-4-25.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "DetailLightViewController.h"

@interface DetailLightViewController ()

@end

@implementation DetailLightViewController
{
    AsyncUdpSocket *clientSocket;
    EFCircularSlider *colorRGB;
    EFCircularSlider *brightness;
    NSMutableArray *valueRGB;
}
@synthesize  snlab,modellab,sn,model;

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
    //[self snlab];
    //[self modellab];
    snlab.text = sn;
    modellab.text = model;
    
    clientSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    
    //彩色
    CGRect sliderFrame = CGRectMake(35, 90, 250, 250);
    colorRGB = [[EFCircularSlider alloc] initWithFrame:sliderFrame];
    colorRGB.minimumValue = 1;
    colorRGB.maximumValue = 360;
    colorRGB.lineWidth = 0;
    
    //colorRGB.unfilledColor = [[UIColor alloc] initWithRed:9/255.0f green:136/255.0f blue:201/255.0f alpha:1.0f];
    //colorRGB.filledColor = [[UIColor alloc] initWithRed:9/255.0f green:136/255.0f blue:201/255.0f alpha:1.0f];
    colorRGB.handleType = nullBigCircle;
    colorRGB.handleColor = [[UIColor alloc] initWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    [self.view addSubview:colorRGB];
    [colorRGB addTarget:self action:@selector(updateLightColorRGB:) forControlEvents:UIControlEventValueChanged];
    
    //明暗
    CGRect sliderFrame2 = CGRectMake(85, 140, 150, 150);
    brightness = [[EFCircularSlider alloc] initWithFrame:sliderFrame2];
    brightness.minimumValue = 1;
    brightness.maximumValue = 200;
    brightness.lineWidth = 10;
    brightness.unfilledColor = [[UIColor alloc] initWithRed:155/255.0f green:155/255.0f blue:155/255.0f alpha:1.0f];
    brightness.filledColor = [[UIColor alloc] initWithRed:155/255.0f green:155/255.0f blue:155/255.0f alpha:1.0f];
    brightness.handleType = bigCircle;
    brightness.handleColor = [[UIColor alloc] initWithRed:255/255.0f green:200/255.0f blue:0/255.0f alpha:1.0f];
    [self.view addSubview:brightness];
    
    [brightness addTarget:self action:@selector(updateLightBrightness:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view.
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
- (IBAction)sendButtonPressedOnLight:(id)sender
{
    //[self connect];
    NSLog(@"发送开灯");
    NSString *message = @"===,0,0,0,0,255,===";
    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"cmdData : %@",cmdData);
    [clientSocket sendData:cmdData toHost:UDP_IP port:UDP_PORT withTimeout:-1 tag:1];
}

- (IBAction)sendButtonPressedOffLight:(id)sender
{
    //[self connect];
    NSLog(@"发送关灯");
    NSString *message = @"===,0,0,0,0,0,===";
    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"cmdData : %@",cmdData);
    [clientSocket sendData:cmdData toHost:UDP_IP port:UDP_PORT withTimeout:-1 tag:1];
}

- (void)updateLightBrightness:(id)sender
{
    NSLog(@"brightness : %.0f",brightness.currentValue);
    float bright = brightness.currentValue;
    float brighta;
    if(bright > 100){
        brighta = 200 - bright;
    }else{
        brighta = bright;
    }
    NSLog(@"brighta : %.0f",brighta);
    NSString *message = [NSString stringWithFormat:@"===,0,0,0,0,%.0f,===",brighta];
    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"cmdData : %@",cmdData);
    [clientSocket sendData:cmdData toHost:UDP_IP port:UDP_PORT withTimeout:-1 tag:1];
}

- (void)updateLightColorRGB:(id)sender
{
    //NSLog(@"colorRGB : %.0f",colorRGB.value);
    NSLog(@"colorRGB : %.0f",colorRGB.currentValue);
    
    UIColor *myColorHue = [[UIColor alloc] initWithHue:colorRGB.currentValue/360 saturation:1.0 brightness:1.0 alpha:1.0];
    //colorRGB.handleColor = myColorHue;
    //colorRGB.handleType = nullBigCircle;
    
    //valueRGB = [Tools changeUIColorToRGB:myColorHue];
    
    const CGFloat *components = CGColorGetComponents(myColorHue.CGColor);
    NSString *red = [NSString stringWithFormat:@"%.0f",components[0]*255];
    NSString *green = [NSString stringWithFormat:@"%.0f",components[1]*255];
    NSString *blue = [NSString stringWithFormat:@"%.0f",components[2]*255];
    
    NSLog(@"UIColor: %@", myColorHue);
    NSLog(@"Red: %@", red);
    NSLog(@"Green: %@", green);
    NSLog(@"Blue: %@", blue);
    
    NSString *message = [NSString stringWithFormat:@"===,0,%@,%@,%@,0,===",red,green,blue];
    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"cmdData : %@",cmdData);
    [clientSocket sendData:cmdData toHost:UDP_IP port:UDP_PORT withTimeout:-1 tag:1];
    
}

@end
