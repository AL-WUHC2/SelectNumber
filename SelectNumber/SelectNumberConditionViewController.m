//
//  SelectNumberConditionViewController.m
//  SelectNumber
//
//  Created by Char Aznable on 12-12-26.
//  Copyright (c) 2012年 Char Aznable. All rights reserved.
//

#import "SelectNumberConditionViewController.h"
#import "SelectNumberConditionDetailCell.h"
#import "SelectNumberConditionDetailController.h"
#import "SelectNumberCondition.h"
#import "SelectNumberListViewController.h"
#import "SelectNumberAppDelegate.h"

@implementation SelectNumberConditionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
            condition:(SelectNumberCondition *)condition {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _condition = [condition copy];
        
        _conditionControllers = [[NSMutableArray alloc] init];
        
        SelectNumberConditionDetailController *numberSectionController = [[SelectNumberConditionDetailController alloc] initWithSelected:_condition.numSection];
        [_conditionControllers addObject:numberSectionController];
        [numberSectionController release];
        
        SelectNumberConditionDetailController *prePaidFeeController = [[SelectNumberConditionDetailController alloc] initWithSelected:_condition.preFee];
        [_conditionControllers addObject:prePaidFeeController];
        [prePaidFeeController release];
        
        SelectNumberConditionDetailController *numberParttenController = [[SelectNumberConditionDetailController alloc] initWithSelected:_condition.partten];
        [_conditionControllers addObject:numberParttenController];
        [numberParttenController release];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [_pcPicker release];
    [_tableView release];
    [_searchNum release];
    
    [_provinces release];
    [_cities release];
    [_conditionControllers release];
    
    [_condition release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"搜索"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(confirmCondition:)];
    self.navigationItem.rightBarButtonItem = confirmButton;
    [confirmButton release];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(cancelCondition:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    SelectNumberAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.provinces = delegate.provincesAndCities;
    
    [self reloadPcPicker];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *nsList = [bundle pathForResource:@"NumberSection" ofType:@"plist"];
    NSArray *numSec = [[NSArray alloc] initWithContentsOfFile:nsList];
    SelectNumberConditionDetailController *numberSectionController = [self.conditionControllers objectAtIndex:0];
    numberSectionController.conditionList = numSec;
    numberSectionController.title = @"号       段";
    [numSec release];
    
    NSString *pfList = [bundle pathForResource:@"PrePaidFee" ofType:@"plist"];
    NSArray *preFee = [[NSArray alloc] initWithContentsOfFile:pfList];
    SelectNumberConditionDetailController *prePaidFeeController = [self.conditionControllers objectAtIndex:1];
    prePaidFeeController.conditionList = preFee;
    prePaidFeeController.title = @"预存话费";
    [preFee release];
    
    NSString *npList = [bundle pathForResource:@"NumberPartten" ofType:@"plist"];
    NSArray *numPtn = [[NSArray alloc] initWithContentsOfFile:npList];
    SelectNumberConditionDetailController *numberParttenController = [self.conditionControllers objectAtIndex:2];
    numberParttenController.conditionList = numPtn;
    numberParttenController.title = @"靓号类型";
    [numPtn release];
    
    [self reloadSearchNum];
}

- (void)reloadPcPicker {
    NSInteger provinceRow = 0;
    for (NSInteger i = 0; i < [self.provinces count]; i++) {
        if ([self.condition.province isEqualToString:[[self.provinces objectAtIndex:i] objectForKey:@"ProvinceCode"]]) {
            provinceRow = i;
            break;
        }
    }
    [self.pcPicker selectRow:provinceRow inComponent:kProvinceComponent animated:NO];
    
    self.cities = [[self.provinces objectAtIndex:provinceRow] objectForKey:@"Cities"];
    for (NSInteger i = 0; i < [self.cities count]; i++) {
        if ([self.condition.city isEqualToString:[[self.cities objectAtIndex:i] objectForKey:@"CityCode"]]) {
            [self.pcPicker selectRow:i inComponent:kCityComponent animated:NO];
            [self.pcPicker reloadComponent:kCityComponent];
            break;
        }
    }
}

- (void)reloadTableView {
    [(SelectNumberConditionDetailController *)[self.conditionControllers objectAtIndex:0] setSelectedItem:self.condition.numSection];
    [(SelectNumberConditionDetailController *)[self.conditionControllers objectAtIndex:1] setSelectedItem:self.condition.preFee];
    [(SelectNumberConditionDetailController *)[self.conditionControllers objectAtIndex:2] setSelectedItem:self.condition.partten];
    [self.tableView reloadData];
}

- (void)reloadSearchNum {
    self.searchNum.text = self.condition.searchNum;
}

- (void)reloadView {
    [self reloadPcPicker];
    [self reloadTableView];
    [self reloadSearchNum];
}

- (IBAction)backgroundTouched:(id)sender {
    [self textFieldShouldReturn:self.searchNum];
}

- (IBAction)confirmCondition:(id)sender {
    self.condition.numSection = [(SelectNumberConditionDetailController *)[self.conditionControllers objectAtIndex:0] selectedItem];
    self.condition.preFee = [(SelectNumberConditionDetailController *)[self.conditionControllers objectAtIndex:1] selectedItem];
    self.condition.partten = [(SelectNumberConditionDetailController *)[self.conditionControllers objectAtIndex:2] selectedItem];
    [self textFieldShouldReturn:self.searchNum];

    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:YES];
    
    SelectNumberListViewController *parent = (SelectNumberListViewController *)[[navController viewControllers] lastObject];
    SelectNumberCondition *condition = [self.condition copy];
    parent.condition = condition;
    [condition release];
    [parent requestJSONData];
}

