//
//  CMChatController.m
//  01-WCDB
//
//  Created by 23 on 2017/7/18.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMChatController.h"
#import "CMChatToolView.h"
#import "CMEmojiKeyboard.h"

@interface CMChatController ()

@end

@implementation CMChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置UI
    [self setupUI];
    
}

#pragma mark - 设置UI
/**设置UI*/
- (void)setupUI
{
    //设置导航栏
    self.title = @"聊天";
    
    //设置tableView
    [self setupTableView];
    
    //设置toolView
    [self setupToolView];
    
    //设置约束
    [self setupConstraint];
}

/**设置TableView*/
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //其他属性
    self.tableView.estimatedRowHeight = 100.f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

/**设置toolView*/
- (void)setupToolView
{
    CMChatToolView *toolView = [[CMChatToolView alloc] init];
    [self.view addSubview:toolView];
    self.toolView = toolView;
}

/**设置约束*/
- (void)setupConstraint
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.toolView.mas_top);
    }];
    
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
}


#pragma mark - UITableViewDelegate\UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出cell
    NSString * const ID = @"chat";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    //返回
    return cell;
}



@end
