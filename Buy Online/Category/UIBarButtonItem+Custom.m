//
//  UIBarButtonItem+Custom.m
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/10/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import "UIBarButtonItem+Custom.h"

@implementation UIBarButtonItem (Custom)
-(UIBarButtonItem *)initWithCustomBarButtonItem : (NSString *)strImage frButton:(CGRect)frameBtn target:(id)target action:(SEL)action
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = frameBtn;
    [btn setBackgroundImage:[UIImage imageNamed:strImage] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return barBtn;
}
@end