- (IBAction)cancelCondition:(id)sender {
    [self textFieldShouldReturn:self.searchNum];
    
    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:YES];
    
//    SelectNumberListViewController *parent = (SelectNumberListViewController *)[[navController viewControllers] lastObject];
//    SelectNumberCondition *condition = [parent.condition copy];
//    self.condition = condition;
//    [condition release];
}

#pragma mark - Picker DataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == kProvinceComponent) return [self.provinces count];
    return [self.cities count];
}

#pragma mark - Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == kProvinceComponent) {
        return [[self.provinces objectAtIndex:row] objectForKey:@"ProvinceName"];
    }
    return [[self.cities objectAtIndex:row] objectForKey:@"CityName"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == kProvinceComponent) {
        self.cities = [[self.provinces objectAtIndex:row] objectForKey:@"Cities"];
        [self.pcPicker selectRow:0 inComponent:kCityComponent animated:YES];
        [self.pcPicker reloadComponent:kCityComponent];
        self.condition.province = [[self.provinces objectAtIndex:row] objectForKey:@"ProvinceCode"];
        self.condition.city = [[self.cities objectAtIndex:0] objectForKey:@"CityCode"];
    } else if (component == kCityComponent) {
        self.condition.city = [[self.cities objectAtIndex:row] objectForKey:@"CityCode"];
    }
}

- (GLfloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return component == kCityComponent ? 170 : 120;
}

#pragma mark - TableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.conditionControllers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *conditionCell = @"conditionDetailCell";
    SelectNumberConditionDetailCell *cell = (SelectNumberConditionDetailCell *)[tableView dequeueReusableCellWithIdentifier:conditionCell];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SelectNumberConditionDetailCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSUInteger row = [indexPath row];
    SelectNumberConditionDetailController *controller = [self.conditionControllers objectAtIndex:row];
    cell.titleLabel.text = controller.title;
    cell.valueLabel.text = controller.selectedItem == @"" ? @"任意" : controller.selectedItem;
    return cell;
}

#pragma mark - TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self textFieldShouldReturn:self.searchNum];
    
    NSUInteger row = [indexPath row];
    SelectNumberConditionDetailController *nextController = [self.conditionControllers objectAtIndex:row];
    [nextController reloadTableView];
    [self.navigationController pushViewController:nextController animated:YES];
}

#pragma mark - TextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchNum) {
        self.condition.searchNum = self.searchNum.text;
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self adjustPanelsWithKeybordHeight:0];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
//    NSLog(@"keyboardWillChangeFrame");
    NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
//    NSLog(@"height = %f",keyboardBounds.size.height);
    [self adjustPanelsWithKeybordHeight:keyboardBounds.size.height];
}

-(void)adjustPanelsWithKeybordHeight:(float)height
{
    [UIView beginAnimations:@"AdjustPanel" context:nil];
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(0, -height, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

@end
