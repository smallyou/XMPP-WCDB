//
//  CMMessage.m
//  01-WCDB
//
//  Created by 23 on 2017/7/14.
//  Copyright © 2017年 23. All rights reserved.
//

#import "CMMessage.h"
#import "CMDBManager.h"
#import "CMChatConst.h"
#import "CMChatClient.h"
#import "CMTextMessageBody.h"
#import "CMImageMessageBody.h"
#import "CMVoiceMessageBody.h"
#import "CMLocationMessageBody.h"

@implementation CMMessage

#pragma mark - WCDB定义需要绑定到数据库表的类
WCDB_IMPLEMENTATION(CMMessage)

#pragma mark - WCDB定义需要绑定到数据库表的字段
WCDB_SYNTHESIZE(CMMessage,Id)
WCDB_SYNTHESIZE(CMMessage,messageId)
WCDB_SYNTHESIZE(CMMessage,sessionId)
WCDB_SYNTHESIZE(CMMessage,createtime)
WCDB_SYNTHESIZE(CMMessage,modifytime)
WCDB_SYNTHESIZE_COLUMN(CMMessage, from, "sender")
WCDB_SYNTHESIZE_COLUMN(CMMessage, to, "receiver")
WCDB_SYNTHESIZE(CMMessage,direction);
WCDB_SYNTHESIZE(CMMessage,chatType)
WCDB_SYNTHESIZE(CMMessage,status)
WCDB_SYNTHESIZE(CMMessage,isRead)
WCDB_SYNTHESIZE(CMMessage, body)
WCDB_SYNTHESIZE(CMMessage, ext)

#pragma mark - WCDB定义数据库表的约束、主键等信息
/**定义主键*/
WCDB_PRIMARY_AUTO_INCREMENT(CMMessage,Id)
/**定义索引*/
WCDB_INDEX(CMMessage, "_index", modifytime)
/**定义唯一性*/
WCDB_UNIQUE(CMMessage,messageId)



#pragma mark - 接口
/**快速创建消息*/
- (instancetype)initWithSessionId:(NSString *)sessionId from:(NSString *)from to:(NSString *)to body:(CMMessageBody *)body ext:(NSDictionary *)ext
{
    if (self = [super init]) {
        
        self.messageId          = [CMChatClient generateUUID];
        self.sessionId          = sessionId;
        self.createtime         = [[NSDate new] timeIntervalSince1970];
        self.modifytime         = self.createtime;
        self.from               = from;
        self.to                 = to;
        self.status             = CMMessageStatusPending;
        self.isRead             = YES;
        self.body               = body;
        self.ext                = ext;
        
        self.isAutoIncrement    = YES;

    }
    return self;
}



@end

















