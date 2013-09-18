//
//  SidebarViewController.m
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/5/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import "SidebarViewController.h"
#import "DataListTypeProducts.h"
#import "MainViewController.h"
#import <SWRevealViewController/SWRevealViewController.h>
#import "IDProvince.h"
#define kHeightCell 44
@interface SidebarViewController ()
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) NSString *urlData;
@property (nonatomic,strong) UITableView *mainTableView;
@end

@implementation SidebarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIView *vCity = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 144, 45)];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 24, 24)];
    imageV.image = [UIImage imageNamed:@"local"];
    
    UILabel *lbCity = [[UILabel alloc]initWithFrame:CGRectMake(44, 10, 144, 24)];
    lbCity.text = [IDProvince sharedManager].cuNameProvince;
    [lbCity setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:25]];
    lbCity.textColor = [UIColor colorFromHexString:@"#96ed89"];
    [vCity addSubview:lbCity];
    [vCity addSubview:imageV];
    vCity.backgroundColor = [UIColor colorFromHexString:@"#044d29"];
    
    
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"urlConnect" ofType:@"plist"]];
    NSString *url = [dictRoot valueForKey:@"getListProducts"];
    _urlData = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    [self start];
    
    self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
    [self.mainTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    //self.mainTableView.backgroundColor = [UIColor clearColor];
    //UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    //self.mainTableView.contentInset = inset;
    
    self.mainTableView.tableHeaderView = vCity;
    //self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //self.mainTableView.separatorColor = [UIColor colorFromHexString:@"#3ea352"];
    
    self.mainTableView.backgroundColor = [UIColor colorFromHexString:@"#168039"];
    [self.view addSubview:self.mainTableView];
    [self.view setBackgroundColor:[UIColor clearColor]];
}


#pragma ACTION

-(void)getData :(NSData *)data
{
    NSError *error = nil;
    self.data = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
}

-(void)start
{
    NSURL *getUrl = [NSURL URLWithString:self.urlData];
    [self getData:[NSData dataWithContentsOfURL:getUrl]];
}


#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kHeightCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* theCell = [tableView cellForRowAtIndexPath:indexPath];
    theCell.contentView.backgroundColor=[UIColor colorFromHexString:@"#044d29"];
    
    SWRevealViewController *revealController = [self revealViewController];
    UIViewController *frontViewController = revealController.frontViewController;
    UINavigationController *frontNavigationController =nil;
    
    if ( [frontViewController isKindOfClass:[UINavigationController class]] )
        frontNavigationController = (id)frontViewController;
    
    DataListTypeProducts *dataList = [self.data objectAtIndex:indexPath.row];
    
   // if ( ![frontNavigationController.topViewController isKindOfClass:[MainViewController class]] )
   //{
        MainViewController *mVC = [[MainViewController alloc] init];
        mVC.idTypeProduct = [dataList valueForKey:@"product_type_id"];
        mVC.titleNavigation = [dataList valueForKey:@"product_type_name"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mVC];
        [revealController setFrontViewController:navigationController animated:YES];
  //  }
    // Seems the user attempts to 'switch' to exactly the same controller he came from!
   // else
   // {
   //     [revealController revealToggleAnimated:YES];
   //     NSLog(@"1234");
   // }
}
#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.data objectAtIndex:indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
   // if (cell == nil) {
   //     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  //  }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark ConfigureCell
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    DataListTypeProducts *dataList = [self.data objectAtIndex:indexPath.row];
    UIImageView *imgTP = [[UIImageView alloc]initWithFrame:CGRectMake(10, 9, 24, 24)];
    NSString *urlImage = [NSString stringWithFormat:@"%@%@",URL_IMAGE,[dataList valueForKey:@"product_type_image"]];
    NSURL *imageURL = [NSURL URLWithString:urlImage];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    imgTP.image = [UIImage imageWithData:imageData];
    
    UILabel *lbNameTypeProduct = [[UILabel alloc]initWithFrame:CGRectMake(imgTP.frame.size.width + imgTP.frame.origin.x + 15, 12, 182, 21)];
    [lbNameTypeProduct setFont:[UIFont fontWithName:@"Roboto-Bold" size:17]];
    lbNameTypeProduct.text = [NSString stringWithFormat:@"%@",[dataList valueForKey:@"product_type_name"]];
    lbNameTypeProduct.backgroundColor = [UIColor clearColor];
    lbNameTypeProduct.textColor = [UIColor whiteColor];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, kHeightCell-1, cell.frame.size.width, 1)];
    [line setBackgroundColor:[UIColor colorFromHexString:@"#3ea352"]];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:lbNameTypeProduct];
    [cell addSubview:imgTP];
    [cell addSubview:line];
}
@end
