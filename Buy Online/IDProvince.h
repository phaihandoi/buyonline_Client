//
//  IDProvince.h
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/5/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDProvince : NSObject
+(IDProvince *)sharedManager;
@property (nonatomic,strong) NSString *cuIdProvince;
@property (nonatomic,strong) NSString *cuNameProvince;
@end
