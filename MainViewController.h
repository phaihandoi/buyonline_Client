//
//  MainViewController.h
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/3/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrPaginator.h"
@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,NMPaginatorDelegate>
@property (nonatomic,strong) NSString *idTypeProduct;
@property (nonatomic,strong) NSString *titleNavigation;
@property (nonatomic, strong) FlickrPaginator *flickrPaginator;
@property (nonatomic, strong) UILabel *footerLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@end
