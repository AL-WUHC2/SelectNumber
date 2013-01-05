//
//  SelectNumberConditionDetailController.m
//  SelectNumber
//
//  Created by Char Aznable on 12-12-26.
//  Copyright (c) 2012年 Char Aznable. All rights reserved.
//

#import "SelectNumberConditionDetailController.h"
#import "SelectNumberConditionViewController.h"

@implementation SelectNumberConditionDetailController

- (id)initWithSelected:(NSString *)selectedItem {
    self = [super init];
    if (self) {
        _selectedItem = [selectedItem copy];
    }
    return self;
}

- (void)dealloc {
    [_conditionList release];
    [_lastIndexPath release];
    [_selectedItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *goBackButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(goBack:)];
    self.navigationItem.leftBarButtonItem = goBackButton;
    [goBackButton release];
    
    [self reloadTableView];
}

- (void)reloadTableView {
    NSInteger initRow = 0;
    for (NSInteger i = 0; i < [self.conditionList count]; i++) {
        if ([self.selectedItem isEqualToString:[self.conditionList objectAtIndex:i]]) {
            initRow = i;
            break;
        }
    }
    
    NSUInteger newIndex[] = {0, initRow};
    self.lastIndexPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
    
    [self.tableView reloadData];
}

- (IBAction)goBack:(id)sender {
    UINavigationController *navController = self.navigationController;
    [navController popViewControllerAnimated:YES];
    SelectNumberConditionViewController *parent = (SelectNumberConditionViewController *)[[navController viewControllers] lastObject];
    [parent.tableView reloadData];
}

#pragma mark - TableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.conditionList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ConditionSelectCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    }
    
    NSUInteger row = [indexPath row];
    NSUInteger lastRow = [self.lastIndexPath row];
    cell.textLabel.text = [self.conditionList objectAtIndex:row];
    if ([cell.textLabel.text isEqualToString:@"###"]) cell.textLabel.text = @"任意";
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.accessoryType = (row == lastRow && self.lastIndexPath != nil) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - TableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = [indexPath row];
    int lastRow = [self.lastIndexPath row];
    
    if (row != lastRow) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
        lastCell.accessoryType = UITableViewCellAccessoryNone;
        
        self.lastIndexPath = indexPath;
        self.selectedItem = [self.conditionList objectAtIndex:row];
        if ([self.selectedItem isEqualToString:@"###"]) self.selectedItem = @"";
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
