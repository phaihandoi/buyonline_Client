//
//  InfomationShopper.h
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/6/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
@interface InfomationShopper : UIViewController <SWRevealViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSString * uid;
@property(nonatomic, strong) SWRevealViewController *viewController1;
@end
