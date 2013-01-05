//
//  SelectNumberConditionViewController.h
//  SelectNumber
//
//  Created by Char Aznable on 12-12-26.
//  Copyright (c) 2012年 Char Aznable. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kProvinceComponent  0
#define kCityComponent      1

@class SelectNumberCondition;

@interface SelectNumberConditionViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UIPickerView *pcPicker;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UITextField *searchNum;

@property (nonatomic, retain) NSArray *provinces;
@property (nonatomic, retain) NSArray *cities;
@property (nonatomic, retain) NSMutableArray *conditionControllers;

@property (nonatomic, retain) SelectNumberCondition *condition;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
            condition:(SelectNumberCondition *)condition;

- (void)reloadPcPicker;
- (void)reloadTableView;
- (void)reloadSearchNum;

- (void)reloadView;

- (IBAction)backgroundTouched:(id)sender;

@end
