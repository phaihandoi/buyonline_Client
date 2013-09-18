//
//  InfomationShopper.m
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/6/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import "InfomationShopper.h"
#import "ScaleImage.h"
#import "MainViewController.h"
#import "SidebarViewController.h"
#import "DataProducts.h"
#import "CaculateDay.h"
#import "DetailProduct.h"
#import "UIBarButtonItem+Custom.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

#define kHeight 227
@interface InfomationShopper ()
{
    NSMutableArray *_dataUser;
    NSString *_urlDataUser;
    NSMutableArray *_productsUser;
    NSString *_urlProductsUser;
    UITableView *_mainTableView;
}
@end

@implementation InfomationShopper


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"urlConnect" ofType:@"plist"]];
    NSString *url = [dictRoot valueForKey:@"getInfomationUser"];
    NSString *url1 = [dictRoot valueForKey:@"getProductsFromUser"];
    _urlProductsUser = [NSString stringWithFormat:@"%@%@?uid=%@",BASE_URL,url1,self.uid];
    _urlDataUser = [NSString stringWithFormat:@"%@%@?uid=%@",BASE_URL,url,self.uid];
    _dataUser = [self start:_urlDataUser];
    _productsUser = [self start:_urlProductsUser];
    [self configureMainView:_dataUser:_productsUser];
}


#pragma mark ACTION


-(NSMutableArray *)start : (NSString *)str
{
    NSURL *getUrl = [NSURL URLWithString:str];
    NSMutableArray *array = nil;
    NSError *error = nil;
    array = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:getUrl] options:kNilOptions error:&error];
    return array;
}

-(void)configureMainView : (NSMutableArray *)dataUser : (NSMutableArray *)dataListProduct
{
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomBarButtonItem:@"done"
                                                                                frButton:CGRectMake(0, 0, 24, 24)
                                                                                  target:self
                                                                                  action:@selector(doneView)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.title = [dataUser objectAtIndex:1]; // Email user
    UIView *infoUser = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    [infoUser setBackgroundColor:[UIColor colorFromHexString:@"#75c1fc"]];
    UIImageView *bgAvatar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 180)];
    
    NSString *urlImage = [NSString stringWithFormat:@"%@%@",URL_IMAGE,[_dataUser objectAtIndex:8]];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlImage]]];
    UIImage *scaleImg = [ScaleImage imageWithImage:image scaledToSize:CGSizeMake(bgAvatar.frame.size.width, bgAvatar.frame.size.height)];
    bgAvatar.image = scaleImg;
    bgAvatar.alpha = 0.7;
    
    
    UILabel *countProduct = [[UILabel alloc]initWithFrame:CGRectMake(5,185,100, 60)];
    countProduct.lineBreakMode = 0;
    countProduct.numberOfLines = 2;
    countProduct.textAlignment = NSTextAlignmentCenter;
    countProduct.text = [NSString stringWithFormat:@"Số Sản Phẩm: %d",_productsUser.count];
    [countProduct setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:14.0]];
    [countProduct setBackgroundColor:[UIColor clearColor]];
    countProduct.textColor = [UIColor colorFromHexString:@"#a3928d"];
    UILabel *lbPhone = [[UILabel alloc]initWithFrame:CGRectMake(210, 185, 100, 60)];
    lbPhone.lineBreakMode = 0;
    lbPhone.numberOfLines = 2;
    lbPhone.textAlignment = NSTextAlignmentCenter;
    lbPhone.text = [NSString stringWithFormat:@"Số Điện Thoại: %@",[_dataUser objectAtIndex:6]];
    [lbPhone setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:14.0]];
    [lbPhone setBackgroundColor:[UIColor clearColor]];
    lbPhone.textColor = [UIColor colorFromHexString:@"#a3928d"];
    UIView *vAvatar = [[UIView alloc]initWithFrame:CGRectMake(110, 110, 100, 100)];
    [vAvatar setBackgroundColor:[UIColor whiteColor]];
    UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 90, 90)];
    avatar.image = image;
    
    [vAvatar addSubview:avatar];
    
    [infoUser addSubview:lbPhone];
    [infoUser addSubview:countProduct];
    [infoUser addSubview:bgAvatar];
    [infoUser addSubview:vAvatar];
    //[self.view addSubview:infoUser];
    
    //Show products user
    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50)];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_mainTableView];
    _mainTableView.tableHeaderView = infoUser;
    
}
-(void)doneView
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

-(void)checkBookmark
{
    NSLog(@"Check bookmark , neu bookmark roi thi delete , ko thi add vao bookmark");
}

