//
//  ConnectInternet.h
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/13/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConnectInternet : NSObject
+(ConnectInternet *)sharedManager;
@property BOOL flagConnectInterNet;
@end
