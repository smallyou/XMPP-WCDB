//
//  CMDBManager.m
//  01-WCDB
//
//  Created by 23 on 2017/7/14.
//  Copyright © 2017年 23. All rights reserved.
//

#import "CMDBManager.h"
#import "CMChatConst.h"
#import "CMMessage.h"
#import "CMSession.h"


@interface CMDBManager ()

/**当前数据库路径*/
@property(nonatomic,copy) NSString *currentDBPath;
/**数据库对象*/
@property(nonatomic,strong) WCTDatabase *database;

@end

@implementation CMDBManager

static id _instance;
+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - API
/**更新数据库路径*/
- (void)updateDBPath:(NSString *)dbpath
{
    self.currentDBPath = dbpath;
    if (self.database && [self.database isOpened]) {
        [self.database close];
        self.database = nil;
    }
    
    //创建数据库
    self.database = [[WCTDatabase alloc] initWithPath:dbpath];

    //创建数据库表
    BOOL result = [self.database createTableAndIndexesOfName:DB_TABLE_MESSAGE
                                              withClass:CMMessage.class];
    
    BOOL result1 = [self.database createTableAndIndexesOfName:DB_TABLE_SESSION
                                               withClass:CMSession.class];
    
    if (result && result1) {
        NSLog(@">>>smallyou<<<:切换数据库+数据库表更新成功");
    }else{
        NSLog(@">>>smallyou<<<:切换数据库+数据库表更新失败");
    }
}








@end
