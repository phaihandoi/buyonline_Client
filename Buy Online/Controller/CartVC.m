//
//  CartVC.m
//  Bai10
//
//  Created by nguyen huy hung on 04/06/2013.
//  Copyright (c) 2013 nguyen huy hung. All rights reserved.
//

#import "CartVC.h"
#import "SaveDataCartSG.h"
#import "MainViewController.h"
#import "SidebarViewController.h"
#import "UIBarButtonItem+Custom.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#define kHeightCell 90
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
@interface CartVC ()
{
    NSIndexPath *indexPathRow;
    SLComposeViewController *slc;
    UILabel *totalAmount;
    UIView *vShare;
    int numberOrder;
    BOOL flagShare;
    int scaleScreen;
}
@end

@implementation CartVC
@synthesize getData=_getData;
-(id)init
{
    self = [super init];
    if (!self) {
        flagShare = false;
        numberOrder = 1;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (isiPhone5)
    {
        scaleScreen = 0;
    }
    else
    {        
        scaleScreen = 44;
    }
    
    self.title = @"CART ORDER";
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomBarButtonItem:@"back"
                                                                                frButton:CGRectMake(0, 0, 24, 24)
                                                                                  target:self
                                                                                  action:@selector(backToView)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomBarButtonItem:@"share"
                                                                                     frButton:CGRectMake(0, 0, 24, 24)
                                                                                       target:self
                                                                                       action:@selector(shareWithFriend)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    
    [self checkHaveProductInCart];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height-64-scaleScreen)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self.view addSubview:_tableView];
    [self.view addSubview:totalAmount];
    
    
    
    
    
    vShare = [[UIView alloc]initWithFrame:CGRectMake(_tableView.frame.size.width-366/2-12, 0, 366/2 , 196/2)];
    UIImageView *imgArrow = [[UIImageView alloc]initWithFrame:CGRectMake( vShare.frame.size.width - 19, 5, 12, 10)];
    imgArrow.image = [UIImage imageNamed:@"frame_arrow"];
    [vShare addSubview:imgArrow];
    
    UIView *vShareFacebook = [self createRowShareWithName:@"Share on facebook"
                                              stringImage:@"icon_facebook"
                                                    frame:CGRectMake(0, imgArrow.frame.origin.y + imgArrow.frame.size.height, vShare.frame.size.width, 30)];
    vShareFacebook.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapFa = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postFB)];
    [vShareFacebook addGestureRecognizer:tapFa];
    
    UIView *vShareTwitter = [self createRowShareWithName:@"Share on Twitter"
                                             stringImage:@"icon_tiwter"
                                                   frame:CGRectMake(0, vShareFacebook.frame.origin.y + vShareFacebook.frame.size.height, vShareFacebook.frame.size.width, vShareFacebook.frame.size.height)];
    vShareTwitter.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapTW = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postTwiter)];
    [vShareTwitter addGestureRecognizer:tapTW];
    
    UIView *vShareWeibo = [self createRowShareWithName:@"Share on Weibo"
                                           stringImage:@"icon-weibo"
                                                 frame:CGRectMake(0, vShareTwitter.frame.origin.y + vShareTwitter.frame.size.height, vShareTwitter.frame.size.width, vShareTwitter.frame.size.height)];
    vShareWeibo.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapW = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postTwiter)];
    [vShareTwitter addGestureRecognizer:tapW];
    
    vShare.hidden = YES;
    [vShare addSubview:vShareFacebook];
    [vShare addSubview:vShareTwitter];
    [vShare addSubview:vShareWeibo];
    [_tableView addSubview:vShare];
    
    UIView *orderView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-64-scaleScreen, self.view.frame.size.width, 64)];
    [orderView setBackgroundColor:[UIColor colorFromHexString:@"#00261c"]];
    UILabel *lbTotal = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 60, 14)];
    lbTotal.text = @"Total: ";
    lbTotal.font = [UIFont fontWithName:@"Roboto-Bold" size:18];
    lbTotal.textColor = [UIColor whiteColor];
    [orderView addSubview:lbTotal];
    
    totalAmount = [[UILabel alloc]initWithFrame:CGRectMake(70,25 , orderView.frame.size.width - 64 - lbTotal.frame.size.width - 20, 14)];
    totalAmount.font = [UIFont fontWithName:@"Roboto-Bold" size:18];
    totalAmount.textColor = [UIColor whiteColor];
    totalAmount.textAlignment = NSTextAlignmentRight;
    [orderView addSubview:totalAmount];
    [self caculatorTotalPrice:totalAmount];
    
    UIImageView *paymentMoney = [[UIImageView alloc]initWithFrame:CGRectMake(orderView.frame.size.width-64, 0, 64, 64)];
    paymentMoney.image = [UIImage imageNamed:@"card_order"];
    paymentMoney.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesPay = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(paymentMoney)];
    [paymentMoney addGestureRecognizer:gesPay];
    [orderView addSubview:paymentMoney];
    [self.view addSubview:orderView];
}

