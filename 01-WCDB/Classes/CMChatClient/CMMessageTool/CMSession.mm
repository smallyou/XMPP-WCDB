//
//  CMSession.m
//  01-WCDB
//
//  Created by 23 on 2017/7/17.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMSession.h"

@implementation CMSession

#pragma mark - WCDB定义需要绑定到数据库表的类
WCDB_IMPLEMENTATION(CMSession)

#pragma mark - WCDB定义需要绑定到数据库表的字段
WCDB_SYNTHESIZE(CMSession,Id)
WCDB_SYNTHESIZE(CMSession,sessionId)
WCDB_SYNTHESIZE(CMSession,type)
WCDB_SYNTHESIZE(CMSession,unreadMessagesCount)
WCDB_SYNTHESIZE(CMSession,ext)
WCDB_SYNTHESIZE(CMSession,lastMsgId)

#pragma mark - WCDB定义数据库表的约束、主键等信息
/**定义主键*/
WCDB_PRIMARY_AUTO_INCREMENT(CMSession,Id)
/**定义索引*/
WCDB_INDEX(CMSession, "_index", lastMsgId)
/**定义唯一性*/
WCDB_UNIQUE(CMSession,sessionId)


#pragma mark - 接口
/**快速创建会话*/
- (instancetype)initWithSessionId:(NSString *)sessionId type:(CMChatType)type
{
    if (self = [super init]) {
        self.sessionId = sessionId;
        self.type = type;
        self.unreadMessagesCount = 0;
        self.ext = nil;
        self.lastMessage = nil;
        self.lastMsgId = nil;
    }
    return self;
}

- (void)setLastMessage:(CMMessage *)lastMessage
{
    _lastMessage = lastMessage;
    
    self.lastMsgId = lastMessage.messageId;
}

@end
