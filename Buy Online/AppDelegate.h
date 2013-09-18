//
//  AppDelegate.h
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/3/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Reachability/Reachability.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) Reachability* hostReach;
@property (nonatomic,strong) Reachability* internetReach;
@property (nonatomic,strong) Reachability* wifiReach;
@end
