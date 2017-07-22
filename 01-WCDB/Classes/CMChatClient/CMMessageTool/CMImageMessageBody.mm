//
//  CMImageMessageBody.m
//  01-WCDB
//
//  Created by 23 on 2017/7/17.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMImageMessageBody.h"

@implementation CMImageMessageBody

#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        self.width = [aDecoder decodeFloatForKey:@"imageBody_width"];
        self.height = [aDecoder decodeFloatForKey:@"imageBody_height"];
        self.thumbnailRemotePath = [aDecoder decodeObjectForKey:@"imageBody_thumbnailRemotePath"];
        self.bigLocalPath = [aDecoder decodeObjectForKey:@"imageBody_bigLocalPath"];
        self.bigRemotePath = [aDecoder decodeObjectForKey:@"imageBody_bigRemotePath"];
        self.thumbnailLocalPath = [aDecoder decodeObjectForKey:@"imageBody_thumbnailLocalPath"];
        self.thumbnailDisplayName = [aDecoder decodeObjectForKey:@"imageBody_thumbnailDisplayName"];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeFloat:self.width forKey:@"imageBody_width"];
    [aCoder encodeFloat:self.height forKey:@"imageBody_height"];
    [aCoder encodeObject:self.thumbnailRemotePath forKey:@"imageBody_thumbnailRemotePath"];
    [aCoder encodeObject:self.bigLocalPath forKey:@"imageBody_bigLocalPath"];
    [aCoder encodeObject:self.bigRemotePath forKey:@"imageBody_bigRemotePath"];
    [aCoder encodeObject:self.thumbnailLocalPath forKey:@"imageBody_thumbnailLocalPath"];
    [aCoder encodeObject:self.thumbnailDisplayName forKey:@"imageBody_thumbnailDisplayName"];
    
}

/**
 快速构造图片消息体
 
 @param data 图片数据
 @param displayName 显示名称
 @return 结果
 */
- (instancetype)initWithImgData:(NSData *)data displayName:(NSString *)displayName
{
    if (self = [super init]) {
        self.imgData = data;
        self.thumbnailDisplayName = displayName;
        self.thumbnailLocalPath = nil;
        self.thumbnailRemotePath = nil;
        self.bigLocalPath = nil;
        self.bigRemotePath = nil;
        self.width = 0;
        self.height = 0;
    }
    return self;
}




@end
