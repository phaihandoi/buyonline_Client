//
//  FirstViewController.m
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/3/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import "FirstViewController.h"
#import "MainViewController.h"
#import "SidebarViewController.h"
#import "IDProvince.h"
#import "ConnectInternet.h"
#import "DataManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
@interface FirstViewController ()
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) NSString *urlData;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSString *nameProvince;
@property (nonatomic,strong) NSString * idProvince;
@property (nonatomic,strong) DataManager *dataManager;
@end

@implementation FirstViewController
UIImageView *imgCity;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"Chọn thành phố";
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"urlConnect" ofType:@"plist"]];
    NSString *url = [dictRoot valueForKey:@"getProvinces"];
    self.urlData = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    
    [self start];
    
    UILabel *lbInstructions = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, self.view.frame.size.width, 40)];
    [lbInstructions setBackgroundColor:[UIColor orangeColor]];
    [lbInstructions setText:@"Chọn thành phố :"];
    lbInstructions.textAlignment = NSTextAlignmentCenter;
    [lbInstructions setFont:[UIFont fontWithName:@"Arial" size:18]];
    lbInstructions.lineBreakMode = 0;
    lbInstructions.numberOfLines = 2;
    [self.view addSubview:lbInstructions];
    
    imgCity = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                           lbInstructions.frame.size.height + lbInstructions.frame.origin.y,
                                                           self.view.frame.size.width,
                                                           self.view.frame.size.height - 162 - 40 - lbInstructions.frame.size.height -lbInstructions.frame.origin.y)];
    
    NSString *urlImageCity = [NSString stringWithFormat:@"%@%@",URL_IMAGE,[[self.data objectAtIndex:0] valueForKey:@"province_image"]];
    NSURL *imageURL = [NSURL URLWithString:urlImageCity];
    [imgCity setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];
    
//    [imgCity setImageWithURL:imageURL usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    imgCity.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imgCity];
    
    
    UIToolbar *toolbar= [[UIToolbar alloc]initWithFrame:CGRectMake(0, imgCity.frame.origin.y + imgCity.frame.size.height, self.view.frame.size.width, 40)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleBordered target: self action: @selector(doneChooseProvince)];
    toolbar.items = [NSArray arrayWithObject: doneButton];
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, toolbar.frame.size.height + toolbar.frame.origin.y, self.view.frame.size.width, 162)];
    [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:self.pickerView];
    
    [self.view addSubview: toolbar];

}

//#pragma mark View Will Appear
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    self.dataManager = [[DataManager alloc]init];
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"position" ascending:YES];
//    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
//    NSArray *dataCoreData = [self.dataManager fetRecordsOfEntity:@"Province" withSortDescriptors:sortDescriptors];
//    
//    //Check connect Internet
//    if ([[ConnectInternet sharedManager] flagConnectInterNet]) {
//        //Have Internet
//        
//        
//    }else {
//        //No have Internet
//        self.data = [[NSMutableArray alloc]initWithArray:dataCoreData];
//        [self.view setNeedsDisplay];
//        [self.pickerView reloadInputViews];
//    }
//}
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

-(void)doneChooseProvince
{
    MainViewController *mVC = [[MainViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mVC];
    
    SidebarViewController *sideVC = [[SidebarViewController alloc]init];
    
    mVC.titleNavigation = @"Sản Phẩm";
    SWRevealViewController *revealController = [[SWRevealViewController alloc]
                                                initWithRearViewController:sideVC
                                                frontViewController:nav];
    revealController.delegate = self;
    self.viewController1=revealController;
    
    [self presentViewController:self.viewController1 animated:YES completion:nil];
 
}

#pragma mark – Picker Datasource:

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return self.data.count;
}

#pragma mark – Picker Delegate:

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [[self.data objectAtIndex:row] valueForKey:@"province_name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //self.idProvince = [NSString stringWithFormat:@"%d",row];
    self.nameProvince = [[self.data objectAtIndex:row] valueForKey:@"province_name"];
    [IDProvince sharedManager].cuIdProvince = [NSString stringWithFormat:@"%@",[[self.data objectAtIndex:row] valueForKey:@"province_id"]];
    [IDProvince sharedManager].cuNameProvince = self.nameProvince;
    
    NSString *urlImageCity = [NSString stringWithFormat:@"%@%@",URL_IMAGE,[[self.data objectAtIndex:row ] valueForKey:@"province_image"]];
    NSURL *imageURL = [NSURL URLWithString:urlImageCity];
    [imgCity setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"loading"]];
}
@end
