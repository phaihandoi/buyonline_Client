//
//  FirstViewController.h
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/3/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
@interface FirstViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, SWRevealViewControllerDelegate>
@property(nonatomic, strong) SWRevealViewController *viewController1;
@end
