//
//  SelectNumberMasterViewController.h
//  SelectNumber
//
//  Created by Char Aznable on 12-12-25.
//  Copyright (c) 2012年 Char Aznable. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define kIndicatorBackgroundTag     1024
#define kIndicatorTag               2048

@class SelectNumberConditionViewController;
@class SelectNumberCondition;
@class SelectNumberListDetailController;

@interface SelectNumberListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, CLLocationManagerDelegate>

@property (nonatomic, retain) NSMutableArray *numberList;

@property (nonatomic, retain) SelectNumberCondition *condition;

@property (nonatomic, retain) SelectNumberConditionViewController *conditionController;

@property (nonatomic, retain) SelectNumberListDetailController *detailController;

@property (nonatomic, retain) NSMutableData *responseData;

@property (nonatomic, retain) UIView *indicatorBackground;

@property (nonatomic, retain) UIActivityIndicatorView *indicator;

@property (nonatomic, retain) CLLocationManager *locationManager;

- (IBAction)refreshList:(id)sender;
- (IBAction)gotoCondition:(id)sender;
- (IBAction)selectNumber:(id)sender;

- (void)requestJSONData;

@end