-(void)checkHaveProductInCart
{
    if ([[SaveDataCartSG listFood] dataListFood].count == 0) {
        [self addProductToListFood];
    } else {
        if ([[[SaveDataCartSG listFood] dataListFood] containsObject:self.getData]) {
            int index = [[[SaveDataCartSG listFood] dataListFood] indexOfObject:self.getData];
            int get_count_order = [[[[SaveDataCartSG listFood].dataListFood objectAtIndex:index] valueForKey:@"count_order"] intValue] + self.countOrder;
            NSString *str_get_count_order = [NSString stringWithFormat:@"%d",get_count_order];
            [[[SaveDataCartSG listFood].dataListFood objectAtIndex:index] setObject:str_get_count_order forKey:@"count_order"];

        }else {
            [self addProductToListFood];
        }
    }
    /*
        - Th1 : Singleton = 0
            Add vao singleton
     
        - TH2 : Singleton != 0
            Check xem co data trong singleton ko ?
                Th1 : Neu ko co thi add vao singleton
                Th2 : Neu co thi change count_order
     */
}

-(void)addProductToListFood
{
    NSMutableDictionary *dic = (NSMutableDictionary *)_getData;
    [dic setObject:[NSString stringWithFormat:@"%d",self.countOrder] forKey:@"count_order"];
    [[[SaveDataCartSG listFood] dataListFood] addObject:dic];
}

-(void)backToView
{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)shareWithFriend
{
    if (!flagShare) {
        [UIView transitionWithView:vShare duration:1 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            vShare.hidden = NO;
        } completion:^(BOOL finished) {
            flagShare = true;
        }];
    }else {
        [UIView transitionWithView:vShare duration:1 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            vShare.hidden = YES;
        } completion:^(BOOL finished) {
            flagShare = false;
        }];
    }
}

-(UIView *)createRowShareWithName : (NSString *)name stringImage : (NSString *)stringImage frame : (CGRect) frame
{
    UIView *viewContain = [[UIView alloc]initWithFrame:frame];
    [viewContain setBackgroundColor:[UIColor colorFromHexString:@"#45bf55"]];
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 29, 29)];
    img.image = [UIImage imageNamed:stringImage];
    [viewContain addSubview:img];
    UILabel *lbName =  [[UILabel alloc]initWithFrame:CGRectMake(img.frame.size.width + 20, 0, viewContain.frame.size.width - img.frame.size.width, 29)];
    lbName.text = name;
    lbName.textColor = [UIColor whiteColor];
    lbName.font = [UIFont fontWithName:@"Roboto-Regular" size:12];
    [viewContain addSubview:lbName];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(29,29 , lbName.frame.size.width, 1)];
    [line setBackgroundColor:[UIColor colorFromHexString:@"#96ed89"]];
    [viewContain addSubview:line];
    
    return viewContain;
}
-(void)caculatorTotalPrice : (UILabel *)label
{
    int totalPrice = 0;
    for (id obj in [[SaveDataCartSG listFood]dataListFood]) {
        totalPrice += [[obj valueForKey:@"product_price"]intValue] * [[obj valueForKey:@"count_order"] intValue];
    }
    label.text = [NSString stringWithFormat:@"%d VND",totalPrice];
}

//-(void)continueBuyFood
//{
//    MainViewController *mVC = [[MainViewController alloc]init];
//    SidebarViewController *sideVC = [[SidebarViewController alloc]init];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mVC];
//    
//    //mVC.idProvince = self.idProvince;
//    mVC.titleNavigation = @"Sản Phẩm";
//    SWRevealViewController *revealController = [[SWRevealViewController alloc]
//                                                initWithRearViewController:sideVC
//                                                frontViewController:nav];
//    revealController.delegate = self;
//    self.viewController1=revealController;
//    [self presentViewController:self.viewController1 animated:YES completion:nil];
//}

-(void)paymentMoney
{
    NSLog(@"Payment");
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeightCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[SaveDataCartSG listFood] dataListFood ] count];
}

