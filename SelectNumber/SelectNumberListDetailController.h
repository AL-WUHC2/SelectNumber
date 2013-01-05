//
//  SelectNumberListDetailControllerViewController.h
//  SelectNumber
//
//  Created by Char Aznable on 12-12-28.
//  Copyright (c) 2012年 Char Aznable. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kNumIDRowIndex      0
#define kNumPreFeeRowIndex  1

#define kNumLabelTag    1024
#define kNumInfoTag     2048

@class SelectNumberInfo;

@interface SelectNumberListDetailController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) SelectNumberInfo *numInfo;
@property (nonatomic, retain) NSArray *infoLabels;

- (IBAction)selectNumber:(id)sender;

@end
