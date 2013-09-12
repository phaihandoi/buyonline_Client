//
//  FirstViewController.m
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/3/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import "FirstViewController.h"
#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "SidebarViewController.h"
#import "IDProvince.h"
@interface FirstViewController ()
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) NSString *urlData;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSString *nameProvince;
@property (nonatomic,strong) NSString * idProvince;
@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"Chọn thành phố";
    
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"urlConnect" ofType:@"plist"]];
    NSString *url = [dictRoot valueForKey:@"getProvinces"];
    self.urlData = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    
    [self start];
    
    UILabel *lbInstructions = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 80)];
    [lbInstructions setText:@"Chọn thành phố bạn đang sinh sống :"];
    lbInstructions.textAlignment = NSTextAlignmentCenter;
    [lbInstructions setFont:[UIFont fontWithName:@"Arial" size:25]];
    lbInstructions.lineBreakMode = 0;
    lbInstructions.numberOfLines = 2;
    [self.view addSubview:lbInstructions];
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-216, self.view.frame.size.width, 400)];
    [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:self.pickerView];
    
    UIToolbar *toolbar= [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.pickerView.frame.origin.y-40, self.view.frame.size.width, 40)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleBordered target: self action: @selector(doneChooseProvince)];    
    toolbar.items = [NSArray arrayWithObject: doneButton];
    [self.view addSubview: toolbar];

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

-(void)doneChooseProvince
{
    MainViewController *mVC = [[MainViewController alloc]init];
    SidebarViewController *sideVC = [[SidebarViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mVC];
    
//    mVC.idProvince = self.idProvince;
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
}
@end
