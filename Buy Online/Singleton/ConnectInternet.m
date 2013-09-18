//
//  ConnectInternet.m
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/13/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import "ConnectInternet.h"

@implementation ConnectInternet
+(ConnectInternet *)sharedManager
{
    static ConnectInternet *sharedMyManager;
    if (!sharedMyManager) {
        sharedMyManager = [[super allocWithZone:nil]init];
    }
    return sharedMyManager;
}
+(id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}
- (id)init {
    self = [super init];
    if (self) {
        self.flagConnectInterNet = NO;
    }
    return self;
}
@end
