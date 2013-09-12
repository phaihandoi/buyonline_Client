//
//  DataListTypeProducts.h
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/4/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataListTypeProducts : NSObject
@property int productTypeId;
@property (nonatomic,strong) NSString * productTypeImage;
@property (nonatomic,strong) NSString *productTypeName;
@end
