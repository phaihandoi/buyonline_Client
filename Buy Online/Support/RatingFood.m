//
//  RatingFood.m
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/4/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import "RatingFood.h"

@implementation RatingFood

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


+(void)checkRate : (int)rateYellow : (UIView *)uiView
{
    int x = 0 ;
    
    @try{
        for (int i = 0 ; i < rateYellow; i++) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(x, 10, 15, 15)];
            img.image = [UIImage imageNamed:@"rating-yellow.png"];
            [uiView addSubview:img];
            x+=20;
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @try{
        for (int i=0; i<5-rateYellow; i++) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(x, 10, 15, 15)];
            img.image = [UIImage imageNamed:@"rating-white.png"];
            [uiView addSubview:img];
            x+=20;
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
    
}

@end
