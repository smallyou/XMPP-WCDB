//
//  CMChatManager.h
//  01-WCDB
//
//  Created by 23 on 2017/7/17.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPPFramework/XMPPFramework.h>

@class CMChatOptions,CMChatError,CMMessage;

/**基础的xmpp操作回调*/
typedef void(^BaseXMPPCallback)(BOOL success, CMChatError *error, id context);
/**消息操作回调block*/
typedef void(^BaseMessageCallback)(BOOL success, CMChatError *error, CMMessage *aMessage);

#pragma mark - 代理缓存的key
#define kDelegateKey   @"kDelegateKey"
#define kQueuekey      @"kQueuekey"


#pragma mark - 协议定义(CMChatManagerDelegate)
typedef NS_ENUM(NSInteger, CMConnectionState) {
    CMConnectionStateConnected          = 0,        //连接
    CMConnectionStateDisconnected       = 1         //未连接
};


@protocol CMChatManagerDelegate <NSObject>

@optional

/** 
 SDK连接服务器的状态变化时会接收到该回调
 *  有以下几种情况, 会引起该方法的调用:
 *  1. 登录成功后, 手机无法上网时, 会调用该回调
 *  2. 登录成功后, 网络状态变化时, 会调用该回调
 */
- (void)connectionStateDidChange:(CMConnectionState)aConnectionState;

/*
 *  自动登录完成时的回调
 */
- (void)autoLoginDidCompleteWithError:(CMChatError *)aError;

/**
 *  当前登录账号在其它设备登录时会接收到此回调
*/
- (void)userAccountDidLoginFromOtherDevice;

/**
 在线接收到消息（已经存储在数据库）

 @param aMessages 消息数组
 */
- (void)messageDidReceive:(NSArray *)aMessages;

/**
 在线接收到消息（刚接接收到消息，还没存储数据库）

 @param aMessages 消息数组
 @param completion 回调(回调YES，已经存储了数据库；回调NO，未存储数据库)
 */
- (void)messageDidReceiveUnStored:(NSArray *)aMessages completion:(void(^)(BOOL stored))completion;

/**
 在线接收到CMD控制消息(透传，不存数据库)

 @param aMessages 消息数组
 */
- (void)cmdMessageDidReceive:(NSArray *)aMessages;

@end



@interface CMChatManager : NSObject

#pragma mark - 属性
/**聊天属性*/
@property(nonatomic,strong) CMChatOptions *options;
/**xmppstream*/
@property(nonatomic,strong,readonly) XMPPStream *xmppStream;
/**代理数组*/
@property(nonatomic,strong,readonly) NSMutableArray< NSDictionary *> *delegates;

#pragma mark - 保存属性
/**当前正在发送的消息对象*/
@property(nonatomic,strong) NSMutableDictionary *sendingMessagesCache;
/**发送消息的回调*/
@property(nonatomic,copy) BaseMessageCallback sendMsgCallback;


#pragma mark - 单例
+ (instancetype)shareManager;


#pragma mark - 工具方法
/**
 添加代理

 @param delegate 代理
 @param queue 执行的队列
 */
- (void)addDelegate:(id <CMChatManagerDelegate>)delegate queue:(dispatch_queue_t)queue;


#pragma mark - API

/**
 登录

 @param username 用户名jid.user
 @param password 密码
 @param callback 回调
 */
- (void)loginWithUsername:(NSString *)username password:(NSString *)password callback:(BaseXMPPCallback)callback;

/**
 退出
 */
- (void)logout;


@end
