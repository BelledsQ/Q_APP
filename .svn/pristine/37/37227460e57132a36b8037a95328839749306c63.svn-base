//
//  ScanTableViewCell.m
//  Belled
//
//  Created by Bellnet on 14-6-30.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "ScanTableViewCell.h"

@implementation ScanTableViewCell
@synthesize  sn,ip,iswitch,iswitch_value;
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
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(uiswitchon) userInfo:nil repeats:NO];
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
    if (sender.on) {
        [self sendSearchBroadcast:[self NSString2Json:@"1"] tag:1];
    } else {
        [self sendSearchBroadcast:[self NSString2Json:@"0"] tag:1];
    }

}

-(NSString *)NSString2Json:(NSString *)iswitch_onoff
{
    NSMutableDictionary *device = [[NSMutableDictionary alloc] init];
    //封装mutableDictionary
    device = [[NSMutableDictionary alloc] initWithObjectsAndKeys:sn.text,@"sn",iswitch_onoff,@"iswitch",@"msync_ctrl",@"cmd",nil];
    NSString *data = [[[SBJsonWriter alloc] init] stringWithObject:device];
    NSLog(@"data--%@",data);
    return data;
}

-(void)sendSearchBroadcast:(NSString*) msg tag:(long)tag{
    [self sendToUDPServer:msg address:ip.text port:UDP_PORT tag:tag];
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
@end
