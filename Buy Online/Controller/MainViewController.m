//
//  MainViewController.m
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/3/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import "MainViewController.h"
#import "DataProducts.h"
#import "RatingFood.h"
#import "IDProvince.h"
#import "DetailProduct.h"
#import "UIBarButtonItem+Custom.h"
#import "DataManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SWRevealViewController/SWRevealViewController.h>
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>

@interface MainViewController ()
@property (nonatomic,strong) UITableView *mainTableView;
@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = self.titleNavigation;
    
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //self.mainTableView.backgroundColor = [UIColor clearColor];
    //self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    //UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    //self.mainTableView.contentInset = inset;
    //[self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIBarButtonItem *leftbarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu_white"]
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self.revealViewController
                                                                    action:@selector(revealToggle:)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomBarButtonItem:@"fav"
                                                                                     frButton:CGRectMake(0, 0, 24, 24)
                                                                                       target:self
                                                                                       action:@selector(goToBookmark)];
    //[[UINavigationBar appearance] setBackgroundColor:[UIColor colorFromHexString:@"#45bf55"]];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.navigationItem.leftBarButtonItem = leftbarButton;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.view addSubview:self.mainTableView];
    [self setupTableViewFooter];
    
    // set up the paginator
    self.productPaginator = [[ProductPaginator alloc] initWithPageSize:10
                                                              delegate:self
                                                           typeProduct:[self.idTypeProduct intValue]];    
    [self.productPaginator fetchFirstPage];

}

#pragma mark - Paginator delegate methods

- (void)paginator:(id)paginator didReceiveResults:(NSArray *)results
{
    // update tableview footer
    [self updateTableViewFooter];
    [self.activityIndicator stopAnimating];
    
    // update tableview content
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSInteger i = [self.productPaginator.results count] - [results count];
    
    for(NSDictionary *result in results)
    {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        i++;
    }
    
    [self.mainTableView beginUpdates];
    [self.mainTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
    [self.mainTableView endUpdates];
}

#pragma ACTION


- (void)fetchNextPage
{
    [self.productPaginator fetchNextPage];
    [self.activityIndicator startAnimating];
}

- (void)setupTableViewFooter
{
    // set up label
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    footerView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = UITextAlignmentCenter;
    
    self.footerLabel = label;
    [footerView addSubview:label];
    
    // set up activity indicator
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = CGPointMake(40, 22);
    activityIndicatorView.hidesWhenStopped = YES;
    self.activityIndicator = activityIndicatorView;
    [footerView addSubview:activityIndicatorView];
    self.mainTableView.tableFooterView = footerView;
}

- (void)updateTableViewFooter
{
    if ([self.productPaginator.results count] != 0)
    {
        self.footerLabel.text = [NSString stringWithFormat:@"%d results out of %d", [self.productPaginator.results count], self.productPaginator.total];
        for (int i =0; i < self.productPaginator.results.count; i++) {
        }
    } else
    {
        self.footerLabel.text = @"No have product in this category , please contact with shopper";
        self.footerLabel.lineBreakMode = 0;
        self.footerLabel.numberOfLines = 2;
    }
    
    [self.footerLabel setNeedsDisplay];
}
-(void)goToBookmark
{
    NSLog(@"Go to Bookmark");
}

- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:self.mainTableView numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    return background;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    DataProducts *dataProduct = [self.productPaginator.results objectAtIndex:indexPath.row];
    UIImageView *imageProduct = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 58, 58)];
    NSString *urlImage = [NSString stringWithFormat:@"%@%@",URL_IMAGE,[dataProduct valueForKey:@"product_image"]];
    NSURL *imageURL = [NSURL URLWithString:urlImage];
   // [imageProduct setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];
    [imageProduct setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageProgressiveDownload usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    UILabel *lbName = [[UILabel alloc]initWithFrame:CGRectMake(84, 0, 140, 32)];
    lbName.text = [NSString stringWithFormat:@"%@",[dataProduct valueForKey:@"product_name"]];
    [lbName setBackgroundColor:[UIColor clearColor]];
    [lbName setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:13]];
    
    UILabel *lbPrice = [[UILabel alloc]initWithFrame:CGRectMake(84, 40, 102, 25)];
    lbPrice.text = [NSString stringWithFormat:@"Price: %@",[dataProduct valueForKey:@"product_price"]];
    [lbPrice setBackgroundColor:[UIColor clearColor]];
    [lbPrice setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:15]];
    
    UILabel *lbOrder = [[UILabel alloc]initWithFrame:CGRectMake(224, 0, 88, 24)];
    [lbOrder setBackgroundColor:[UIColor clearColor]];
    NSString *strOrder;
    if ([dataProduct valueForKey:@"quantity"] ==  [NSNull null]) {
        strOrder = [NSString stringWithFormat:@"Đặt hàng: 0"];
    }else {
        strOrder = [NSString stringWithFormat:@"Đặt hàng : %@",[dataProduct valueForKey:@"quantity"]];
    }
    lbOrder.text = strOrder;
    [lbOrder setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:12]];
    
    
    UILabel *lbAuthor = [[UILabel alloc]initWithFrame:CGRectMake(194, 24, 118, 24)];
    lbAuthor.text = [NSString stringWithFormat:@"%@",[dataProduct valueForKey:@"name"]];
    [lbAuthor setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:14]];
    [lbAuthor setBackgroundColor:[UIColor clearColor]];
    
    UIView *ratingView = [[UIView alloc]initWithFrame:CGRectMake(210, 40, 118, 23)];
    int r = arc4random() % 6;
    [RatingFood checkRate:r :ratingView];    
    
    [cell addSubview:ratingView];
    [cell addSubview:lbAuthor];
    [cell addSubview:lbOrder];
    [cell addSubview:lbName];
    [cell addSubview:lbPrice];
    [cell addSubview:imageProduct];
    
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // when reaching bottom, load a new page
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.bounds.size.height)
    {
        // ask next page only if we haven't reached last page
        if(![self.productPaginator reachedLastPage])
        {
            // fetch next page of results
            [self fetchNextPage];
        }
    }
}

#pragma mark UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailProduct *detailVC = [[DetailProduct alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:detailVC];
    detailVC.dataProduct = [self.productPaginator.results objectAtIndex:indexPath.row];
    [self presentModalViewController:nav animated:YES];
}

#pragma mark UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return [self.productPaginator.results count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
//    if (!cell) {
      UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    //cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

@end
