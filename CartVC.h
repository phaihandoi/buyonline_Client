//
//  CartVC.h
//  Bai10
//
//  Created by nguyen huy hung on 04/06/2013.
//  Copyright (c) 2013 nguyen huy hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataProducts.h"
#import "SWRevealViewController.h"
@interface CartVC : UIViewController <UITableViewDataSource,UITableViewDelegate, SWRevealViewControllerDelegate>

@property (nonatomic,strong) DataProducts *getData;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) SWRevealViewController *viewController1;

@end
