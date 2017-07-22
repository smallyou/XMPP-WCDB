//
//  CMChatError.m
//  01-WCDB
//
//  Created by 23 on 2017/7/17.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMChatError.h"
#import "CMChatConst.h"
#import <KissXML/KissXML.h>

@implementation CMChatError

/**快速创建错误（错误域和错误码）*/
+ (instancetype)errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code
{
    return [self errorWithDomain:domain code:code userInfo:nil];
}

/**快速创建错误（兼容系统错误）*/
+ (instancetype)errorWithNSError:(NSError *)error
{
    return nil;
}

/**快速创建错误（兼容xmpp错误-DDXMLElement）*/
+ (instancetype)errorWithDDXMLElement:(DDXMLElement *)error
{
    /**
     //账号冲突
     <stream:error xmlns:stream="http://etherx.jabber.org/streams"><conflict xmlns="urn:ietf:params:xml:ns:xmpp-streams"/></stream:error>
     //账号授权失败
     <failure xmlns="urn:ietf:params:xml:ns:xmpp-sasl"><not-authorized/></failure>
     */
    
    //通用错误
    if([error.name isEqualToString:@"failure"]){
        if (error.childCount) {
            NSXMLNode *node = [error childAtIndex:0];
            if ([node.name isEqualToString:@"not-authorized"]) {
                return [self errorWithDomain:kChatXMPPDomain code:CMChatErrorCodeFailAuthorized];
            }
        }
    }
    
    //账号冲突
    if (error.childCount) {
        NSXMLNode *node = [error childAtIndex:0];
        if ([node.name isEqualToString:@"conflict"]) {
            return [self errorWithDomain:kChatXMPPStreamDomain code:CMChatErrorCodeAccountConflict];
        }
    }
    
    
    return nil;
}

- (NSString *)getErrorMessage
{
    NSUInteger code = self.code;
    NSString *errMsg = @"";
    
    switch (code) {
        case CMChatErrorCodeAccountConflict:
        {
            errMsg = @"您的账号在另一台设备上被登录，请重新登录!";
        }
            break;
        case CMChatErrorCodeFailAuthorized:
        {
            errMsg = @"账号密码错误";
        }
            break;
        case CMChatErrorCodeAccountNull:
        {
            errMsg = @"账号密码不能为空";
        }
            break;
            case CMChatErrorCodeConnectTimeout:
        {
            errMsg = @"XMPP连接超时，请重试";
        }
            break;
        default:
            break;
    }
    return errMsg;
}


@end
