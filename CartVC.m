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

#import <SDWebImage/UIImageView+WebCache.h>
#import <Social/Social.h>
@interface CartVC ()
{
    NSIndexPath *indexPathRow;
    SLComposeViewController *slc;
    UILabel *totalAmount;
}
@end

@implementation CartVC
@synthesize getData=_getData;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.   
    self.title = @"Your Cart";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [[[SaveDataCartSG listFood] dataListFood] addObject:_getData];
    
    UILabel *totalAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height - 180, 180, 25)];
    totalAmountLabel.text = @"Total Amount";
    totalAmount = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-90, self.view.frame.size.height - 180, 100, 25)];
    UIButton *continueBuy = [UIButton buttonWithType:UIButtonTypeCustom];
    [continueBuy setBackgroundImage:[UIImage imageNamed:@"continue_buy"] forState:UIControlStateNormal];
    [continueBuy setFrame:CGRectMake(70, self.view.frame.size.height-140, 60, 60)];
    [continueBuy addTarget:self action:@selector(continueBuyFood) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *payment = [UIButton buttonWithType:UIButtonTypeCustom];
    [payment setBackgroundImage:[UIImage imageNamed:@"payment"] forState:UIControlStateNormal];
    [payment setFrame:CGRectMake(self.view.frame.size.width- 120, self.view.frame.size.height-140, 60, 60)];
    [payment addTarget:self action:@selector(paymentMoney) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *socialV = [[UIView alloc]initWithFrame:CGRectMake(0, 330, self.view.frame.size.width, 35)];
    UIImageView *imgFace = [[UIImageView alloc]initWithFrame:CGRectMake(56, 0, 36, 36)];
    imgFace.image = [UIImage imageNamed:@"facebook"];
    UIImageView *imgTwitter = [[UIImageView alloc]initWithFrame:CGRectMake(94, 2, 33, 33)];
    imgTwitter.image = [UIImage imageNamed:@"twitter"];
    UIImageView *imgRSS = [[UIImageView alloc]initWithFrame:CGRectMake(128, 0, 36, 36)];
    imgRSS.image = [UIImage imageNamed:@"rss"];
    
    [socialV addSubview:imgRSS];
    [socialV addSubview:imgTwitter];
    [socialV addSubview:imgFace];
    
    imgRSS.userInteractionEnabled = YES;
    imgTwitter.userInteractionEnabled = YES;
    imgFace.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapFa = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postFB)];
    [imgFace addGestureRecognizer:tapFa];
    
    UITapGestureRecognizer *tapTW = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(postTwiter)];
    [imgTwitter addGestureRecognizer:tapTW];
    
    [self.view addSubview:_tableView];
    [self.view addSubview:continueBuy];
    [self.view addSubview:payment];
    [self.view addSubview:socialV];
    [self.view addSubview:totalAmountLabel];
    [self.view addSubview:totalAmount];
    [self caculatorTotalPrice:totalAmount];
}

-(void)postFB
{    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        slc = [ SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        NSMutableArray *arrayImage = [[[SaveDataCartSG listFood] dataListFood] valueForKey:@"product_image"];
        
        for (int i =0; i<[arrayImage count]; i++) {
            NSString *str = [arrayImage objectAtIndex:i];            
            [slc addImage:[UIImage imageNamed:str]];            
        }
        [self presentViewController:slc animated:YES completion:nil];        
    }
}
-(void)postTwiter
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        slc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSMutableArray *arrayImage = [[[SaveDataCartSG listFood] dataListFood] valueForKey:@"product_image"];
        
        for (int i =0; i<[arrayImage count]; i++) {
            NSString *str = [arrayImage objectAtIndex:i];
            [slc addImage:[UIImage imageNamed:str]];
        }        
        [self presentViewController:slc animated:YES completion:nil];
    }
}

-(void)caculatorTotalPrice : (UILabel *)label
{
    int totalPrice = 0;
    for (id obj in [[SaveDataCartSG listFood]dataListFood]) {
        totalPrice += [[obj valueForKey:@"product_price"]intValue];
    }
    label.text = [NSString stringWithFormat:@"$ %d",totalPrice];
    
}

-(void)continueBuyFood
{
    MainViewController *mVC = [[MainViewController alloc]init];
    SidebarViewController *sideVC = [[SidebarViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mVC];
    
    //mVC.idProvince = self.idProvince;
    mVC.titleNavigation = @"Sản Phẩm";
    SWRevealViewController *revealController = [[SWRevealViewController alloc]
                                                initWithRearViewController:sideVC
                                                frontViewController:nav];
    revealController.delegate = self;
    self.viewController1=revealController;
    
    [self presentViewController:self.viewController1 animated:YES completion:nil];
    
}

-(void)paymentMoney
{
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    ThankYouVC *main = [storyboard instantiateViewControllerWithIdentifier:@"ThankYouVC"];
//    main.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:main animated:YES completion:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
    
    DataProducts *data = [[[SaveDataCartSG listFood]dataListFood] objectAtIndex:indexPath.row];
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 58, 58)];
    NSString *urlImage = [NSString stringWithFormat:@"%@%@",URL_IMAGE,[data valueForKey:@"product_image"]];
    NSURL *imageURL = [NSURL URLWithString:urlImage];
    
    [imageView setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 20, 120, 31)];
    NSString *priceAFood = [NSString stringWithFormat:@"%@ VND",[data valueForKey:@"product_price"]];
    priceLabel.text = priceAFood;
    priceLabel.textColor = [UIColor orangeColor];
    priceLabel.font = [UIFont fontWithName:@"GillSans-Bold" size:18];
//    indexPathRow = indexPath;
//    cell.tag = indexPath.row;
//    UISwipeGestureRecognizer *swipeLeftRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//    swipeLeftRight.view.tag = indexPath.row;
//    [swipeLeftRight setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft )];
//    [cell addGestureRecognizer:swipeLeftRight];    
    
    [cell addSubview:imageView];
    [cell addSubview:priceLabel];
    return cell;
}
//-(void)handleGesture : (UIGestureRecognizer *)gec
//{
//    if (gec.state == UIGestureRecognizerStateEnded) {
//        UITableViewCell *cell = (UITableViewCell *)gec.view;
//        UIImageView *imgDelete = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-40, 15, 35, 35)];
//        UITapGestureRecognizer *deleteCell = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteC:)];
//        [imgDelete addGestureRecognizer:deleteCell];
//        imgDelete.image = [UIImage imageNamed:@"delete.png"];
//        imgDelete.userInteractionEnabled = YES;
//        [cell bringSubviewToFront:imgDelete];
//        
//        [UIView animateWithDuration:0.5
//                         animations:^(void){
//                [cell addSubview:imgDelete];
//                         }completion:nil];
//    }
//}
//-(void)deleteC : (UITapGestureRecognizer *)sender
//{
//    UITableViewCell *ownerCell = (UITableViewCell*)sender.view.superview;
//    NSIndexPath *ownerCellIndexPath = [_tableView indexPathForCell:ownerCell];
//    
//    [[[SaveDataCartSG listFood] dataListFood] removeObjectAtIndex:indexPathRow.row];
//    [self.tableView reloadData];
//    [self caculatorTotalPrice:totalAmount];
//}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[[SaveDataCartSG listFood] dataListFood] removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
        [self caculatorTotalPrice:totalAmount];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[SaveDataCartSG listFood] dataListFood ] count];
}

@end
