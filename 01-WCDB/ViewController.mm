//
//  ViewController.m
//  01-WCDB
//
//  Created by 23 on 2017/7/11.
//  Copyright © 2017年 23. All rights reserved.
//

#import "ViewController.h"
#import "CMChatHeader.h"
#import "CMChatController.h"


@interface ViewController () <CMChatManagerDelegate>

@end

@implementation ViewController

static NSString * const UserA = @"sm_ipod";
static NSString * const PwdA  = @"sm_ipod";

static NSString * const UserB = @"sm_mac";
static NSString * const PwdB  = @"sm_mac";


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
/**登录A账号*/
- (IBAction)login:(id)sender {
    
    /**
     u2_479270b3-8afe-47fe-91b7-095a51513a30      C495B42A643E501C
     
     u2_bfaa1d41-6611-4a26-8047-8489210b6715      DE38815BDEAB2F43
     
     */
    
    
    //设置代理
    [[CMChatClient shareClient].chatManager addDelegate:self queue:nil];
    
    [[CMChatClient shareClient] loginWithUsername:UserA password:PwdA callback:^(BOOL success, CMChatError *error, id context) {

        if (success) {
            NSLog(@"成功");
            
            //设置自动登录
            [CMChatClient shareClient].options.isAutoLogin = YES;
            
        }else{
            NSLog(@"失败--->%@",[error getErrorMessage]);
        }
        
    }];
    
    
}

//登录B账号
- (IBAction)loginB:(id)sender {
    
    //设置代理
    [[CMChatClient shareClient].chatManager addDelegate:self queue:nil];
    
    [[CMChatClient shareClient] loginWithUsername:UserB password:PwdB callback:^(BOOL success, CMChatError *error, id context) {
        
        if (success) {
            NSLog(@"成功");
            
            //设置自动登录
            [CMChatClient shareClient].options.isAutoLogin = YES;
            
        }else{
            NSLog(@"失败--->%@",[error getErrorMessage]);
        }
        
    }];
    
}


-(IBAction)createDB
{
    //获取数据库路径
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:@"demo.db"];
    
    [[CMDBManager shareManager] updateDBPath:path];
    
    
    //插入数据
    CMMessage *message = [[CMMessage alloc] init];
    message.messageId = @"msgId_000100010001";
    message.sessionId = @"to#order_id";
    message.createtime = [[NSDate new] timeIntervalSince1970];
    message.modifytime = [[NSDate new] timeIntervalSince1970];
    message.from       = @"me";
    message.to         = @"you";
    message.chatType   = 0;
    message.status     = 0;
    message.isRead     = 1;
    CMTextMessageBody *body = [[CMTextMessageBody alloc] initWithText:@"这是一条内容"];
    message.body = body;
    message.ext = @{kMessageExtDictionaryOrderIdKey:@"order_id",kMessageExtDictionaryOrderTypeKey:@"1"};
    [[CMDBManager shareManager].database insertObject:message into:DB_TABLE_MESSAGE];
    
}

- (IBAction)getData:(id)sender {
    

    
    NSArray *array = [[CMDBManager shareManager].database getAllObjectsOfClass:CMMessage.class fromTable:DB_TABLE_MESSAGE];
    
    NSLog(@"");
    
    
}

/**与A聊天*/
- (IBAction)beginChat:(id)sender {
    
    //创建会话
    NSString *sessionId = [NSString stringWithFormat:@"%@#%@",UserA,@"order_id"];
    CMSession *session = [[CMChatClient shareClient] getSession:sessionId type:CMChatTypeChat createIfNotExist:YES];
    
    //创建消息
    CMTextMessageBody *body = [[CMTextMessageBody alloc] initWithText:@"这是文本消息"];
    NSDictionary *ext = @{kMessageExtDictionaryOrderIdKey:@"order_id",kMessageExtDictionaryOrderTypeKey:@"1"};
    CMMessage *message = [[CMMessage alloc] initWithSessionId:sessionId from:UserB to:UserA body:body ext:ext];
    
    //发送消息
    [[CMChatClient shareClient] sendMessage:message progress:^(int progress) {
        
    } callback:^(BOOL success, CMChatError *error, CMMessage *aMessage) {
        
    }];
}


/**与B俩天*/
- (IBAction)beginChatB:(id)sender {
    
    //创建会话
    NSString *sessionId = [NSString stringWithFormat:@"%@#%@",UserB,@"order_id"];
    CMSession *session = [[CMChatClient shareClient] getSession:sessionId type:CMChatTypeChat createIfNotExist:YES];
    
    //创建消息
    CMTextMessageBody *body = [[CMTextMessageBody alloc] initWithText:@"这是文本消息"];
    NSDictionary *ext = @{kMessageExtDictionaryOrderIdKey:@"order_id",kMessageExtDictionaryOrderTypeKey:@"1"};
    CMMessage *message = [[CMMessage alloc] initWithSessionId:sessionId from:UserA to:UserB body:body ext:ext];
    
    //发送消息
    [[CMChatClient shareClient] sendMessage:message progress:^(int progress) {
        
    } callback:^(BOOL success, CMChatError *error, CMMessage *aMessage) {
        
    }];
    
    
}


#pragma mark - CMChatManagerDelegate

- (void)userAccountDidLoginFromOtherDevice
{
    NSLog(@";asfaksf;la;lfka;lskf;ls  另一个设备上登录");
}

/**连接状态发生改变*/
- (void)connectionStateDidChange:(CMConnectionState)aConnectionState
{
    switch (aConnectionState) {
        case CMConnectionStateConnected:
            NSLog(@"delegate:---->已连接");
            break;
        case CMConnectionStateDisconnected:
            NSLog(@"delegate:---->未连接");
            break;
            
        default:
            break;
    }
}

/**自动登录*/
- (void)autoLoginDidCompleteWithError:(CMChatError *)aError
{
    NSLog(@"自动登录完成后的回调");
}

- (void)messageDidReceive:(NSArray *)aMessages
{
    NSLog(@"接收到消息-------->%@",aMessages.firstObject);
}



@end
