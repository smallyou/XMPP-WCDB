//
//  CMChatTool.m
//  01-WCDB
//
//  Created by 23 on 2017/7/18.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMChatClient.h"
#import "CMChatManager.h"
#import "CMChatManager+Message.h"
#import "CMChatOptions.h"
#import "CMDBManager.h"
#import "CMSession.h"
#import "CMMessage.h"
#import "CMChatConst.h"

@interface CMChatClient () <CMChatManagerDelegate>

/**聊天管理器*/
@property(nonatomic,strong) CMChatManager *chatManager;
/**数据库管理器*/
@property(nonatomic,strong) CMDBManager *dbManager;
/**属性管理*/
@property(nonatomic,strong) CMChatOptions *options;

@end


@implementation CMChatClient

#pragma mark - 单例
static id _instance;
+ (instancetype)shareClient
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        //初始化属性
        self.options = [[CMChatOptions alloc] init];
        self.options.isLog = YES;
        self.options.isAutoLogin = YES;
        
        //初始化管理器
        self.chatManager = [CMChatManager shareManager];
        [self.chatManager addDelegate:self queue:nil];
        self.chatManager.options = self.options;
        self.dbManager   = [CMDBManager shareManager];
    }
    return self;
}


#pragma mark - ChatAPI
/**登录*/
- (void)loginWithUsername:(NSString *)username password:(NSString *)password callback:(BaseChatCallback)callback
{
    [self.chatManager loginWithUsername:username password:password callback:^(BOOL success, CMChatError *error, id context) {
        
        //如果登录成功，需要创建数据库
        if (success) {
            //根据当前用户名获取数据库路径
            NSString *dbpath = [self databasePathWithUsername:username];
            //创建数据库
            [self.dbManager updateDBPath:dbpath];
        }
        
        //回调
        if (callback) {
            callback(success, error, context);
        }
        
    }];
}

/**提出*/
- (void)logout
{
    //退出xmpp
    [self.chatManager logout];
    
    //关闭数据库
    [self.dbManager.database close];
}

#pragma mark - 会话相关API
/**获取或者创建会话*/
- (CMSession *)getSession:(NSString *)sessionId type:(CMChatType)chatType createIfNotExist:(BOOL)isCreate
{
    //根据sessionId从数据库读取
    NSArray *sessions = [self.dbManager.database getObjectsOfClass:CMSession.class fromTable:DB_TABLE_SESSION where:CMSession.sessionId == sessionId];
    if (sessions.count) {
        //取出会话的lastMsgId
        CMSession *session = sessions.firstObject;
        NSString *lastMsgId = session.lastMsgId;
        
        //根据lastMsgId从数据库中读取CMMessage
        NSArray *messages = [self.dbManager.database getObjectsOfClass:CMMessage.class fromTable:DB_TABLE_MESSAGE where:CMMessage.messageId == lastMsgId];
        if (messages.count) {
            CMMessage *message = messages.firstObject;
            session.lastMessage = message;
        }
        
        return session;
    }
    
    //数据库不存在，则创建
    if (isCreate) {
        CMSession *session = [[CMSession alloc] initWithSessionId:sessionId type:chatType];
        session.isAutoIncrement = YES;
        if([self.dbManager.database insertObject:session into:DB_TABLE_SESSION])
            return session;
    }

    return nil;
}


#pragma mark - 消息相关API
/**发送消息*/
- (void)sendMessage:(CMMessage *)message progress:(void(^)(int progress))progress callback:(BaseMessageCallback)callback
{
    //修改消息的状态
    message.direction = CMMessageDirectionSend;
    message.status    = CMMessageStatusDelivering;
    message.modifytime  = [[NSDate new] timeIntervalSince1970];
    
    //存数据库
    [self.dbManager.database insertObject:message into:DB_TABLE_MESSAGE];
    
    //发送消息
    CMWeakSelf
    [self.chatManager sendMessage:message completion:^(BOOL success, CMChatError *error, CMMessage *aMessage) {
        
        //修改发送状态时间
        aMessage.status = success?CMMessageStatusSuccessed:CMMessageStatusFailed;
        aMessage.modifytime = [[NSDate new] timeIntervalSince1970];
        
        //更新数据库
        [weakSelf.dbManager.database updateRowsInTable:DB_TABLE_MESSAGE onProperties:{CMMessage.status,CMMessage.modifytime} withObject:aMessage where:CMMessage.messageId == aMessage.messageId];
        
        //获取会话并更新
        CMSession *aSession = [self getSession:aMessage.sessionId type:(CMChatType)aMessage.chatType createIfNotExist:YES];
        aSession.lastMessage = aMessage;
        [weakSelf.dbManager.database updateRowsInTable:DB_TABLE_SESSION onProperties:{CMSession.lastMsgId} withObject:aSession where:CMSession.sessionId == aSession.sessionId];
        
        //回调
        if (callback) {
            callback(success,error,aMessage);
        }
        
    }];
}



#pragma mark - 工具API
/**产生UUID*/
+ (NSString *)generateUUID
{
    NSString *result = nil;
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid)
    {
        result = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    
    return result;
}

/**根据当前xmpp用户名获取数据库路径*/
- (NSString *)databasePathWithUsername:(NSString *)username
{
    //获取数据库名称
    NSString *dbname = [NSString stringWithFormat:@"%@%@",username,@".db"];
    //获取document路径
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    //创建用户文件夹
    path = [path stringByAppendingPathComponent:username];
    if(![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //创建用户数据库
    path = [path stringByAppendingPathComponent:dbname];
    return path;
}

/**上传图片或其他*/
- (void)uploadData:(NSData *)data progress:(void(^)(int progress))progress callback:(BaseChatCallback)callback
{
#warning CM:todo 上传图片
    
}


#pragma mark - CMChatManagerDelegate
/**接收到未存储到数据库的消息*/
- (void)messageDidReceiveUnStored:(NSArray *)aMessages completion:(void (^)(BOOL))completion
{
    //修改会话Id
#warning CM - sessionId根据业务修改
    NSString *sessionId = @"";
    CMChatType chatType = CMChatTypeChat;
    
    //修改消息的属性(此时的会话sessionId，时间戳)
    for (CMMessage *aMessage in aMessages) {
#warning CM - sessionId根据业务修改
        aMessage.sessionId = [NSString stringWithFormat:@"%@#%@",aMessage.from,aMessage.ext[kMessageExtDictionaryOrderIdKey]];
        aMessage.modifytime = [[NSDate new] timeIntervalSince1970];
        sessionId = aMessage.sessionId;
        chatType = (CMChatType)aMessage.chatType;
    }
    
    //存储数据库
    [self.dbManager.database insertObjects:aMessages into:DB_TABLE_MESSAGE];
    
    //更新会话
    CMSession *aSession = [self getSession:sessionId type:chatType createIfNotExist:YES];
    aSession.unreadMessagesCount += aMessages.count;
    aSession.lastMessage = aMessages.lastObject;
    [self.dbManager.database updateRowsInTable:DB_TABLE_SESSION onProperties:{CMSession.unreadMessagesCount,CMSession.lastMsgId} withObject:aSession where:CMSession.sessionId == aSession.sessionId];
    
    //回调
    if (completion) {
        completion(YES);
    }
}


@end
