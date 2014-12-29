//
//  LightTableViewCell.m
//  Belled
//
//  Created by Bellnet on 14-4-25.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "SceneTableViewCell.h"

@implementation SceneTableViewCell

@synthesize  sn,model,iswitch,iswitch_value,scenetype,effect,light_List,url;

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
    NSLog(@"iswitch_value---%@   scenetype---%@   effect---%@   url---%@",iswitch_value,scenetype,effect,url);
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
    if (sender.on) {
        [self sendButtonPressedOnLight];
    } else {
        [self sendButtonPressedOffLight];
    }
    
}

- (void)sendButtonPressedOnLight
{
    NSLog(@"开场景");
    [self onoffSwitch:[self NSString2Json:@"1"]];
}

- (void)sendButtonPressedOffLight
{
    NSLog(@"关场景");
    [self onoffSwitch:[self NSString2Json:@"0"]];
}


-(NSMutableDictionary *)NSString2Json:(NSString *)iswitch_onoff
{
    NSMutableDictionary *device = [[NSMutableDictionary alloc] init];
    
    //封装mutableDictionary
    device = [[NSMutableDictionary alloc] initWithObjectsAndKeys:light_List,@"sn_list",scenetype,@"scenetype",effect,@"effect",url,@"url",iswitch_onoff,@"iswitch",@"scene_ctrl",@"cmd",nil];
    
    //NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:device];
    NSLog(@"data--%@",device);
    return device;
}
-(void)onoffSwitch:(NSMutableDictionary *)control
{

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
    
    NSLog(@"res_dictionary :%@",res_dictionary);
}

-(NSMutableDictionary *)httpOnoffSwitch:(NSMutableDictionary *)control
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *uid = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"username_id"]];
    NSString *token = [[NSString alloc] initWithFormat:@"%@", [ud objectForKey:@"accesstoken"]];
    
    //NSLog(@"username : %@",_username.text);
    NSString *cmd = [NSString stringWithFormat:@"scene_onoff"];
    
    //封装mutableDictionary
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:uid,@"username_id",token,@"accesstoken",control,@"control",nil];
    
    //mutableDictionary转NSString
    NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:userInfo];
    NSString *resdata = [NetWorkHttp httpGet:cmd Postdata:data];
    
    NSMutableDictionary *res_dictionary = [[NSMutableDictionary alloc] init];
    if([resdata isEqualToString:@"999"]==false){
        res_dictionary = [NetWorkHttp httpjsonParser:resdata];
    }
    return res_dictionary;
}

@end