#pragma mark ConfigureCell
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    DataProducts *data = [[[SaveDataCartSG listFood]dataListFood] objectAtIndex:indexPath.row];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 70)];
    NSString *urlImage = [NSString stringWithFormat:@"%@%@",URL_IMAGE,[data valueForKey:@"product_image"]];
    NSURL *imageURL = [NSURL URLWithString:urlImage];
    [imageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];
    
    UILabel *lbName = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width + 15, 0, 165, 30)];
    lbName.font = [UIFont fontWithName:@"Roboto-Bold" size:20];
    lbName.textColor = [UIColor colorFromHexString:@"#00261c"];
    lbName.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"product_name"]];
    
    UILabel *lbAuthor = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width + 15, lbName.frame.origin.y + 30, 165, 30)];
    lbAuthor.font = [UIFont fontWithName:@"Roboto-Medium" size:20];
    lbAuthor.textColor = [UIColor colorFromHexString:@"#666666"];
    lbAuthor.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"name"]];
    
    UILabel *lbPrice = [[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.size.width + 15, lbAuthor.frame.origin.y + 30, 165, 30)];
    lbPrice.font = [UIFont fontWithName:@"Roboto-Light" size:18];
    lbPrice.textColor = [UIColor colorFromHexString:@"#168039"];
    lbPrice.text = [NSString localizedStringWithFormat:@"%.3d đ", [[data valueForKey:@"product_price"] intValue]];
    
    int widthVOrder = cell.frame.size.width - imageView.frame.size.width - lbName.frame.size.width;
    UIView *vOrder = [[UIView alloc]initWithFrame:CGRectMake(imageView.frame.size.width + lbName.frame.size.width + 20, 0, widthVOrder, kHeightCell)];
    
    UIImageView *arrowUp = [[UIImageView alloc]initWithFrame:CGRectMake(widthVOrder/2 - 23, 0, 46, 22)];
    arrowUp.userInteractionEnabled = YES;
    arrowUp.layer.borderColor = [UIColor colorFromHexString:@"#c8c8c8"].CGColor;
    arrowUp.layer.borderWidth = 0.5;
    arrowUp.image = [UIImage imageNamed:@"arrow_quanlity"];
    arrowUp.contentMode = UIViewContentModeScaleAspectFit;
    [vOrder addSubview:arrowUp];
    
    UITapGestureRecognizer *gesIncre = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(increaseProduct:)];
    [arrowUp addGestureRecognizer:gesIncre];
    
    UIImageView *arrowDown = [[UIImageView alloc]initWithFrame:CGRectMake(widthVOrder/2 - 23, vOrder.frame.size.height-22, 46, 22-0.5)];
    arrowDown.userInteractionEnabled = YES;
    arrowDown.layer.borderColor = [UIColor colorFromHexString:@"#c8c8c8"].CGColor;
    arrowDown.layer.borderWidth = 0.5;
    arrowDown.contentMode = UIViewContentModeScaleAspectFit;
    [vOrder addSubview:arrowDown];
    UITapGestureRecognizer *gesSub = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(subProduct:)];
    UITapGestureRecognizer *gesDe = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteProduct:)];
    
    if ([[data valueForKey:@"count_order"] intValue] == 1) {
        arrowDown.image = [UIImage imageNamed:@"delete_over"];
        [arrowDown removeGestureRecognizer:gesSub];
        [arrowDown addGestureRecognizer:gesDe];
    }else if ([[data valueForKey:@"count_order"] intValue] > 1){
        arrowDown.image = [UIImage imageNamed:@"arrow_quanlity_over"];
        [arrowDown removeGestureRecognizer:gesDe];
        [arrowDown addGestureRecognizer:gesSub];
    }
    
    int heightLBNumberOrder = vOrder.frame.size.height - arrowUp.frame.size.height - arrowDown.frame.size.height;
    UILabel *lbNumberOrder = [[UILabel alloc]initWithFrame:CGRectMake(widthVOrder/2-23+0.5, arrowDown.frame.size.height, 45, heightLBNumberOrder)];
    lbNumberOrder.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"count_order"]];
    lbNumberOrder.textAlignment = NSTextAlignmentCenter;
    [lbNumberOrder setFont:[UIFont fontWithName:@"Roboto-Bold" size:20]];
    lbNumberOrder.textColor = [UIColor blackColor];
    [vOrder addSubview:lbNumberOrder];
    
    UILabel *lbLeftLine = [[UILabel alloc]initWithFrame:CGRectMake(widthVOrder/2-23, arrowDown.frame.size.height, 0.5,heightLBNumberOrder+1 )];
    lbLeftLine.backgroundColor = [UIColor colorFromHexString:@"#c8c8c8"];
    [vOrder addSubview:lbLeftLine];
    
    UILabel *lbRightLine = [[UILabel alloc]initWithFrame:CGRectMake(65-0.5, arrowDown.frame.size.height, 0.5,heightLBNumberOrder+1 )];
    lbRightLine.backgroundColor = [UIColor colorFromHexString:@"#c8c8c8"];
    [vOrder addSubview:lbRightLine];
    
    UILabel *lineCell = [[UILabel alloc]initWithFrame:CGRectMake(10, kHeightCell-1, 264, 0.5)];
    [lineCell setBackgroundColor:[UIColor colorFromHexString:@"#c8c8c8"]];
    [cell addSubview:vOrder];
    [cell addSubview:lbName];
    [cell addSubview:lbAuthor];
    [cell addSubview:lbPrice];
    [cell addSubview:imageView];
    [cell addSubview:lineCell];
}

