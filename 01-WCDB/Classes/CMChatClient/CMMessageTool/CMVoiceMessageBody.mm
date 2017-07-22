//
//  CMVoiceMessageBody.m
//  01-WCDB
//
//  Created by 23 on 2017/7/17.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMVoiceMessageBody.h"

@implementation CMVoiceMessageBody

#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        self.duration = [aDecoder decodeIntegerForKey:@"voiceBody_duration"];
        self.voiceLocalPath = [aDecoder decodeObjectForKey:@"voiceBody_voiceLocalPath"];
        self.voiceRemotePath = [aDecoder decodeObjectForKey:@"voiceBody_voiceRemotePath"];
        self.downloadStatus = (CMDownloadStatus)[aDecoder decodeIntegerForKey:@"voiceBody_downloadStatus"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.duration forKey:@"voiceBody_duration"];
    [aCoder encodeObject:self.voiceLocalPath forKey:@"voiceBody_voiceLocalPath"];
    [aCoder encodeObject:self.voiceRemotePath forKey:@"voiceBody_voiceRemotePath"];
    [aCoder encodeInteger:self.downloadStatus forKey:@"voiceBody_downloadStatus"];
    
}


@end
