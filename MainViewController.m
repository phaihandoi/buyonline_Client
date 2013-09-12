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
#import "SWRevealViewController.h"
#import "IDProvince.h"
#import "DetailProduct.h"
#import "UIBarButtonItem+Custom.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MainViewController ()
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) UINavigationBar *navBar;
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
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    self.mainTableView.backgroundColor = [UIColor clearColor];
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.mainTableView.contentInset = inset;
    
    [self.view addSubview:self.mainTableView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIBarButtonItem *leftbarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStyleBordered target:self.revealViewController action:@selector(revealToggle:)];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomBarButtonItem:@"bookmark1"
                                                                                     frButton:CGRectMake(0, 0, 24, 24)
                                                                                       target:self
                                                                                       action:@selector(goToBookmark)];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.navigationItem.leftBarButtonItem = leftbarButton;
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self setupTableViewFooter];
    
    // set up the paginator
    self.flickrPaginator = [[FlickrPaginator alloc] initWithPageSize:10 delegate:self typeProduct:[self.idTypeProduct intValue]];
    [self.flickrPaginator fetchFirstPage];

}

#pragma mark - Paginator delegate methods

- (void)paginator:(id)paginator didReceiveResults:(NSArray *)results
{
    // update tableview footer
    [self updateTableViewFooter];
    [self.activityIndicator stopAnimating];
    
    // update tableview content
    // easy way : call [tableView reloadData];
    // nicer way : use insertRowsAtIndexPaths:withAnimation:
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSInteger i = [self.flickrPaginator.results count] - [results count];
    
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
    [self.flickrPaginator fetchNextPage];
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
    if ([self.flickrPaginator.results count] != 0)
    {
        self.footerLabel.text = [NSString stringWithFormat:@"%d results out of %d", [self.flickrPaginator.results count], self.flickrPaginator.total];
        for (int i =0; i < self.flickrPaginator.results.count; i++) {
        }
    } else
    {
        self.footerLabel.text = @"No have product in this category , please contact with shopper";
        self.footerLabel.lineBreakMode = 0;
        self.footerLabel.numberOfLines = 2;
    }
    
    [self.footerLabel setNeedsDisplay];
}

- (void)clearButtonPressed:(id)sender
{
    [self.flickrPaginator fetchFirstPage];
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
    DataProducts *dataProduct = [self.flickrPaginator.results objectAtIndex:indexPath.row];
    UIImageView *imageProduct = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 58, 58)];
    NSString *urlImage = [NSString stringWithFormat:@"%@%@",URL_IMAGE,[dataProduct valueForKey:@"product_image"]];
    NSURL *imageURL = [NSURL URLWithString:urlImage];    
    
    [imageProduct setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];  
    
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
        if(![self.flickrPaginator reachedLastPage])
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
    detailVC.dataProduct = [self.flickrPaginator.results objectAtIndex:indexPath.row];
    [self presentModalViewController:nav animated:YES];

}

#pragma mark UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return [self.flickrPaginator.results count];
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
    if ([self.flickrPaginator.results count] > 0) {
        NSLog(@"%d",[self.flickrPaginator.results count]);
        [self configureCell:cell atIndexPath:indexPath];
    }else{
        NSLog(@"nil data");
    }
    return cell;
}

@end
