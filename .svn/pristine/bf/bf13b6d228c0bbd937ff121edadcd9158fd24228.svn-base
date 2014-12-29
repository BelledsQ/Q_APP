//
//  MulticastClient.m
//  Belled
//
//  Created by Bellnet on 14-7-29.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "MulticastClient.h"

@implementation MulticastClient

-(id) initWithDelegate:(id)aDelegate
{
    mDelegate = aDelegate;
    
    return [super initWithDelegate:self];
}

// AsyncUdpSocketDelegate
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"MulticastClient didNotSendDataWithTag error %@", [error localizedDescription]);
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    //NSLog(@"MulticastClient didReceiveData");
    
    if([mDelegate respondsToSelector:@selector(onMulticastUdpData:length:)])
    {
        [mDelegate onMulticastUdpData:(uint8*)[data bytes] length:[data length]];
    }
    
    //receive again
    [self receiveWithTimeout:-1 tag:0];
    
    return TRUE;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"MulticastClient didNotReceiveDataWithTag");
    
    //receive again
    [self receiveWithTimeout:-1 tag:0];
}

@end
