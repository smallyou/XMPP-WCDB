//
//  CMChatConst.h
//  01-WCDB
//
//  Created by 23 on 2017/7/17.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import <UIKit/UIKit.h>

/** self的弱引用 */
#define CMWeakSelf __weak typeof(self) weakSelf = self;


#pragma mark - 默认服务器参数
UIKIT_EXTERN NSString * const kHostName;    //云医院
UIKIT_EXTERN UInt16     const kHostPort;
UIKIT_EXTERN NSString * const kDomain;
UIKIT_EXTERN NSString * const kResource;
UIKIT_EXTERN NSInteger  const kAliveInterval;     //心跳包时间


#pragma mark - 数据库表名称
/**消息表的名称*/
UIKIT_EXTERN NSString * const DB_TABLE_MESSAGE;
/**会话表的名称*/
UIKIT_EXTERN NSString * const DB_TABLE_SESSION;


#pragma mark - 错误域
/**聊天xmppStrem的错误域*/
UIKIT_EXTERN NSString * const kChatXMPPStreamDomain;
/**聊天xmpp通用的错误域*/
UIKIT_EXTERN NSString * const kChatXMPPDomain;
/**聊天wcdb的错误域*/
UIKIT_EXTERN NSString * const kChatWCDBDomain;


#pragma mark - XMPP消息类型
/**系统消息*/
UIKIT_EXTERN NSString * const  TYPE_SYSTEM;
/**文字消息*/
UIKIT_EXTERN NSString * const  TYPE_TEXT;
/**语音消息*/
UIKIT_EXTERN NSString * const  TYPE_VOICE;
/**图片消息*/
UIKIT_EXTERN NSString * const  TYPE_IMAGE;
/**位置消息*/
UIKIT_EXTERN NSString * const  TYPE_LOCATION;
/**实时音频消息*/
UIKIT_EXTERN NSString * const  TYPE_REALTIME_VOICE;
/**实时音视频消息*/
UIKIT_EXTERN NSString * const  TYPE_REALTIME_VIDEO;
/**病历消息*/
UIKIT_EXTERN NSString * const  TYPE_CASE;
/**视频段消息*/
UIKIT_EXTERN NSString * const  TYPE_VIDEO;
/**药店消息(药店地理位置等)*/
UIKIT_EXTERN NSString * const  TYPE_DRUG_STORE;
/**选择药店指令消息*/
UIKIT_EXTERN NSString * const  TYPE_SELECTOR_DRUG_STORE;
/**处方消息*/
UIKIT_EXTERN NSString * const  TYPE_PRESCRIPTION;
/**专家详情链接*/
UIKIT_EXTERN NSString * const  TYPE_PROFESSIONAL;
/**商品详情消息*/
UIKIT_EXTERN NSString * const  TYPE_GOODS;
/**评估题*/
UIKIT_EXTERN NSString * const  TYPE_QUESTIONS;
/**处方消息*/
UIKIT_EXTERN NSString * const  TYPE_OPEN_PRESCRIPTION;


#pragma mark - 消息CMMessage扩展字段字典key
/**消息扩展字段字典key--订单Id*/
UIKIT_EXTERN NSString * const kMessageExtDictionaryOrderIdKey;
/**消息扩展字段字典key--订单类型*/
UIKIT_EXTERN NSString * const kMessageExtDictionaryOrderTypeKey;














