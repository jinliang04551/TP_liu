//
//  MISTestListTableViewController.m
//  TP_liu
//
//  Created by liu on 2019/9/10.
//  Copyright © 2019 liu. All rights reserved.
//

#import "MISTestListTableViewController.h"

static NSString *testListTableViewCellIndentifier = @"testListTableViewCellIndentifier";

@interface MISTestListTableViewController ()

@property (nonatomic,strong)UITableView *table;
//列表项
@property (nonatomic,strong)NSArray *items;

@end

@implementation MISTestListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.table];
    [self prepareItems];
    [self.table reloadData];
}

- (void)prepareItems {
    
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:testListTableViewCellIndentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:testListTableViewCellIndentifier];
    }
    
    
    return cell;
}

#pragma mark getter and setter
- (UITableView*)table
{
    if (_table == nil) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT) style:UITableViewStylePlain];
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _table.dataSource = self;
        _table.delegate = self;
        _table.backgroundView = nil;
        _table.rowHeight = 44.0;
    }
    return _table;
}



@end
