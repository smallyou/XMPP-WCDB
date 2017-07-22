//
//  CMChatManager.m
//  01-WCDB
//
//  Created by 23 on 2017/7/17.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMChatManager.h"
#import "CMChatOptions.h"
#import "CMChatError.h"
#import "CMChatConst.h"
#import "CMChatManager+Message.h"
#import <objc/runtime.h>

#define CMLog(logstr) self.options.isLog?logstr:@""


@interface CMChatManager () <XMPPStreamDelegate,XMPPReconnectDelegate>

#pragma mark - 属性
/**xmppstream*/
@property(nonatomic,strong) XMPPStream *xmppStream;
/**自动ping*/
@property(nonatomic,strong) XMPPAutoPing *xmppAutoPing;
/**重连模块*/
@property(nonatomic,strong) XMPPReconnect *xmppReconnect;
/**当前jid.user*/
@property(nonatomic,copy) NSString *username;
/**当前jid.user对应的密码*/
@property(nonatomic,copy) NSString *password;
/**代理数组*/
@property(nonatomic,strong) NSMutableArray< NSDictionary *> *delegates;

#pragma mark - 其他保存属性
/**登录操作回调*/
@property(nonatomic,copy) BaseXMPPCallback loginCallback;
/**当前是否是自动登录*/
@property(nonatomic,assign) BOOL isAutoLogin;

@end


@implementation CMChatManager

static id _instance;
+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - 初始化
- (instancetype)init
{
    if (self = [super init]) {
        //初始化属性
        self.isAutoLogin         = NO;
        
        //添加日志
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        //设置ping心跳(传入ping服务器地址)
        [self autoPingProxyServer:nil];
        
        //设置自动登录
        [self setupReconnect];

    }
    return self;
}


#pragma mark - API
/**登录*/
- (void)loginWithUsername:(NSString *)username password:(NSString *)password callback:(BaseXMPPCallback)callback
{
    //0 保存
    self.loginCallback = callback;
    self.username      = username;
    self.password      = password;
    if (username.length == 0 || password.length == 0) {
//        CMLog(NSLog(@"用户名密码不能为空"));
        if (self.loginCallback) {
            CMChatError *error = [CMChatError errorWithDomain:kChatXMPPDomain code:CMChatErrorCodeAccountNull];
            self.loginCallback(NO, error, nil);
        }
        return;
    }
    
    //1 创建用户名密码
    self.xmppStream.myJID = [XMPPJID jidWithUser:self.username domain:kDomain resource:kResource];
    
    //2 连接之前先取消之前的连接
    if ([self.xmppStream isConnected] || [self.xmppStream isConnecting]) {
        [self.xmppStream disconnect];
    }
    
    //3 连接服务器
    NSError *error = nil;
    BOOL result = [self.xmppStream connectWithTimeout:30 error:&error];
    if (!result || error) {
        //连接错误
//        CMLog(NSLog(@">>>smallyou<<<:xmpp超时登录失败..."));
        if (self.loginCallback) {
            CMChatError *err = [CMChatError errorWithDomain:kChatXMPPStreamDomain code:CMChatErrorCodeConnectTimeout];
            self.loginCallback(NO, err, nil);
        }
        return;
    }
    
}

/**退出*/
- (void)logout
{
    [self goOffline];
    [self.xmppStream disconnect];
    self.options.isAutoLogin = NO;
    self.isAutoLogin = NO;
}

#pragma mark - XMPPStreamDelegate - 连接认证相关
/**xmppStream将要开始连接*/
- (void)xmppStreamWillConnect:(XMPPStream *)sender
{
//    CMLog(NSLog(@"//-----------------xmpp----------------//\n"));
//    CMLog(NSLog(@"xmppStream将要开始连接\n"));
}

/**xmppStram socket连接完成*/
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
//    CMLog(NSLog(@"//-----------------xmpp----------------//\n"));
//    CMLog(NSLog(@"建立socket连接\n"));
}

