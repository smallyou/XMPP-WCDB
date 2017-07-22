//
//  CMChatManager+Message.h
//  01-WCDB
//
//  Created by 23 on 2017/7/18.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMChatManager.h"
@class CMMessage;

#pragma mark - XMPP消息类型
typedef NS_ENUM(NSInteger, XMPPMessageType) {
    XMPPMessageTypeSystem               = 0,        //系统消息
    XMPPMessageTypeInventToGroup        = 1,        //邀请加入群聊消息
    XMPPMessageTypeChat                 = 2,        //聊天消息
    XMPPMessageTypeOther                = 3         //其他信息
};


@interface CMChatManager (Message) <XMPPStreamDelegate>

#pragma mark - 消息相关API

/**
 发送消息

 @param message 消息模型
 @param completion 完成后的回调
 */
- (void)sendMessage:(CMMessage *)message completion:(BaseMessageCallback)completion;

@end
