//
//  SaveDataCartSG.m
//  Bai10
//
//  Created by nguyen huy hung on 05/06/2013.
//  Copyright (c) 2013 nguyen huy hung. All rights reserved.
//

#import "SaveDataCartSG.h"

@implementation SaveDataCartSG
+(SaveDataCartSG *) listFood
{
    static SaveDataCartSG *listFood;
    if (!listFood) {
        listFood = [[super allocWithZone:nil]init];
    }
    return listFood;
}
+(id)allocWithZone:(NSZone *)zone
{
    return [self listFood];
}

-(id)init
{
    self = [super init];
    if (self) {
        _dataListFood = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
