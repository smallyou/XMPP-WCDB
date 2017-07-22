//
//  CMTextMessageBody.m
//  01-WCDB
//
//  Created by 23 on 2017/7/17.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMTextMessageBody.h"

@implementation CMTextMessageBody

#pragma mark - 接口
/**快速创建文本消息体*/
- (instancetype)initWithText:(NSString *)text
{
    if (self = [super init]) {
        self.text = text;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.text = [aDecoder decodeObjectForKey:@"textBody_text"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.text forKey:@"textBody_text"];
}



@end
