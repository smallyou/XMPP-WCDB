//
//  CMDBManager.h
//  01-WCDB
//
//  Created by 23 on 2017/7/14.
//  Copyright © 2017年 23. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCDB.h"

@interface CMDBManager : NSObject


#pragma mark - 属性
/**数据库对象*/
@property(nonatomic,strong,readonly) WCTDatabase *database;



+ (instancetype)shareManager;


/**更新数据库路径*/
- (void)updateDBPath:(NSString *)dbpath;

@end
