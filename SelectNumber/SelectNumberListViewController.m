//
//  SelectNumberMasterViewController.m
//  SelectNumber
//
//  Created by Char Aznable on 12-12-25.
//  Copyright (c) 2012年 Char Aznable. All rights reserved.
//

#import "SelectNumberListViewController.h"
#import "SelectNumberListCell.h"
#import "SelectNumberInfo.h"
#import "JSONKit.h"
#import "SelectNumberConditionViewController.h"
#import "SelectNumberCondition.h"
#import "SelectNumberListDetailController.h"
#import "SelectNumberAppDelegate.h"

#import "URLUtils.h"
#import "NumberFormatUtils.h"

@implementation SelectNumberListViewController

- (void)dealloc {
    [_numberList release];
    [_condition release];
    [_conditionController release];
    [_detailController release];
    [_responseData release];
    [_indicatorBackground release];
    [_indicator release];
    [_locationManager release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *tempList = [[NSMutableArray alloc] init];
    self.numberList = tempList;
    [tempList release];
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager = locationManager;
    [locationManager release];
    
    // TODO

    SelectNumberCondition *condition = [[SelectNumberCondition alloc] initWithProvince:@"11" city:@"110" numSection:@"" preFee:@"" partten:@"" searchNum:@""];
    self.condition = condition;
    [condition release];
    
    SelectNumberConditionViewController *conditionController = [[SelectNumberConditionViewController alloc] initWithNibName:@"SelectNumberConditionViewController" bundle:[NSBundle mainBundle] condition:self.condition];
    conditionController.title = @"高级搜索";
    self.conditionController = conditionController;
    [conditionController release];
    
    SelectNumberListDetailController *detailController = [[SelectNumberListDetailController alloc] initWithStyle:UITableViewStyleGrouped];
    detailController.title = @"号码详情";
    self.detailController = detailController;
    [detailController release];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.responseData = data;
    [data release];
    
    UIView *indicatorBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    [indicatorBackground setTag:kIndicatorBackgroundTag];
    [indicatorBackground setBackgroundColor:[UIColor blackColor]];
    [indicatorBackground setAlpha:0.6];
    self.indicatorBackground = indicatorBackground;
    [indicatorBackground release];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [indicator setTag:kIndicatorTag];
    [indicator setCenter:self.indicatorBackground.center];
    [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator = indicator;
    [indicator release];
    
    [self.tableView addSubview:self.indicatorBackground];
    [self.indicatorBackground addSubview:self.indicator];

    [self updateLocation];
}

- (IBAction)refreshList:(id)sender {
    [self requestJSONData];
}

- (IBAction)gotoCondition:(id)sender {
    self.conditionController.condition = self.condition;
    [self.conditionController reloadView];
    [self.navigationController pushViewController:self.conditionController animated:YES];
}

- (IBAction)selectNumber:(id)sender {
    NSString *message = [[NSString alloc] initWithFormat:@"您选择了号码: %@", [[sender number] text]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [message release];
}

- (void)requestJSONData {
    [self.indicator startAnimating];
    [self.indicatorBackground setHidden:NO];
    
    static NSString *format = @"http://num.10010.com/NumApp/chseNumList/serchNums?province=%@&cityCode=%@&preFeeSel=%@&keyValue=%@&roleValue=%@&searchType=02&sortType=numAsc&searchValue=%@";
    NSString *url = [[NSString alloc] initWithFormat:format,
                     [URLUtils encodeUrlString:self.condition.province],
                     [URLUtils encodeUrlString:self.condition.city],
                     [URLUtils encodeUrlString:self.condition.preFee],
                     [URLUtils encodeUrlString:self.condition.numSection],
                     [URLUtils encodeUrlString:self.condition.partten],
                     [URLUtils encodeUrlString:self.condition.searchNum]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [url release];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)updateLocation {
    [self.locationManager startUpdatingLocation];
}

- (void)errorAlert {
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"定位服务失败!\n使用默认归属地: 北京" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [errorAlert show];
    [errorAlert release];
    
    self.condition.province = @"11";
    self.condition.city = @"110";
}

#pragma mark - CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self errorAlert];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (newLocation == nil) {
        [self errorAlert];
        return;
    }
    
    [self.locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks lastObject];
            NSString *provinceName = placemark.administrativeArea;
            NSString *cityName = placemark.locality;
            
            NSString *pName = ([provinceName hasPrefix:@"内蒙古"] || [provinceName hasPrefix:@"黑龙江"]) ? [provinceName substringWithRange:NSMakeRange(0, 3)] : [provinceName substringWithRange:NSMakeRange(0, 2)];
            NSString *cName = cityName == nil ? @"" : [cityName hasSuffix:@"市"] ? [cityName substringWithRange:NSMakeRange(0, [cityName length] - 1)] : cityName;
            
            SelectNumberAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            NSArray *pcList = delegate.provincesAndCities;
            for (NSDictionary *pInfo in pcList) {
                if ([pName isEqualToString:(NSString *)[pInfo objectForKey:@"ProvinceName"]]) {
                    self.condition.province = [pInfo objectForKey:@"ProvinceCode"];
                    NSArray *cList = [pInfo objectForKey:@"Cities"];
                    self.condition.city = [[cList objectAtIndex:0] objectForKey:@"CityCode"];
                    for (NSDictionary *cInfo in cList) {
                        if ([cName isEqualToString:(NSString *)[cInfo objectForKey:@"CityName"]]) {
                            self.condition.city = [cInfo objectForKey:@"CityCode"];
                            break;
                        }
                    }
                    break;
                }
            }
        } else {
            [self errorAlert];
        }
        [self requestJSONData];
    }];

    [geocoder release];
}

