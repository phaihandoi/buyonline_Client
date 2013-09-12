//
//  DetailProduct.m
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/6/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import "DetailProduct.h"
#import "MainViewController.h"
#import "SidebarViewController.h"
#import "InfomationShopper.h"
#import "CartVC.h"
#import "UIBarButtonItem+Custom.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface DetailProduct ()
{
    InfomationShopper *uidShop;
}
@end

@implementation DetailProduct

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = [self.dataProduct valueForKey:@"product_name"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    uidShop = [[InfomationShopper alloc]init];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomBarButtonItem:@"back"
                                                                                frButton:CGRectMake(0, 0, 24, 24)
                                                                                  target:self
                                                                                  action:@selector(gotoListProducts)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomBarButtonItem:@"info_user"
                                                                                frButton:CGRectMake(0, 0, 24, 24)
                                                                                  target:self
                                                                                  action:@selector(goToInfoShoper)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    float sWidth = self.view.frame.size.width;
    //float sHeight = self.view.frame.size.height;
    
    //UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(12, 7, 296, 211)];
    UIImageView *frameImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 25, 296, 211)];
    frameImage.image = [UIImage imageNamed:@"photo-frame"];
    
    [self.view addSubview:frameImage];
    
    UIImageView *imageRecipt = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, frameImage.frame.size.width-16, frameImage.frame.size.height-30)];
    NSString *urlImage = [NSString stringWithFormat:@"%@%@",URL_IMAGE,[self.dataProduct valueForKey:@"product_image"]];
    NSURL *imageURL = [NSURL URLWithString:urlImage];
    [imageRecipt setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];        
    
    [frameImage addSubview:imageRecipt];
    
    //[self.view addSubview:scrollView];
    
    UILabel *priceFood = [[UILabel alloc]initWithFrame:CGRectMake(12, frameImage.frame.size.height + 15, 70, 30)];
    priceFood.text = @"Price: ";
    
    [priceFood setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20.0]];
    [self.view addSubview:priceFood];
    UILabel *preTime = [[UILabel alloc]initWithFrame:CGRectMake(priceFood.frame.size.width + 20, frameImage.frame.size.height+15, 140, 30)];
    NSString *titlePrice = [NSString stringWithFormat:@"%@ VND",[self.dataProduct valueForKey:@"product_price"]];
    [preTime setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20.0]];
    preTime.textColor = [UIColor orangeColor];
    preTime.text = titlePrice;
    [self.view addSubview:preTime];

    UILabel *infoRecipe = [[UILabel alloc]initWithFrame:CGRectMake(5, preTime.frame.origin.y + 10, self.view.frame.size.width-10, 150)];
    infoRecipe.lineBreakMode = 0;
    infoRecipe.numberOfLines = 5;
    infoRecipe.text = [self.dataProduct valueForKey:@"product_description"];
    [self.view addSubview:infoRecipe];
    UIButton *buyOnline = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyOnline setBackgroundImage:[UIImage imageNamed:@"buy_online.png"] forState:UIControlStateNormal];
    [buyOnline setFrame:CGRectMake(sWidth/2 -80,infoRecipe.frame.size.height + infoRecipe.frame.origin.y - 20, 60, 60)];
    [buyOnline addTarget:self action:@selector(cart) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *report = [UIButton buttonWithType:UIButtonTypeCustom];
    [report setBackgroundImage:[UIImage imageNamed:@"bookmark-add.png"] forState:UIControlStateNormal];
    [report setFrame:CGRectMake(sWidth/2 -10, infoRecipe.frame.size.height + infoRecipe.frame.origin.y - 20, 60, 60)];
    [report addTarget:self action:@selector(bookmarkProduct) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:buyOnline];
    [self.view addSubview:report];
}

-(UIButton *)checkBookmark
{
    //Liên kết với core data , check đã bookmark chưa ?
    UIButton *btn = [[UIButton alloc]init];
    return btn;
}

-(void)goToInfoShoper
{
    if (!uidShop) {
        uidShop = [[InfomationShopper alloc]init];
    }
    uidShop.uid = [self.dataProduct valueForKey:@"user_id"];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:uidShop];
    [self presentModalViewController:nav animated:YES];
}

-(void)gotoListProducts
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)bookmarkProduct
{
//    // AlertView Custom
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"REPORT PRODUCT"
//                                                       message:@"Are you sure report this product"
//                                                      delegate:self
//                                             cancelButtonTitle:@"Cancel"
//                                             otherButtonTitles:@"OK", nil];
//    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 280, 127)];
//    imgView.image = [UIImage imageNamed:@"bg_alert.jpg"];
//    imgView.contentMode = UIViewContentModeScaleAspectFill;
//    [alertView insertSubview:imgView atIndex:0];
//    
//    for (id obj in alertView.subviews) {
//        if ([obj isKindOfClass:[UIButton class]]) {
//            UIButton *btn = (UIButton *)obj;
//            NSString *title = [btn titleForState:UIControlStateNormal];
//            
//            if ([title isEqualToString:@"OK"]) {
//                [btn setImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
//            }else if ([title isEqualToString:@"Cancel"]){
//                [btn setImage:[UIImage imageNamed:@"no.png"] forState:UIControlStateNormal];
//            }
//        }
//    }
//    [alertView show];
    NSLog(@"Bookmark product");
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"Click cancel button");
    }else{
        [self sendMailToManager];
    }
}


-(void)sendMailToManager
{
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
    [mailController setMailComposeDelegate:self];
    NSString *email = @"nguyen.huy.hung@framgia.com";
    NSString *email1 = @"nguyen_huy_hung_89@yahoo.com";
    NSArray *emailArray = [[NSArray alloc]initWithObjects:email,email1, nil];
    NSString *message = [NSString stringWithFormat:@"Name : %@ \n Reason : ",[self.dataProduct valueForKey:@"product_name"]];
    [mailController setMessageBody:message isHTML:NO];
    [mailController setToRecipients:emailArray];
    NSString *subject = [NSString stringWithFormat:@"Report Food : %@",[self.dataProduct valueForKey:@"product_name"]];
    [mailController setSubject:subject];    
    [self presentViewController:mailController animated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (result == MFMailComposeResultCancelled) {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(void)cart
{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    CartVC *main = [storyboard instantiateViewControllerWithIdentifier:@"CartVC"];
//    main.getData = _dataCell;
//    main.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:main animated:YES completion:nil];
    CartVC *cart = [[CartVC alloc]init];
    cart.getData = self.dataProduct;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:cart];
    [self presentModalViewController:nav animated:YES];
}

@end
