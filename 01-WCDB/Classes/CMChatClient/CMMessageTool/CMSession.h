//
//  CMSession.h
//  01-WCDB
//
//  Created by 23 on 2017/7/17.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WCDB/WCDB.h>
#import "CMMessageHeader.h"
#import "CMMessage.h"

@interface CMSession : NSObject <WCTTableCoding>

/**会话唯一标识*/
@property(nonatomic,copy) NSString *sessionId;
/**会话的类型*/
//@property(nonatomic,assign) CMChatType type;
@property(nonatomic,assign) NSInteger type;
/**会话未读消息数量*/
@property(nonatomic,assign) NSUInteger unreadMessagesCount;
/**会话扩展属性*/
@property(nonatomic,copy) NSDictionary *ext;
/**会话最新的一条消息*/
@property(nonatomic,strong) CMMessage *lastMessage;


#pragma mark - 补充字段-用来存储数据库
/**自增ID*/
@property(nonatomic,assign) NSUInteger Id;
/**会话最新一条消息的messageID*/
@property(nonatomic,copy) NSString *lastMsgId;

#pragma mark - WCDB-申明需要绑定到数据库中的字段

WCDB_PROPERTY(Id)
WCDB_PROPERTY(sessionId)
WCDB_PROPERTY(type)
WCDB_PROPERTY(unreadMessagesCount)
WCDB_PROPERTY(ext)
WCDB_PROPERTY(lastMsgId)



#pragma mark - 接口

/**
 快速创建会话

 @param sessionId 会话ID
 @param type 会话类型
 @return 返回值
 */
- (instancetype)initWithSessionId:(NSString *)sessionId type:(CMChatType)type;



@end
