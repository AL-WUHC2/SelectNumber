//
//  SelectNumberConditionDetailController.h
//  SelectNumber
//
//  Created by Char Aznable on 12-12-26.
//  Copyright (c) 2012年 Char Aznable. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectNumberConditionDetailController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSArray *conditionList;
@property (nonatomic, retain) NSIndexPath *lastIndexPath;
@property (nonatomic, copy) NSString *selectedItem;

- (id)initWithSelected:(NSString *)selectedItem;
- (void)reloadTableView;
- (IBAction)goBack:(id)sender;

@end
