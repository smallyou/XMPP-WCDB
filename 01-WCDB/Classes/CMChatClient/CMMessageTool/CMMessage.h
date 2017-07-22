//
//  CMMessage.h
//  01-WCDB
//
//  Created by 23 on 2017/7/14.
//  Copyright © 2017年 23. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <WCDB/WCDB.h>
#import "WCDB.h"
#import "CMMessageHeader.h"
#import "CMMessageBody.h"

@interface CMMessage : NSObject <WCTTableCoding>

/**消息Id*/
@property(nonatomic,copy) NSString *messageId;
/**消息所属会话id*/
@property(nonatomic,copy) NSString *sessionId;
/**消息创建日期*/
@property(nonatomic,assign) NSTimeInterval createtime;
/**消息修改时间*/
@property(nonatomic,assign) NSTimeInterval modifytime;
/**消息发送方*/
@property(nonatomic,copy) NSString *from;
/**消息接收方*/
@property(nonatomic,copy) NSString *to;
/**消息的方向*/
//@property(nonatomic,assign) CMMessageDirection direction;
@property(nonatomic,assign) NSInteger direction;
/**聊天类型*/
//@property(nonatomic,assign) CMChatType chatType;
@property(nonatomic,assign) NSInteger chatType;
/**消息状态*/
//@property(nonatomic,assign) CMMessageStatus status;
@property(nonatomic,assign) NSInteger status;
/**消息是否已读*/
@property(nonatomic,assign) BOOL isRead;
/**消息体*/
@property(nonatomic,strong) CMMessageBody *body;
/**消息扩展*/
@property(nonatomic,strong) NSDictionary *ext;



#pragma mark - 补充字段
/**自增id*/
@property(nonatomic,assign) NSUInteger Id;




#pragma mark - WCDB-申明需要绑定到数据库中的字段

WCDB_PROPERTY(Id)
WCDB_PROPERTY(messageId)
WCDB_PROPERTY(sessionId)
WCDB_PROPERTY(createtime)
WCDB_PROPERTY(modifytime)
WCDB_PROPERTY(from)
WCDB_PROPERTY(to)
WCDB_PROPERTY(direction)
WCDB_PROPERTY(chatType)
WCDB_PROPERTY(status)
WCDB_PROPERTY(isRead)
WCDB_PROPERTY(body)
WCDB_PROPERTY(ext)


#pragma mark - 接口

/**
 快速创建消息

 @param sessionId 会话ID
 @param from 消息发送者jid.user
 @param to 消息接受者jid.user
 @param body 消息体
 @param ext 消息扩展
 @return 消息对象
 */
- (instancetype)initWithSessionId:(NSString *)sessionId from:(NSString *)from to:(NSString *)to body:(CMMessageBody *)body ext:(NSDictionary *)ext;

@end



























