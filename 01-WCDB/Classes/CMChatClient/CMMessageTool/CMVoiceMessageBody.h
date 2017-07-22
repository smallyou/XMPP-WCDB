//
//  CMVoiceMessageBody.h
//  01-WCDB
//
//  Created by 23 on 2017/7/17.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMMessageBody.h"

@interface CMVoiceMessageBody : CMMessageBody

/**语音时长，以秒为单位*/
@property(nonatomic,assign) NSUInteger duration;
/**语音的本地路径*/
@property(nonatomic,copy) NSString *voiceLocalPath;
/**语音的服务器路径*/
@property(nonatomic,copy) NSString *voiceRemotePath;
/**下载状态*/
@property(nonatomic,assign) CMDownloadStatus downloadStatus;


@end
