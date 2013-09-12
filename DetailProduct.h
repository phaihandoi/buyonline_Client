//
//  DetailProduct.h
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/6/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "DataProducts.h"
#import "SWRevealViewController.h"
@interface DetailProduct : UIViewController<UIScrollViewDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic,strong) DataProducts *dataProduct;
@end