/**xmppStram连接完成(完成了服务器级别的连接)*/
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
//    CMLog(NSLog(@"//-----------------xmpp----------------//\n"));
//    CMLog(NSLog(@"成功连接xmpp服务器\n"));

    //验证密码
    NSError *error = nil;
    BOOL result = [self.xmppStream authenticateWithPassword:self.password error:&error];
    if (result) {
//        CMLog(NSLog(@"成功发起密码认证请求\n"));
    }else{
//        CMLog(NSLog(@"发起密码认证请求失败\n"));
    }
    
}

/**xmppStream连接超时*/
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
//    CMLog(NSLog(@"//-----------------xmpp----------------\n//"));
//    CMLog(NSLog(@"xmppStream连接服务器超时\n"));
}

/**xmppStream认证成功*/
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
//    CMLog(NSLog(@"//-----------------xmpp----------------//\n"));
//    CMLog(NSLog(@"聊天账号认证成功\n"));
    
    //上线
    [self goOnline];
    
    //回调
    if (self.loginCallback) {
        self.loginCallback(YES, nil, nil);
    }
    
    //通知代理 - 连接成功（目前处于连接状态）
    for (NSDictionary *dict in self.delegates) {
        id delegate = dict[kDelegateKey];
        dispatch_queue_t queue = dict[kQueuekey];
        if ([delegate respondsToSelector:@selector(connectionStateDidChange:)]) {
            dispatch_async(queue, ^{
                [delegate connectionStateDidChange:CMConnectionStateConnected];
            });
        }
    }
    
    //通知代理 - 自动登录成功
    if (self.isAutoLogin) {
        for (NSDictionary *dict in self.delegates) {
            id delegate = dict[kDelegateKey];
            dispatch_queue_t queue = dict[kQueuekey];
            if ([delegate respondsToSelector:@selector(autoLoginDidCompleteWithError:)]) {
                dispatch_async(queue, ^{
                    [delegate autoLoginDidCompleteWithError:nil];
                });
            }
        }
    }
    
    
    

}

/**xmppStream认证失败*/
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
//    CMLog(NSLog(@"//-----------------xmpp----------------//\n"));
//    CMLog(NSLog(@"聊天账号认证失败 -- %@\n",error));
    CMChatError *chatError = [CMChatError errorWithDDXMLElement:error];
    
    //回调
    if (self.loginCallback) {
        self.loginCallback(NO, chatError, nil);
    }
    
    //通知代理 - 自动登录失败
    if (self.isAutoLogin) {
        for (NSDictionary *dict in self.delegates) {
            id delegate = dict[kDelegateKey];
            dispatch_queue_t queue = dict[kQueuekey];
            if ([delegate respondsToSelector:@selector(autoLoginDidCompleteWithError:)]) {
                dispatch_async(queue, ^{
                    [delegate autoLoginDidCompleteWithError:chatError];
                });
            }
        }
    }
    
}

/**接收到错误后的回调*/
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(DDXMLElement *)error
{
    //处理错误
    CMChatError *chatError = [CMChatError errorWithDDXMLElement:error];
    
    //账号冲突
    if (chatError.code == CMChatErrorCodeAccountConflict) {
        
        //通知代理
        for (NSDictionary *dict in self.delegates) {
            id delegate = dict[kDelegateKey];
            dispatch_queue_t queue = dict[kQueuekey];
            if ([delegate respondsToSelector:@selector(userAccountDidLoginFromOtherDevice)]) {
                dispatch_async(queue, ^{
                    [delegate userAccountDidLoginFromOtherDevice];
                });
            }
        }
        
    }
}


#pragma mark - XMPPReconnectDelegate(重连模块)
#if MAC_OS_X_VERSION_MIN_REQUIRED <= MAC_OS_X_VERSION_10_5
/**检测到意外断开*/
- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkConnectionFlags)connectionFlags
{
    //通知代理 - 断开连接了（目前处于无连接状态）
    for (NSDictionary *dict in self.delegates) {
        id delegate = dict[kDelegateKey];
        dispatch_queue_t queue = dict[kQueuekey];
        if ([delegate respondsToSelector:@selector(connectionStateDidChange:)]) {
            dispatch_async(queue, ^{
                [delegate connectionStateDidChange:CMConnectionStateDisconnected];
            });
        }
    }
    
}
- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkConnectionFlags)connectionFlags
{
    self.isAutoLogin = YES;
    return self.options.isAutoLogin;
}

