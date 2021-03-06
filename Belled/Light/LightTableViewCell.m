//
//  LightTableViewCell.m
//  Belled
//
//  Created by Bellnet on 14-4-25.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "LightTableViewCell.h"

@implementation LightTableViewCell
{
    MBProgressHUD *HUD;
}
@synthesize  sn,model,iswitch,red,green,blue,bright,iswitch_value,effect,model_value,devicesn,wanip,typeCtrl,syncCtrl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(uiswitchon) userInfo:nil repeats:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)uiswitchon
{
    NSLog(@"iswitch_value - - %@",iswitch_value);
    if([iswitch_value isEqualToString:@"1"]){
        iswitch.on = YES;
    }else{
        iswitch.on = NO;
    }
}

- (IBAction)switchChanged:(UISwitch *)sender
{
    // When using GPUImage, put [self.videoCamera rotateCamera]; here,
    // Otherwise do:
    if([typeCtrl isEqualToString:@"in"]){
        if (sender.on) {
            if([syncCtrl isEqualToString:@"sync"]){
                [self setgroup_udp];
            }else{
                [self sendSearchBroadcast:[self NSString2Json:@"1"] tag:1];
            }
        } else {
            if([syncCtrl isEqualToString:@"sync"]){
                [self leavegroup_udp];
            }else{
                [self sendSearchBroadcast:[self NSString2Json:@"0"] tag:1];
            }
            
        }
    }else{
        if (sender.on) {
            [self sendButtonPressedOnLight];
        } else {
            [self sendButtonPressedOffLight];
        }
    }
}

- (void)sendButtonPressedOnLight
{
    NSLog(@"发送开灯");
    [self onoffSwitch:[self NSString2Json:@"1"]];
}

- (void)sendButtonPressedOffLight
{
    NSLog(@"发送关灯");
    [self onoffSwitch:[self NSString2Json:@"0"]];
}


-(NSString *)NSString2Json:(NSString *)iswitch_onoff
{
    NSMutableDictionary *device = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *snLight = [[NSMutableDictionary alloc] init];
    snLight = [[NSMutableDictionary alloc] initWithObjectsAndKeys:model.text,@"sn",nil];
    NSArray *arraysnLight = [[NSArray alloc] initWithObjects:snLight,nil];
    
    //封装mutableDictionary
    device = [[NSMutableDictionary alloc] initWithObjectsAndKeys:arraysnLight,@"sn_list",@"5",@"model",effect,@"effect",@"0",@"matchValue",red,@"r",green,@"g",blue,@"b",bright,@"bright",iswitch_onoff,@"iswitch",@"light_ctrl",@"cmd",nil];
    
    NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:device];
    NSLog(@"data--%@",device);
    return data;
}

-(NSString *)NSString2JsonSync:(int)value
{
    NSMutableDictionary *cmdctrl = [[NSMutableDictionary alloc] init];
    
    switch (value) {
            
        case 2:
            //获取组列表
            cmdctrl = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"set_group",@"cmd",@"218",@"group_id",model.text,@"sn",nil];
            break;
            
        case 3:
            //获取组列表
            cmdctrl = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"leave_group",@"cmd",@"218",@"group_id",model.text,@"sn",nil];
            break;
            
    }
    
    NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:cmdctrl];
    return data;
    
}

-(void)onoffSwitch:(NSString *)control
{
    [HUD show:YES];
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    res_dictionary = [self httpOnoffSwitch:control];
    NSString *res = [res_dictionary objectForKey:@"res"];
    if([res isEqualToString:@"200"]){
        //成功
        NSLog(@"Success");
    }else if([res isEqualToString:@"100"]){
        //失败
        NSLog(@"Username or Password is error.");
    }else{
        //服端端或网络异常
        NSLog(@"Network is error.");
    }
    [HUD hide:YES];
    
    NSLog(@"res_dictionary :%@",res_dictionary);
}

-(NSMutableDictionary *)httpOnoffSwitch:(NSString *)control
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"username_id"]];
    NSString *token = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"accesstoken"]];
    
    //NSLog(@"username : %@",_username.text);
    NSString *cmd = [NSString stringWithFormat:@"light_RCMD"];
    
    //封装mutableDictionary
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uid,@"username_id",token,@"accesstoken",devicesn,@"devicesn",control,@"control",nil];
    
    //mutableDictionary转NSString
    NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:userInfo];
    NSString *resdata = [NetWorkHttp httpGet:cmd Postdata:data];
    
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    if([resdata isEqualToString:@"999"]==false){
        res_dictionary = [NetWorkHttp httpjsonParser:resdata];
    }
    return res_dictionary;
}

-(void)sendSearchBroadcast:(NSString*) msg tag:(long)tag{
    [self sendToUDPServer:msg address:wanip port:UDP_PORT tag:tag];
}

-(void)sendToUDPServer:(NSString*) msg address:(NSString*)address port:(int)port tag:(long)tag{
    AsyncUdpSocket *udpSocket=[[AsyncUdpSocket alloc]initWithDelegate:self]; //得到udp util
    NSLog(@"address:%@,port:%d,msg:%@",address,port,msg);
    //receiveWithTimeout is necessary or you won't receive anything
    [udpSocket receiveWithTimeout:10 tag:2]; //设置超时10秒
    [udpSocket enableBroadcast:YES error:nil]; //如果你发送广播，这里必须先enableBroadcast
    NSData *data=[msg dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket sendData:data toHost:address port:port withTimeout:10 tag:tag]; //发送udp
}

-(void)setgroup_udp
{
    [HUD show:YES];
    NSString *message = [[NSString alloc] initWithFormat:@"%@",[self NSString2JsonSync:2]];
    [self sendSearchBroadcast:message tag:1];
}

-(void)leavegroup_udp
{
    [HUD show:YES];
    NSString *message = [[NSString alloc] initWithFormat:@"%@",[self NSString2JsonSync:3]];
    [self sendSearchBroadcast:message tag:1];
}
@end
