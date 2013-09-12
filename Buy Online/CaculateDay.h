//
//  CaculateDay.h
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/9/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaculateDay : NSObject
+(NSString *)caculateDate:(int)day month:(int)month year:(int)year;
+(NSString *)changeMonth : (int)month;
@end
