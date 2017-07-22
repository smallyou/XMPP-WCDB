//
//  CMChatManager+Message.m
//  01-WCDB
//
//  Created by 23 on 2017/7/18.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMChatManager+Message.h"
#import "CMMessage.h"
#import "CMTextMessageBody.h"
#import "CMImageMessageBody.h"
#import "CMVoiceMessageBody.h"
#import "CMLocationMessageBody.h"
#import "CMChatConst.h"
#import "CMChatError.h"




@implementation CMChatManager (Message)

#pragma mark - 消息相关API - 发送+接收
/**发送消息*/
- (void)sendMessage:(CMMessage *)message completion:(BaseMessageCallback)completion
{
    //保存当前的回调操作
    self.sendMsgCallback = completion;
    
    //将当前消息对象缓存起来，key为messageId，value为当前对象
    [self.sendingMessagesCache setValue:message forKey:message.messageId];
    
    //通过消息对象构建xmpp的发送实体xml
    NSXMLElement *xmlElement = [self xmlElementWithMessage:message];
    
    //发送
    [self.xmppStream sendElement:xmlElement];
}


#pragma mark - 工具方法 - 消息内容解析 - 发送
/**通过消息构造发送实体xml*/
- (NSXMLElement *)xmlElementWithMessage:(CMMessage *)aMessage
{
    //1 根据消息类型构造发送消息内容
    NSString *msgContent = [self contentWithMessage:aMessage];
    
    //2 构造消息发送实体xml
    NSXMLElement *msgElement = [[NSXMLElement alloc] initWithName:@"message" xmlns:@"jabber:client"];
    
    //3 设置属性
    //--3.1设置属性 id
    [msgElement addAttributeWithName:@"id" stringValue:aMessage.messageId]; // messageID
    //--3.2设置属性 to
    NSString *domain = kDomain;
    if (aMessage.chatType == CMChatTypeGroup) {
        domain = [@"conference." stringByAppendingString:kDomain];
    }
    [msgElement addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@",aMessage.to, domain]];
    //--3.3设置属性 type
    NSString *type = aMessage.chatType == CMChatTypeGroup?@"groupchat":@"chat";  //聊天
    [msgElement addAttributeWithName:@"type" stringValue:type];
    //--3.4设置属性 from
    [msgElement addAttributeWithName:@"from" stringValue:aMessage.from];
    
    //4 创建子元素
    //--4.1 body元素
    DDXMLElement *body = [DDXMLElement elementWithName:@"body" stringValue:msgContent];
    
    //--4.2 request元素
    DDXMLElement *requestElement00 = [DDXMLElement elementWithName:@"request" xmlns:@"jabber:client"];
    DDXMLElement *requestElement01 = [DDXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    
    //--4.3 properties
    DDXMLElement *propertiesElement = [DDXMLElement elementWithName:@"properties" xmlns:@"http://www.jivesoftware.com/xmlns/xmpp/properties"];
    
    //--4.4 propertyElement --- 消息类型
    DDXMLElement *propertyElement = [DDXMLElement elementWithName:@"property"];
    DDXMLNode *nameElement = [DDXMLNode elementWithName:@"name" stringValue:@"type"];
    NSString *value = nil;
    switch (aMessage.body.type) {
        case CMMessageBodyTypeText: value = TYPE_TEXT; break;
        case CMMessageBodyTypeVoice: value = TYPE_VOICE; break;
        case CMMessageBodyTypeImage: value = TYPE_IMAGE; break;
        case CMMessageBodyTypeLocation: value = TYPE_LOCATION; break;
        default: break;
    }
    DDXMLElement *valueElement = [DDXMLElement elementWithName:@"value" stringValue:value];
    [valueElement addAttributeWithName:@"type" stringValue:@"string"];
    
    //--4.5 propertyElement --- 扩展字段(字典key标识属性名  value属性值)
    [aMessage.ext enumerateKeysAndObjectsUsingBlock:^(NSString *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        DDXMLElement *propertyElement = [DDXMLElement elementWithName:@"property"];
        DDXMLNode *nameElement = [DDXMLNode elementWithName:@"name" stringValue:key];
        DDXMLElement *valueElement = [DDXMLElement elementWithName:@"value" stringValue:[NSString stringWithFormat:@"%@",obj]];
        [valueElement addAttributeWithName:@"type" stringValue:@"string"];
        
        [propertiesElement addChild:propertyElement];
        [propertyElement addChild:nameElement];
        [propertyElement addChild:valueElement];
        
        
    }];
    
    
    //--4.6 构造
    [msgElement addChild:body];
    [msgElement addChild:requestElement00];
    [msgElement addChild:requestElement01];
    [msgElement addChild:propertiesElement];
    
    [propertiesElement addChild:propertyElement];
    
    [propertyElement addChild:nameElement];
    [propertyElement addChild:valueElement];
    
    //返回
    return msgElement;
}

/**根据消息CMMessage获取发送的xmppMessage的内容*/
- (NSString *)contentWithMessage:(CMMessage *)aMessage
{
    NSString *content = @"";
    
    //获取消息的消息体
    CMMessageBody *body = aMessage.body;
    
    //获取消息的消息体类型
    CMMessageBodyType type = body.type;
    
    //判断
    switch (type) {
        case CMMessageBodyTypeText:
        {
            content = [(CMTextMessageBody *)body text];
        }
            break;
        case CMMessageBodyTypeImage:
        {
            NSString *thumailPath = [(CMImageMessageBody *)body thumbnailRemotePath];
            NSString *bigPath     = [(CMImageMessageBody *)body bigRemotePath];
            content = [NSString stringWithFormat:@"%@;%@",thumailPath,bigPath];
        }
            break;
        case CMMessageBodyTypeVoice:
        {
            NSString *remotePath = [(CMVoiceMessageBody *)body voiceRemotePath];
            NSUInteger duration  = [(CMVoiceMessageBody *)body duration];
            content = [NSString stringWithFormat:@"%@;%zd",remotePath,duration];
        }
            break;
        case CMMessageBodyTypeLocation:
        {
            NSString *ID            = [(CMLocationMessageBody *)body locationId];
            NSString *name          = [(CMLocationMessageBody *)body name];
            NSString *address       = [(CMLocationMessageBody *)body address];
            CGFloat  longitude      = [(CMLocationMessageBody *)body longitude];
            CGFloat  lagitude       = [(CMLocationMessageBody *)body latitude];
            content = [NSString stringWithFormat:@"%@;%@;%@;%f;%f",ID,name,address,longitude,lagitude];
        }
            
        default:
            break;
    }
    
    
    return content;
}

#pragma mark - 工具方法 - 消息内容解析 - 接收
/**解析聊天消息*/
- (CMMessage *)messageWithXMPPChatMessage:(XMPPMessage *)message
{
    //1 解析XML
    NSString *messageID  = [[message attributeForName:@"id"] stringValue];
    NSString *fromUserID = message.from.user;   //如果是单聊，此时获取的是发送者的jid的user  如果是群聊，此时获取到的是聊天室的JID的user
    NSString *sessionId =  message.from.user;    //如果是单聊，sessionId = fromUserId ,如果是群聊，sessionID为聊天室id
    NSString *toUserID   = message.to.user;
    NSString *type       = [[message attributeForName:@"type"] stringValue]; //单聊还是群聊
    NSString *msgContent = [message elementForName:@"body"].stringValue;    //xmpp消息体内容
    
    NSXMLElement *properties = [message elementForName:@"properties"];
    NSArray *propertyArray = [properties elementsForName:@"property"];
    NSString *value = @"";                      //消息类型
    NSMutableDictionary *ext = [NSMutableDictionary dictionary];
    for (NSXMLElement *child in propertyArray) {
        
        NSString *nameStr = [child elementForName:@"name"].stringValue;    //名称
        NSString *valueStr  = [child elementForName:@"value"].stringValue;  //值
        
        //消息类型
        if ([nameStr isEqualToString:@"type"]) {
            value = valueStr;
        }
        //扩展字段
        else{
            ext[nameStr] = value;
        }
    }

    //2 根据xmpp消息体内容及消息类型创建CMMessageBody
    CMMessageBody *body = [self messageBodyWithXMPPMsgContent:msgContent msgType:value];
    
    //3 创建CMMessage
    CMMessage *aMessage = [[CMMessage alloc] initWithSessionId:sessionId from:fromUserID to:toUserID body:body ext:ext];
    
    return aMessage;
}

/**根据xmpp消息内容及消息类型，生成CMMessageBody*/
- (CMMessageBody *)messageBodyWithXMPPMsgContent:(NSString *)msgContent msgType:(NSString *)msgType
{
    CMMessageBody *body = nil;
    
    //文本消息
    if ([msgType isEqualToString:TYPE_TEXT]) {
        body = [[CMTextMessageBody alloc] initWithText:msgContent];
        body.type = CMMessageBodyTypeText;
    }
    //图片消息
    else if ([msgType isEqualToString:TYPE_IMAGE]){
        NSArray *infos = [msgContent componentsSeparatedByString:@";"];
        if (infos.count == 2) {
            body = [[CMImageMessageBody alloc] init];
            [(CMImageMessageBody *)body setThumbnailRemotePath:infos[0]];
            [(CMImageMessageBody *)body setBigRemotePath:infos[1]];
            body.type = CMMessageBodyTypeImage;
        }
    }
    //声音
    else if ([msgType isEqualToString:TYPE_VOICE]){
        NSArray *infos = [msgContent componentsSeparatedByString:@";"];
        if (infos.count == 2) {
            body = [[CMVoiceMessageBody alloc] init];
            [(CMVoiceMessageBody *)body setVoiceRemotePath:infos[0]];
            [(CMVoiceMessageBody *)body setDuration:[infos[1] integerValue]];
            body.type = CMMessageBodyTypeVoice;
        }
    }
    //地理位置
    else if ([msgType isEqualToString:TYPE_LOCATION]){
        NSArray *infos = [msgContent componentsSeparatedByString:@";"];
        if (infos.count == 5) {
            body = [[CMLocationMessageBody alloc] init];
            [(CMLocationMessageBody *)body setLocationId:infos[0]];
            [(CMLocationMessageBody *)body setName:infos[1]];
            [(CMLocationMessageBody *)body setAddress:infos[2]];
            [(CMLocationMessageBody *)body setLongitude:[infos[3] floatValue]];
            [(CMLocationMessageBody *)body setLatitude:[infos[4] floatValue]];
            body.type = CMMessageBodyTypeLocation;
        }
    }

    return body;
}


#pragma mark - 工具方法 - XMPP消息类型判断
/**判断消息的类型*/
-(XMPPMessageType)typeOfXMPPMessage:(XMPPMessage *)message
{
    if ([self isSystemMessage:message]) {
        return XMPPMessageTypeSystem;
    }
    if ([self isInventToGroupMessage:message]) {
        return XMPPMessageTypeInventToGroup;
    }
    if ([self isChatMessage:message]) {
        return XMPPMessageTypeChat;
    }
    return XMPPMessageTypeOther;
}

/**判断是否为系统消息*/
- (BOOL)isSystemMessage:(XMPPMessage *)message
{
    return NO;
}

/**判断是否为邀请入群消息*/
- (BOOL)isInventToGroupMessage:(XMPPMessage *)message
{
    DDXMLElement *x = [message elementForName:@"x" xmlns:@"http://jabber.org/protocol/muc#user"];
    if (x) {
        DDXMLElement *invite = [x elementForName:@"invite"];
        if (invite) {
            return YES;
        }
    }
    
    return NO;
}

/**判断是否为普通聊天消息*/
- (BOOL)isChatMessage:(XMPPMessage *)message
{
    return [message isChatMessage];
}


#pragma mark - 工具方法 - 消息通知相关
/**通知代理，接收到消息，但还没存数据库*/
- (void)tool_receiveUnStoredMessages:(NSArray *)aMessages callback:(void(^)(BOOL store,NSArray *aMessages))callback
{
    for (NSDictionary *dict in self.delegates) {
        id delegate = dict[kDelegateKey];
        dispatch_queue_t queue = dict[kQueuekey];
        if ([delegate respondsToSelector:@selector(messageDidReceiveUnStored:completion:)]) {
            dispatch_async(queue, ^{
                [delegate messageDidReceiveUnStored:aMessages completion:^(BOOL stored) {
                    //回主线程回调
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (callback) {
                            callback(stored,aMessages);
                        }
                    });
                }];
            });
        }
    }
}

