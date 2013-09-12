//
//  ScaleImage.h
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/6/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScaleImage : NSObject
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
