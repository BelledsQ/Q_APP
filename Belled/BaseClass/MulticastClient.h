//
//  MulticastClient.h
//  Belled
//
//  Created by Bellnet on 14-7-29.
//  Copyright (c) 2014年 Bellnet. All rights reserved.
//

#import "AsyncUdpSocket.h"
#import "basetypes.h
@interface MulticastClient:AsyncUdpSocket
{
    id mDelegate;
}

-(id) initWithDelegate:(id)aDelegate;
@end

@protocol MulticastClientDelegate
-(void) onMulticastUdpData:(uint8*) data length:(uint32)length;
@end