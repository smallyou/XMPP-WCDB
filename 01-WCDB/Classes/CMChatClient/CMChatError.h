//
//  CMChatError.h
//  01-WCDB
//
//  Created by 23 on 2017/7/17.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DDXMLElement;


#pragma mark - 错误码
typedef NS_ENUM(NSInteger, CMChatErrorCode) {
    CMChatErrorCodeAccountConflict          = 1001,         //账号冲突
    CMChatErrorCodeFailAuthorized           = 1002,         //账号授权失败
    CMChatErrorCodeAccountNull              = 1003,         //账号密码为空
    CMChatErrorCodeConnectTimeout           = 1004          //xmpp连接超时
};

@interface CMChatError : NSError

/**快速创建错误（错误域和错误码）*/
+ (instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code;

/**快速创建错误（兼容系统错误）*/
+ (instancetype)errorWithNSError:(NSError *)error;

/**快速创建错误（兼容xmpp错误-DDXMLElement）*/
+ (instancetype)errorWithDDXMLElement:(DDXMLElement *)error;

/**返回错误提示语*/
- (NSString *)getErrorMessage;

@end