/**通知代理，接收到消息，并已经存储到数据库*/
- (void)tool_receiveMessages:(NSArray *)aMessages
{
    for (NSDictionary *dict in self.delegates) {
        id delegate = dict[kDelegateKey];
        dispatch_queue_t queue = dict[kQueuekey];
        if ([delegate respondsToSelector:@selector(messageDidReceive:)]) {
            dispatch_async(queue, ^{
                [delegate messageDidReceive:aMessages];
            });
        }
    }
}


#pragma mark - XMPPStreamDelegate代理方法
/**消息发送成功*/
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    //获取当前的XMPPMessage的messageId
    NSString *messageId = [message attributeStringValueForName:@"id"];
    
    //从缓存中获取消息对象
    CMMessage *aMessage = [self.sendingMessagesCache valueForKey:messageId];
    
    //回调
    if (self.sendMsgCallback) {
        self.sendMsgCallback(YES, nil, aMessage);
    }
    
    //移除缓存
    [self.sendingMessagesCache removeObjectForKey:messageId];
}

/**消息发送失败*/
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    //获取当前的XMPPMessage的messageId
    NSString *messageId = [message attributeStringValueForName:@"id"];
    
    //从缓存中获取消息对象
    CMMessage *aMessage = [self.sendingMessagesCache valueForKey:messageId];
    
    //生成错误信息(统一处理错误)
    CMChatError *aError = [CMChatError errorWithNSError:error];
    
    //回调
    if (self.sendMsgCallback) {
        self.sendMsgCallback(NO, aError, aMessage);
    }
    
    //移除缓存
    [self.sendingMessagesCache removeObjectForKey:messageId];

}

/**接收到消息*/
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    //根据消息类型解析消息
    switch ([self typeOfXMPPMessage:message]) {
        //系统消息
        case XMPPMessageTypeSystem:
        {
            //解析系统消息
        }
            break;
        //邀请入群消息
        case XMPPMessageTypeInventToGroup:
        {
            //解析邀请消息
        }
            break;
        //聊天消息
        case XMPPMessageTypeChat:
        {
#warning CM todo - 待优化处理性能
            //解析聊天消息
            CMMessage *aMessage = [self messageWithXMPPChatMessage:message];
            
            //通知代理(已经接收到了消息，还未存数据库)
            CMWeakSelf
            [self tool_receiveUnStoredMessages:@[aMessage] callback:^(BOOL store, NSArray *aMessages) {
                //通知代理，接收到了消息并已经存储到数据库中了
                [weakSelf tool_receiveMessages:aMessages];
            }];
        }
            break;
        
        //其他消息
        default:
        {
            //解析其他消息
        }
            break;
    }
    
}




@end