#pragma mark - URLConnection Delegate Methods

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse {
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"获取号码列表失败" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSDictionary *result = (NSDictionary *)[self.responseData mutableObjectFromJSONData];

    [self.numberList removeAllObjects];
    NSArray *numMemoList = [result objectForKey:@"numMemoList"];
    NSArray *moreNumArray = [result objectForKey:@"moreNumArray"];
    for(NSInteger i = 0; i < [moreNumArray count]; i += 6){
        SelectNumberInfo *info = [[SelectNumberInfo alloc] init];

        NSString *numID = [[NSString alloc] initWithFormat:@"%@", [moreNumArray objectAtIndex:i]];
        info.numID = numID;
        [numID release];

        NSString *numPreFee = [[NSString alloc] initWithFormat:@"%@", [moreNumArray objectAtIndex:i + 1]];
        info.numPreFee = numPreFee;
        [numPreFee release];

        NSString *numMemo = [numMemoList objectAtIndex:[(NSNumber *)[moreNumArray objectAtIndex:i + 2] unsignedIntegerValue]];
        info.numMemo = numMemo;

        NSString *numLevel = [[NSString alloc] initWithFormat:@"%@", [moreNumArray objectAtIndex:i + 3]];
        info.numLevel = numLevel;
        [numLevel release];

        NSString *city = [[NSString alloc] initWithFormat:@"%@", [moreNumArray objectAtIndex:i + 4]];
        info.city = city;
        [city release];

        NSString *niceRuleTag = [[NSString alloc] initWithFormat:@"%@", [moreNumArray objectAtIndex:i + 5]];
        info.niceRuleTag = niceRuleTag;
        [niceRuleTag release];

        [self.numberList addObject:info];
        [info release];
    }
    
    [self.tableView reloadData];
    
    [self.indicator stopAnimating];
    [self.indicatorBackground setHidden:YES];
}

#pragma mark - Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.numberList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *selectNumberCell = @"selectNumberListCell";
    SelectNumberListCell *cell = (SelectNumberListCell *)[tableView dequeueReusableCellWithIdentifier:selectNumberCell];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectNumberListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
    SelectNumberInfo *numInfo = [self.numberList objectAtIndex:row];
    NSString *show = [NumberFormatUtils initFormat344:numInfo.numID];
    cell.number.text = show;
    [show release];
    NSString *feeText = [[NSString alloc] initWithFormat:@"%@元", numInfo.numPreFee];
    cell.preFee.text = feeText;
    [feeText release];
    return cell;
}

#pragma mark - TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectNumber:[self.tableView cellForRowAtIndexPath:indexPath]];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    SelectNumberInfo *numInfo = [self.numberList objectAtIndex:row];
    self.detailController.numInfo = numInfo;
    [self.detailController.tableView reloadData];
    [self.navigationController pushViewController:self.detailController animated:YES];
}

@end
