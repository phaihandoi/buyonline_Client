//
//  Data Products.h
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/3/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProducts : NSObject
@property (nonatomic,strong) NSString *datePost;
@property (nonatomic,strong) NSString *productDesription;
@property (nonatomic,strong) NSString *productImage;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSString *quantity;
@property (nonatomic,strong) NSString *userName;
@property int productPrice;
@property int productType;
@property int idProduct;
@property int position;
@property int userId;
@end
