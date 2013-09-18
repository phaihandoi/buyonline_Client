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
#import "WrapText.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
@interface DetailProduct ()
{
    InfomationShopper *uidShop;
    int flagProduct; //Check product hot or new or sale
    UILabel *lbCountOrder;
    UIImageView *arrowLeft;
    UILabel *lbTotalPrice;
    int scaleScreen;
}
@end

@implementation DetailProduct

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (!isiPhone5)
    {
        scaleScreen = 0;
    }
    else
    {
        scaleScreen = 64;
    }
    
    self.title = [self.dataProduct valueForKey:@"product_name"];    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    uidShop = [[InfomationShopper alloc]init];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomBarButtonItem:@"back"
                                                                                frButton:CGRectMake(0, 0, 24, 24)
                                                                                  target:self
                                                                                  action:@selector(gotoListProducts)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomBarButtonItem:@"user"
                                                                                frButton:CGRectMake(0, 0, 24, 24)
                                                                                  target:self
                                                                                  action:@selector(goToInfoShoper)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
//    float sWidth = self.view.frame.size.width;
//    UIImageView *frameImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 25, 296, 211)];
//    frameImage.image = [UIImage imageNamed:@"photo-frame"];
//    
//    [self.view addSubview:frameImage];
//    
//    UIImageView *imageRecipt = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, frameImage.frame.size.width-16, frameImage.frame.size.height-30)];
//    NSString *urlImage = [NSString stringWithFormat:@"%@%@",URL_IMAGE,[self.dataProduct valueForKey:@"product_image"]];
//    NSURL *imageURL = [NSURL URLWithString:urlImage];
//    [imageRecipt setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];        
//    
//    [frameImage addSubview:imageRecipt];
//    
//    //[self.view addSubview:scrollView];
//    
//    UILabel *priceFood = [[UILabel alloc]initWithFrame:CGRectMake(12, frameImage.frame.size.height + 15, 70, 30)];
//    priceFood.text = @"Price: ";
//    
//    [priceFood setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20.0]];
//    [self.view addSubview:priceFood];
//    UILabel *preTime = [[UILabel alloc]initWithFrame:CGRectMake(priceFood.frame.size.width + 20, frameImage.frame.size.height+15, 140, 30)];
//    NSString *titlePrice = [NSString stringWithFormat:@"%@ VND",[self.dataProduct valueForKey:@"product_price"]];
//    [preTime setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:20.0]];
//    preTime.textColor = [UIColor orangeColor];
//    preTime.text = titlePrice;
//    [self.view addSubview:preTime];
//
//    UILabel *infoRecipe = [[UILabel alloc]initWithFrame:CGRectMake(5, preTime.frame.origin.y + 10, self.view.frame.size.width-10, 150)];
//    infoRecipe.lineBreakMode = 0;
//    infoRecipe.numberOfLines = 5;
//    infoRecipe.text = [self.dataProduct valueForKey:@"product_description"];
//    [self.view addSubview:infoRecipe];
//    UIButton *buyOnline = [UIButton buttonWithType:UIButtonTypeCustom];
//    [buyOnline setBackgroundImage:[UIImage imageNamed:@"buy_online.png"] forState:UIControlStateNormal];
//    [buyOnline setFrame:CGRectMake(sWidth/2 -80,infoRecipe.frame.size.height + infoRecipe.frame.origin.y - 20, 60, 60)];
//    [buyOnline addTarget:self action:@selector(cart) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *report = [UIButton buttonWithType:UIButtonTypeCustom];
//    [report setBackgroundImage:[UIImage imageNamed:@"bookmark-add.png"] forState:UIControlStateNormal];
//    [report setFrame:CGRectMake(sWidth/2 -10, infoRecipe.frame.size.height + infoRecipe.frame.origin.y - 20, 60, 60)];
//    [report addTarget:self action:@selector(bookmarkProduct) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:buyOnline];
//    [self.view addSubview:report];

    
    //Get current time , after sub a week , and compare with date server response.
    NSDate *todayDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-7];
    NSDate *beforeSevenDays = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:todayDate options:0];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *datePostProduct = [self convertStringToDate:[self.dataProduct valueForKey:@"date_post_product"]];
    NSDate *dateWeekAgo = [self convertStringToDate:[dateFormatter stringFromDate:beforeSevenDays]];
    
    [self compareTwoWithDate:datePostProduct currentDate:dateWeekAgo];
    
    UIView *vInfomationProduct = [[UIView alloc]initWithFrame:CGRectMake(10,
                                                                         10 + scaleScreen,
                                                                         self.view.frame.size.width - 21,
                                                                         320)];
    vInfomationProduct.layer.borderWidth = 0.5f;
    vInfomationProduct.layer.borderColor = [UIColor colorFromHexString:@"#cccccc"].CGColor;
    
    UIImageView *adsProduct = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 69, 74)];
    if (![[self.dataProduct valueForKey:@"sale_product"] isEqualToString:@"0"]) {
        adsProduct.image = [UIImage imageNamed:@"sale"];
    }else if (flagProduct == 1){
        adsProduct.image = [UIImage imageNamed:@"new"];
    }else {
        adsProduct.image = [UIImage imageNamed:@"hot"];
    }
    [vInfomationProduct addSubview:adsProduct];
    
    UIImageView *imgBookmark = [[UIImageView alloc]initWithFrame:CGRectMake(vInfomationProduct.frame.size.width - 30-6, 6, 30, 30)];
    imgBookmark.image = [UIImage imageNamed:@"icon_fav_over"];
    imgBookmark.contentMode = UIViewContentModeCenter;
    imgBookmark.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesBookmark = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionBookmark)];
    [imgBookmark addGestureRecognizer:gesBookmark];
    [vInfomationProduct addSubview:imgBookmark];
    
    UIImageView *imgProduct = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                           adsProduct.frame.origin.y + adsProduct.frame.size.height,
                                                                           vInfomationProduct.frame.size.width,
                                                                           vInfomationProduct.frame.size.height - 50 - 74)];
    
    NSString *urlImage = [NSString stringWithFormat:@"%@%@",URL_IMAGE,[self.dataProduct valueForKey:@"product_image"]];
    NSURL *imageURL = [NSURL URLWithString:urlImage];
    [imgProduct setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];
    imgProduct.contentMode = UIViewContentModeScaleAspectFit;
    [vInfomationProduct addSubview:imgProduct];
    
    UIView *detailProduct = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                    vInfomationProduct.frame.size.height-50,
                                                                    vInfomationProduct.frame.size.width,
                                                                    50)];
    [vInfomationProduct addSubview:detailProduct];
    
    UILabel *lbNameProduct = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 155, 25)];
    lbNameProduct.text = [NSString stringWithFormat:@"%@",[self.dataProduct valueForKey:@"product_name"]];
    lbNameProduct.font = [UIFont fontWithName:@"Roboto-Bold" size:18];
    lbNameProduct.textColor = [UIColor colorFromHexString:@"#00261c"];
    [detailProduct addSubview:lbNameProduct];
    
    UILabel *lbAuthor = [[UILabel alloc]initWithFrame:CGRectMake(10, lbNameProduct.frame.size.height-3, 175, 22)];
    lbAuthor.text = [NSString stringWithFormat:@"%@",[self.dataProduct valueForKey:@"name"]];
    lbAuthor.font = [UIFont fontWithName:@"Roboto-Regular" size:18];
    lbAuthor.textColor = [UIColor colorFromHexString:@"#666666"];
    [detailProduct addSubview:lbAuthor];
    
    UILabel *lbPrice = [[UILabel alloc]initWithFrame:CGRectMake(detailProduct.frame.size.width - 114 - 15, 0,114 , 25)];
    lbPrice.font = [UIFont fontWithName:@"Roboto-Regular" size:18];
    lbPrice.textColor = [UIColor colorFromHexString:@"#168039"];
    lbPrice.textAlignment = NSTextAlignmentRight;
    [detailProduct addSubview:lbPrice];
    lbPrice.text = [NSString stringWithFormat:@"%d đ",[[self.dataProduct valueForKey:@"product_price"] intValue] - [[self.dataProduct valueForKey:@"product_sale"] intValue]];
    
    WrapText *vWrapText = [[WrapText alloc]initWithFrame:CGRectMake(10, vInfomationProduct.frame.origin.y + vInfomationProduct.frame.size.height + 1 , detailProduct.frame.size.width, self.view.frame.size.height - vInfomationProduct.frame.size.height - vInfomationProduct.frame.origin.y - 64) withWrapString:[self.dataProduct valueForKey:@"product_description"]];
    vWrapText.backgroundColor=[UIColor clearColor];
    
    UIView *orderProduct = [[UIView alloc]initWithFrame:CGRectMake(vWrapText.frame.size.width - 90, 0, 90, 82)];
    orderProduct.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"frame_quanlity"]];
    
    UIImageView *arrowRight = [[UIImageView alloc]initWithFrame:CGRectMake(orderProduct.frame.size.width-30, 18, 30, 30)];
    arrowRight.image = [UIImage imageNamed:@"arrow_over_right"];
    UITapGestureRecognizer *gesIncrea = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(increaCountOrder)];
    arrowRight.userInteractionEnabled = YES;
    [arrowRight addGestureRecognizer:gesIncrea];
    arrowRight.contentMode = UIViewContentModeCenter;
    
    lbCountOrder = [[UILabel alloc]initWithFrame:CGRectMake(30, 18, orderProduct.frame.size.width - 60, 30)];
    lbCountOrder.text = @"1";
    lbCountOrder.textColor = [UIColor whiteColor];
    lbCountOrder.textAlignment = NSTextAlignmentCenter;
    lbCountOrder.font = [UIFont fontWithName:@"Roboto-Bold" size:18];
    [orderProduct addSubview:lbCountOrder];
    
    arrowLeft = [[UIImageView alloc]initWithFrame:CGRectMake(0, 18, 30, 30)];
    arrowLeft.image = [UIImage imageNamed:@"arrow"];
    arrowLeft.contentMode = UIViewContentModeCenter;
    arrowLeft.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesSub = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(subCountOrder)];
    [arrowLeft addGestureRecognizer:gesSub];
    
    [orderProduct addSubview:arrowLeft];
    [orderProduct addSubview:arrowRight];
    [vWrapText addSubview:orderProduct];
    
    lbTotalPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, orderProduct.frame.size.width, 30)];
    lbTotalPrice.textAlignment = NSTextAlignmentCenter;
    lbTotalPrice.textColor = [UIColor whiteColor];
    lbTotalPrice.font = [UIFont fontWithName:@"Roboto-Regular" size:18];
    lbTotalPrice.text = [NSString localizedStringWithFormat:@"%.3dđ",[[self.dataProduct valueForKey:@"product_price"] intValue] - [[self.dataProduct valueForKey:@"product_sale"] intValue]];
    [orderProduct addSubview:lbTotalPrice];
    
    [self.view addSubview:vWrapText];
    
    UIView *vOrder = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-64, self.view.frame.size.width, 64)];
    vOrder.backgroundColor = [UIColor colorFromHexString:@"#168039"];
    vOrder.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesCart = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cart)];
    [vOrder addGestureRecognizer:gesCart];
    
    UIImageView *imgCart = [[UIImageView alloc]initWithFrame:CGRectMake(100, 0, 40, vOrder.frame.size.height)];
    imgCart.image = [UIImage imageNamed:@"cart"];
    imgCart.contentMode = UIViewContentModeCenter;
    [vOrder addSubview:imgCart];
    
    UILabel *lbTextOrder = [[UILabel alloc]initWithFrame:CGRectMake(imgCart.frame.origin.x + imgCart.frame.size.width, 0, 80, vOrder.frame.size.height)];
    lbTextOrder.text = @"ORDER";
    lbTextOrder.textColor = [UIColor whiteColor];
    lbTextOrder.font = [UIFont fontWithName:@"Roboto-Bold" size:20];
    [vOrder addSubview:lbTextOrder];
    
    [self.view addSubview:vOrder];
    [self.view addSubview:vInfomationProduct];
    
}
-(void)subCountOrder
{
    [self changeImageArrow :[lbCountOrder.text intValue]-1];
    [self setTextCountOrder:[lbCountOrder.text intValue]-1];
    
}
-(void)increaCountOrder
{
    [self changeImageArrow :[lbCountOrder.text intValue]+1];
    [self setTextCountOrder:[lbCountOrder.text intValue]+1];
}
-(void)changeImageArrow : (int)count
{
    if (count > 1) {
        arrowLeft.image = [UIImage imageNamed:@"arrow_over_left"];
    }else {
        arrowLeft.image = [UIImage imageNamed:@"arrow"];
    }
}

