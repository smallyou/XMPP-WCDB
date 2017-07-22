//
//  CMChatOptions.h
//  01-WCDB
//
//  Created by 23 on 2017/7/17.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMChatOptions : NSObject

/**是否设置自动登录*/
@property(nonatomic,assign) BOOL isAutoLogin;
/**是否打印日志*/
@property(nonatomic,assign) BOOL isLog;

@end
