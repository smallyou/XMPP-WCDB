//
//  CMMessageHeader.h
//  01-WCDB
//
//  Created by 23 on 2017/7/17.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#ifndef CMMessageHeader_h
#define CMMessageHeader_h

/**消息的方向*/
typedef NS_ENUM(NSInteger,CMMessageDirection) {
    CMMessageDirectionSend                  = 0,        //发送的消息
    CMMessageDirectionReceive               = 1         //接收的消息
};

/**聊天的类型*/
typedef NS_ENUM(NSInteger,CMChatType) {
    CMChatTypeChat                          = 0,        //单聊
    CMChatTypeGroup                         = 1         //群聊
};

/**消息的类型*/
typedef NS_ENUM(NSInteger, CMMessageBodyType) {
    CMMessageBodyTypeText                   = 0,        //文本类型
    CMMessageBodyTypeImage                  = 1,        //图片类型
    CMMessageBodyTypeVideo                  = 2,        //视频类型
    CMMessageBodyTypeLocation               = 3,        //位置类型
    CMMessageBodyTypeVoice                  = 4,        //语音消息
    CMMessageBodyTypeFile                   = 5,        //文件类型
    CMMessageBodyTypeCmd                    = 6         //命令类型
};

/**消息的状态*/
typedef NS_ENUM(NSInteger,CMMessageStatus) {
    CMMessageStatusPending                  = 0,        //发送未开始
    CMMessageStatusDelivering               = 1,        //正在发送
    CMMessageStatusSuccessed                = 2,        //发送成功
    CMMessageStatusFailed                   = 3         //发送失败
};

/**附件的下载状态*/
typedef NS_ENUM(NSInteger,CMDownloadStatus) {
    CMDownloadStatusPending                 = 0,        //准备下载
    CMDownloadStatusDownloading             = 1,        //正在下载
    CMDownloadStatusSuccessed               = 2,        //下载成功
    CMDownloadStatusFailed                  = 3         //下载失败
};




#endif /* CMMessageHeader_h */
