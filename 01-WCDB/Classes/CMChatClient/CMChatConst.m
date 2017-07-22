//
//  CMChatConst.m
//  01-WCDB
//
//  Created by 23 on 2017/7/17.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMChatConst.h"

#pragma mark - 默认服务器参数
NSString * const kHostName        = @"";    //
UInt16     const kHostPort        = 5222;
NSString * const kDomain          = @"cluster.openfire";
NSString * const kResource        = @"yyy_u";
NSInteger  const kAliveInterval   = 30;     //心跳包时间

#pragma mark - 数据库表名称
/**消息表的名称*/
NSString * const DB_TABLE_MESSAGE   = @"t_message";
/**会话表的名称*/
NSString * const DB_TABLE_SESSION   = @"t_session";

#pragma mark - 错误域
/**聊天xmppStrem的错误域*/
NSString * const kChatXMPPStreamDomain = @"CMChatXMPPStreamDomain";
/**聊天xmpp通用的错误域*/
NSString * const kChatXMPPDomain       = @"CMChatXMPPDomain";
/**聊天wcdb的错误域*/
NSString * const kChatWCDBDomain       = @"CMChatWCDBDomain";


#pragma mark - XMPP消息类型
/**系统消息*/
NSString * const  TYPE_SYSTEM          = @"-1";
/**文字消息*/
NSString * const  TYPE_TEXT            = @"0";
/**语音消息*/
NSString * const  TYPE_VOICE           = @"1";
/**图片消息*/
NSString * const  TYPE_IMAGE           = @"2";
/**位置消息*/
NSString * const  TYPE_LOCATION        = @"3";
/**实时音频消息*/
NSString * const  TYPE_REALTIME_VOICE  = @"4";
/**实时音视频消息*/
NSString * const  TYPE_REALTIME_VIDEO  = @"5";
/**病历消息*/
NSString * const  TYPE_CASE            = @"6";
/**视频段消息*/
NSString * const  TYPE_VIDEO           = @"7";
/**药店消息(药店地理位置等)*/
NSString * const  TYPE_DRUG_STORE      = @"8";
/**选择药店指令消息*/
NSString * const  TYPE_SELECTOR_DRUG_STORE = @"9";
/**处方消息*/
NSString * const  TYPE_PRESCRIPTION    = @"10";
/**专家详情链接*/
NSString * const  TYPE_PROFESSIONAL    = @"11";
/**商品详情消息*/
NSString * const  TYPE_GOODS           = @"12";
/**评估题*/
NSString * const  TYPE_QUESTIONS       = @"13";
/**处方消息*/
NSString * const  TYPE_OPEN_PRESCRIPTION    = @"50";


#pragma mark - 消息CMMessage扩展字段字典key
/**消息扩展字段字典key--订单Id*/
NSString * const kMessageExtDictionaryOrderIdKey      = @"serviceLogId";
/**消息扩展字段字典key--订单类型*/
NSString * const kMessageExtDictionaryOrderTypeKey    = @"serviceType";













