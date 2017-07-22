//
//  CMChatController.h
//  01-WCDB
//
//  Created by 23 on 2017/7/18.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMChatViewModel.h"
@class CMChatToolView;          //底部的工具栏
@class CMEmojiKeyboard;         //表情键盘

@interface CMChatController : UIViewController <UITableViewDelegate,UITableViewDataSource>

#pragma mark - UI属性
/**tableVie*/
@property(nonatomic,weak) UITableView *tableView;
/**底部工具栏*/
@property(nonatomic,weak) CMChatToolView *toolView;
/**表情键盘*/
@property(nonatomic,weak) CMEmojiKeyboard *emojiView;

@end
