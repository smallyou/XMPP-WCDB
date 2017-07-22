//
//  CMChatTool.h
//  01-WCDB
//
//  Created by 23 on 2017/7/18.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMMessageHeader.h"
#import "CMChatManager.h"
@class CMChatError,CMChatOptions,CMSession,CMMessage;

/**基础操作回调block*/
typedef void(^BaseChatCallback)(BOOL success, CMChatError *error, id context);



@interface CMChatClient : NSObject

#pragma mark - 单例
+ (instancetype)shareClient;

#pragma mark - 属性
/**聊天管理器*/
@property(nonatomic,strong,readonly) CMChatManager *chatManager;
/**属性管理*/
@property(nonatomic,strong,readonly) CMChatOptions *options;



#pragma mark - ChatAPI
/**
 登录

 @param username 用户名
 @param password 密码
 @param callback 回调
 */
- (void)loginWithUsername:(NSString *)username password:(NSString *)password callback:(BaseChatCallback)callback;

/**
 提出
 */
- (void)logout;

/**
 获取或者创建会话

 @param sessionId 会话ID
 @param chatType 聊天类型
 @param isCreate 如果不存在会话是否创建
 @return 返回会话实例
 */
- (CMSession *)getSession:(NSString *)sessionId type:(CMChatType)chatType createIfNotExist:(BOOL)isCreate;


#pragma mark - 消息相关API

/**
 发送消息

 @param message 消息模型
 @param progress 进度
 @param callback 回调
 */
- (void)sendMessage:(CMMessage *)message progress:(void(^)(int progress))progress callback:(BaseMessageCallback)callback;


#pragma mark - 工具API
/**
 产生UUID

 @return UUID字符串
 */
+ (NSString *)generateUUID;

/**
 根据当前xmpp用户名获取数据库路径

 @param username xmpp的jid.user
 @return 数据库路径
 */
- (NSString *)databasePathWithUsername:(NSString *)username;

@end
