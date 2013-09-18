//
//  WrapText.h
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/17/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WrapText : UIView
- (id)initWithFrame:(CGRect)frame withWrapString : (NSString *) string;
@property (nonatomic,strong) NSString *textToWrap;
@end
