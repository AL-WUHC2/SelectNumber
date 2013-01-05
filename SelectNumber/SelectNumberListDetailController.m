//
//  SelectNumberListDetailControllerViewController.m
//  SelectNumber
//
//  Created by Char Aznable on 12-12-28.
//  Copyright (c) 2012年 Char Aznable. All rights reserved.
//

#import "SelectNumberListDetailController.h"
#import "SelectNumberInfo.h"

#import "NumberFormatUtils.h"

@implementation SelectNumberListDetailController

- (void)dealloc {
    [_numInfo release];
    [_infoLabels release];
    
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *labels = [[NSArray alloc] initWithObjects:@"号码:", @"预存款:", nil];
    self.infoLabels = labels;
    [labels release];
    
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStyleDone target:self action:@selector(selectNumber:)];
    self.navigationItem.rightBarButtonItem = confirmButton;
    [confirmButton release];
}

- (IBAction)selectNumber:(id)sender {
    NSString *number = [NumberFormatUtils initFormat344:self.numInfo.numID];
    NSString *message = [[NSString alloc] initWithFormat:@"您选择了号码: %@", number];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:message delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alert show];
    [alert release];
    [message release];
    [number release];
}

#pragma mark - TableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.infoLabels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NumberInfoDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
        cell.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 75, 25)];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont boldSystemFontOfSize:17];
        label.tag = kNumLabelTag;
        [cell.contentView addSubview:label];
        [label release];
        
        UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 200, 25)];
        info.textAlignment = NSTextAlignmentRight;
        info.font = [UIFont systemFontOfSize:17];
        info.textColor = [UIColor blueColor];
        info.tag = kNumInfoTag;
        [cell.contentView addSubview:info];
        [info release];
    }
    
    NSUInteger row = [indexPath row];
    
    UILabel *label = (UILabel *)[cell viewWithTag:kNumLabelTag];
    label.text = [self.infoLabels objectAtIndex:row];
    
    NSString *numText = [NumberFormatUtils initFormat344:self.numInfo.numID];
    NSString *feeText = [[NSString alloc] initWithFormat:@"%@元", self.numInfo.numPreFee];
    
    UILabel *info = (UILabel *)[cell viewWithTag:kNumInfoTag];
    switch (row) {
        case kNumIDRowIndex:
            info.text = numText;
            break;
        case kNumPreFeeRowIndex:
            info.text = feeText;
            break;
        default:
            break;
    }
    
    [numText release];
    [feeText release];
    
    return cell;
}

#pragma mark - TableView Delegate Methods

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
