//
//  IDProvince.m
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/5/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import "IDProvince.h"

@implementation IDProvince
+(IDProvince *)sharedManager
{
    static IDProvince *sharedMyManager;
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
        //_cuIdProvince = @"1";
        //_cuNameProvince = @"Nghệ An";
    }
    return self;
}
@end