#else
/**检测到意外断开*/
- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkReachabilityFlags)connectionFlags
{
    //通知代理 - 断开连接了（目前处于无连接状态）
    for (NSDictionary *dict in self.delegates) {
        id delegate = dict[kDelegateKey];
        dispatch_queue_t queue = dict[kQueuekey];
        if ([delegate respondsToSelector:@selector(connectionStateDidChange:)]) {
            dispatch_async(queue, ^{
               [delegate connectionStateDidChange:CMConnectionStateDisconnected];
            });
        }
    }

}
- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkReachabilityFlags)reachabilityFlags
{
    self.isAutoLogin = YES;
    return self.options.isAutoLogin;
}

#endif



#pragma mark - 工具方法
/**添加代理*/
- (void)addDelegate:(id <CMChatManagerDelegate>)delegate queue:(dispatch_queue_t)queue
{
    if (queue == nil) {
        queue = dispatch_get_main_queue();
    }
    if (delegate == nil) {
        return;
    }
    NSDictionary *dict = @{
                           kDelegateKey:delegate,
                           kQueuekey   :queue
                           };
    
    [self.delegates addObject:dict];
}

/**设置ping心跳包，初始化启动ping*/
- (void)autoPingProxyServer:(NSString *)proxyServer
{
    //初始化ping模块
    XMPPAutoPing *xmppAutoPing = [[XMPPAutoPing alloc]init];
    //设置自动响应ping包
    xmppAutoPing.respondsToQueries = YES;
    //设置时间间隔
    xmppAutoPing.pingTimeout = kAliveInterval;
    //设置代理
    [xmppAutoPing addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //设置服务器地址(如果为空，则自动监听socket stream当前连接上的那个服务器)
    if (proxyServer != nil && proxyServer.length != 0) {
        xmppAutoPing.targetJID = [XMPPJID jidWithString:proxyServer];
    }
    //激活
    [xmppAutoPing activate:self.xmppStream];
    self.xmppAutoPing = xmppAutoPing;
}

/**设置重连模块*/
- (void)setupReconnect
{
    //初始化重连模块
    XMPPReconnect *xmppReconnect = [[XMPPReconnect alloc]init];
    //设置重连周期
    xmppReconnect.reconnectTimerInterval = 5.0;
    //设置自动重连
    xmppReconnect.autoReconnect = YES;
    //设置重连代理
    [xmppReconnect addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //在stream上激活重连模块
    [xmppReconnect activate:self.xmppStream];
    //保存重连属性
    self.xmppReconnect = xmppReconnect;
}

/**上线*/
- (void)goOnline
{
    //创建上线状态
    XMPPPresence *presence = [XMPPPresence presence];    //默认是上线状态
    //发送上线状态
    [self.xmppStream sendElement:presence];
}

/**下线*/
- (void)goOffline
{
    //下线
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
}


#pragma mark - 懒加载
- (XMPPStream *)xmppStream
{
    if (_xmppStream == nil) {
        
        //创建xmppstream
        XMPPStream *xmppStream = [[XMPPStream alloc]init];
        
        //设置服务器信息
        xmppStream.hostName = kHostName;
        xmppStream.hostPort = kHostPort;
        
        //设置心跳包时间
        [xmppStream setKeepAliveInterval:kAliveInterval];
        
        //允许socket在后台运行
        xmppStream.enableBackgroundingOnSocket = YES;
        
        //设置代理
        [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        //赋值
        _xmppStream = xmppStream;
        
    }
    return _xmppStream;
}


- (NSMutableArray<NSDictionary *> *)delegates
{
    if (_delegates == nil) {
        _delegates = [NSMutableArray array];
    }
    return _delegates;
}

- (NSMutableDictionary *)sendingMessagesCache
{
    if (_sendingMessagesCache == nil) {
        _sendingMessagesCache = [NSMutableDictionary dictionary];
    }
    return _sendingMessagesCache;
}


@end
