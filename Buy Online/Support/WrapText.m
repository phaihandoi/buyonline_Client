//
//  WrapText.m
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/17/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import "WrapText.h"
#import <CoreText/CoreText.h>
@implementation WrapText

- (id)initWithFrame:(CGRect)frame withWrapString : (NSString *) string
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textToWrap = string;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    /* Define some defaults */
    float padding = 5.0f;
    
    /* Get the graphics context for drawing */
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    /* Core Text Coordinate System is OSX style */
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGRect textRect = CGRectMake(padding, 1, self.frame.size.width, self.frame.size.height - padding*2);
    
    /* Create a path to draw in and add our text path */
    CGMutablePathRef pathToRenderIn = CGPathCreateMutable();
    CGPathAddRect(pathToRenderIn, NULL, textRect);
    
    /* Add a image path to clip around, region where you want to place image */
    CGRect clipRect = CGRectMake(self.frame.size.width - 94,  self.frame.size.height-82, 94, 82);
    CGPathAddRect(pathToRenderIn, NULL, clipRect);
    
    /* Build up an attributed string with the correct font */
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.textToWrap];
    
    //setFont
    CTFontRef font = CTFontCreateWithName((CFStringRef) [UIFont fontWithName:@"Roboto-Regular" size:0].fontName, [UIFont systemFontOfSize:8].lineHeight, NULL);
    CFAttributedStringSetAttribute(( CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length), kCTFontAttributeName,font);
    
    //set text color
    CGColorRef _white=[UIColor colorFromHexString:@"#010101"].CGColor;
    CFAttributedStringSetAttribute(( CFMutableAttributedStringRef)(attrString), CFRangeMake(0, attrString.length),kCTForegroundColorAttributeName, _white);
    
    /* Get a framesetter to draw the actual text */
    CTFramesetterRef fs = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef) attrString);
    CTFrameRef frame = CTFramesetterCreateFrame(fs, CFRangeMake(0, attrString.length), pathToRenderIn, NULL);
    
    /* Draw the text */
    CTFrameDraw(frame, ctx);
    
    /* Release the stuff we used */
    CFRelease(frame);
    CFRelease(pathToRenderIn);
    CFRelease(fs);
}


@end
