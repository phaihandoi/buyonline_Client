//
//  ProductPaginator.m
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/12/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import "ProductPaginator.h"
#import "IDProvince.h"
@implementation ProductPaginator
- (void)fetchResultsWithPage:(NSInteger)page pageSize:(NSInteger)pageSize typeProduct:(NSInteger)typeProduct
{
    if (typeProduct == 0) {
        typeProduct = 9;
    }
    // do request on async thread
    dispatch_queue_t fetchQ = dispatch_queue_create("Fetch BuyOnline", NULL);
    dispatch_async(fetchQ, ^{
        NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"urlConnect" ofType:@"plist"]];
        NSString *url = [dictRoot valueForKey:@"getProducts"];
        NSString * urlData = [NSString stringWithFormat:@"%@%@?province_id=%@&product_type_id=%d&page=%d&display=%d",BASE_URL,url,[IDProvince sharedManager].cuIdProvince, typeProduct,page,pageSize];
        NSError *error = nil;
        NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:urlData] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
        if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
        NSMutableArray *abc = [[NSMutableArray alloc]init];
        
        NSArray *a;
        if (![[results valueForKey:@"count"] isEqualToString:@"0"]) {
            for (int i = 0; i<results.count-1; i++) {
                [abc addObject:[results valueForKey:[NSString stringWithFormat:@"%d",i]]];
            }
            a = [NSArray arrayWithArray:abc];
        }else {
            a = [[NSArray alloc]init];
        }
        // go back to main thread before adding results
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSInteger total = [[results valueForKey:@"count"] intValue];
            [self receivedResults:a total:total];
        });
    });
    //dispatch_release(fetchQ);
}
@end
