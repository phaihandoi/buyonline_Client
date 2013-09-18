//
//  UIBarButtonItem+Custom.h
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/10/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Custom)
-(UIBarButtonItem *)initWithCustomBarButtonItem : (NSString *)strImage frButton:(CGRect)frameBtn target:(id)target action:(SEL)action;
@end