#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_productsUser count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [_productsUser objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    // if (cell == nil) {
    //     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //  }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailProduct *detailVC = [[DetailProduct alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:detailVC];
    detailVC.dataProduct = [_productsUser objectAtIndex:indexPath.row];
    [self presentModalViewController:nav animated:YES];
}
#pragma mark ConfigureCell
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    DataProducts *dataProduct = [_productsUser objectAtIndex:indexPath.row];
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(12,7 , 295, 202)];
    [contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"card"]]];
    
    //Image product
    UIImageView *imageProduct = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 285, 157)];
    NSString *urlImage = [NSString stringWithFormat:@"%@%@",URL_IMAGE,[dataProduct valueForKey:@"product_image"]];
    NSURL *imageURL = [NSURL URLWithString:urlImage];
    [imageProduct setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];
    
    UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(3, imageProduct.frame.origin.y+160, 28, 28)];
    NSString *urlImage1 = [NSString stringWithFormat:@"%@%@",URL_IMAGE,[_dataUser objectAtIndex:8]];
    NSURL *imageURL1 = [NSURL URLWithString:urlImage1];
    [avatar setImageWithURL:imageURL1 placeholderImage:[UIImage imageNamed:@"loading"]];
    avatar.layer.cornerRadius = 2;
    avatar.layer.masksToBounds = YES;
    
    NSString *fStr = [dataProduct valueForKey:@"date_post_product"];
    NSString *m = (NSString *)[[fStr componentsSeparatedByString:@" "]objectAtIndex:0];
    NSString *d = (NSString *)[[fStr componentsSeparatedByString:@" "]objectAtIndex:1];
    NSString *y = (NSString *)[[fStr componentsSeparatedByString:@" "]objectAtIndex:2];
    NSString *thu = [CaculateDay caculateDate:[d intValue] month:[m intValue] year:[y intValue]];

    UILabel *lbThu = [[UILabel alloc]initWithFrame:CGRectMake(23,175 , 35, 12)];
    lbThu.text = thu;
    lbThu.transform = CGAffineTransformMakeRotation(-M_PI/2);
    [lbThu setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    lbThu.textAlignment = NSTextAlignmentCenter;
    lbThu.textColor = [UIColor colorFromHexString:@"#a3928d"];
    
    UILabel *lbDay = [[UILabel alloc]initWithFrame:CGRectMake(50, 165, 33, 27)];
    lbDay.text = d;
    [lbDay setFont:[UIFont fontWithName:@"Helvetica-Bold" size:28]];
    lbDay.textColor = [UIColor colorFromHexString:@"#a3928d"];
    
    NSString *cMonth = [CaculateDay changeMonth:[m intValue]];
    UILabel *lbMonth = [[UILabel alloc]initWithFrame:CGRectMake(lbDay.frame.origin.x + 36, 165, 45, 15)];
    lbMonth.text = cMonth;
    [lbMonth setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:12]];
    lbMonth.textColor = [UIColor colorFromHexString:@"#a3928d"];
    
    UILabel *lbYear = [[UILabel alloc]initWithFrame:CGRectMake(lbDay.frame.origin.x + 36, 181, 45, 13)];
    [lbYear setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:12]];
    lbYear.text = y;
    lbYear.textColor = [UIColor colorFromHexString:@"#a3928d"];
    
    UILabel *lbNameProduct = [[UILabel alloc]initWithFrame:CGRectMake(lbMonth.frame.origin.x + 50, 165, 120, 28)];
    lbNameProduct.text = [NSString stringWithFormat:@"%@",[dataProduct valueForKey:@"product_name"]];
    [lbNameProduct setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    lbNameProduct.textColor = [UIColor colorFromHexString:@"#999999"];
    lbNameProduct.lineBreakMode = 0;
    lbNameProduct.numberOfLines = 2;
    
    UIImageView *imgBookmark = [[UIImageView alloc]initWithFrame:CGRectMake(contentView.frame.size.width-33, 167, 24, 24)];
    imgBookmark.image = [UIImage imageNamed:@"bookmark-add"];
    imgBookmark.userInteractionEnabled= YES;
    UITapGestureRecognizer *tapBookmark = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkBookmark)];
    [imgBookmark addGestureRecognizer:tapBookmark];
    
    [contentView addSubview:imgBookmark];
    [contentView addSubview:lbYear];
    [contentView addSubview:lbMonth];
    [contentView addSubview:lbThu];
    [contentView addSubview:lbDay];
    [cell addSubview:contentView];
    [contentView addSubview:imageProduct];
    [contentView addSubview:lbNameProduct];
    [contentView addSubview:avatar];
}
@end
