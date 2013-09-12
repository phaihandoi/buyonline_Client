//
//  SaveDataCartSG.h
//  Bai10
//
//  Created by nguyen huy hung on 05/06/2013.
//  Copyright (c) 2013 nguyen huy hung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveDataCartSG : NSObject
+(SaveDataCartSG *)listFood;
@property (nonatomic,strong) NSMutableArray *dataListFood;
@end
