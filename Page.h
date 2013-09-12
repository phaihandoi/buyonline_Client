//
//  Page.h
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/10/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Page : NSManagedObject

@property (nonatomic, retain) NSString * currentPageMainView;
@property (nonatomic, retain) NSString * pageDisplay;

@end
