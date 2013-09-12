//
//  SidebarViewController.h
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/5/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) NSString * idProvince;
@property (nonatomic,strong) NSString * nameProvince;
@end