#pragma mark Event Share
-(void)postFB
{
    //if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    //{
    slc = [ SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    NSMutableArray *arrayImage = [[[SaveDataCartSG listFood] dataListFood] valueForKey:@"product_image"];
    
    for (int i =0; i<[arrayImage count]; i++) {
        NSString *str = [arrayImage objectAtIndex:i];
        [slc addImage:[UIImage imageNamed:str]];
    }
    [self presentViewController:slc animated:YES completion:nil];
    //}
}


-(void)postTwiter
{
    // if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    //{
    slc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    NSMutableArray *arrayImage = [[[SaveDataCartSG listFood] dataListFood] valueForKey:@"product_image"];
    
    for (int i =0; i<[arrayImage count]; i++) {
        NSString *str = [arrayImage objectAtIndex:i];
        [slc addImage:[UIImage imageNamed:str]];
    }
    [self presentViewController:slc animated:YES completion:nil];
    // }
}

-(void)postWeibo
{
    // if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    //{
    slc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
    NSMutableArray *arrayImage = [[[SaveDataCartSG listFood] dataListFood] valueForKey:@"product_image"];
    
    for (int i =0; i<[arrayImage count]; i++) {
        NSString *str = [arrayImage objectAtIndex:i];
        [slc addImage:[UIImage imageNamed:str]];
    }
    [self presentViewController:slc animated:YES completion:nil];
    // }
}

#pragma mark incre,discount count_order
-(void)increaseProduct:(UITapGestureRecognizer *)sender
{
    NSIndexPath *ownerCellIndexPath = [self getIndexpath:sender];
    int get_count_order = [[[[SaveDataCartSG listFood].dataListFood objectAtIndex:ownerCellIndexPath.row] valueForKey:@"count_order"] intValue];
    NSString *str_get_count_order = [NSString stringWithFormat:@"%d",get_count_order+1];
    [[[SaveDataCartSG listFood].dataListFood objectAtIndex:ownerCellIndexPath.row] setObject:str_get_count_order forKey:@"count_order"];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:ownerCellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    [self caculatorTotalPrice:totalAmount];
    
}
-(void)subProduct:(UITapGestureRecognizer *)sender
{
    NSIndexPath *ownerCellIndexPath = [self getIndexpath:sender];
    int get_count_order = [[[[SaveDataCartSG listFood].dataListFood objectAtIndex:ownerCellIndexPath.row] valueForKey:@"count_order"] intValue];
    NSString *str_get_count_order = [NSString stringWithFormat:@"%d",get_count_order-1];
    [[[SaveDataCartSG listFood].dataListFood objectAtIndex:ownerCellIndexPath.row] setObject:str_get_count_order forKey:@"count_order"];
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:ownerCellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    [self caculatorTotalPrice:totalAmount];
}
-(void)deleteProduct:(UITapGestureRecognizer *)sender
{
    NSIndexPath *ownerCellIndexPath = [self getIndexpath:sender];
    [self.tableView beginUpdates];
     [[[SaveDataCartSG listFood] dataListFood] removeObjectAtIndex:ownerCellIndexPath.row];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:ownerCellIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    [self caculatorTotalPrice:totalAmount];
}

-(NSIndexPath *)getIndexpath : (UITapGestureRecognizer *)sender
{
    UIImageView *img = (UIImageView *)sender.view.superview;
    UIView *ui = (UIView *)img.superview;
    UITableViewCell *ownerCell = (UITableViewCell*)ui.superview;
    NSIndexPath *indexPath = [_tableView indexPathForCell:ownerCell];
    return indexPath;
}

@end