-(void)setTextCountOrder : (int)count
{
    if (count < 1) {
        lbCountOrder.text = @"1";
        lbTotalPrice.text = [NSString localizedStringWithFormat:@"%.3dđ",[[self.dataProduct valueForKey:@"product_price"] intValue] - [[self.dataProduct valueForKey:@"product_sale"] intValue]];
    }else {
        lbCountOrder.text = [NSString stringWithFormat:@"%d",count];
        lbTotalPrice.text = [NSString localizedStringWithFormat:@"%.3dđ",([[self.dataProduct valueForKey:@"product_price"] intValue] - [[self.dataProduct valueForKey:@"product_sale"] intValue])*count];
    }
}

-(NSDate *)convertStringToDate : (NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:dateString];
    return dateFromString;
}
-(void)compareTwoWithDate : (NSDate *)dateOne currentDate : (NSDate *)currentDate
{
    NSLog(@"dateOne : %@------------------- currentDate : %@",dateOne,currentDate);
    if ([dateOne compare:currentDate]) {
        flagProduct = 1;
    }else {
        flagProduct = 0;
    }
}
-(UIButton *)checkBookmark
{
    //Liên kết với core data , check đã bookmark chưa ?
    UIButton *btn = [[UIButton alloc]init];
    return btn;
}

-(void)actionBookmark
{
    NSLog(@"Bookmark");
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
    cart.countOrder = [lbCountOrder.text intValue];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:cart];
    [self presentModalViewController:nav animated:YES];
}

@end
