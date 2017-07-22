//
//  CMTextMessageBody.h
//  01-WCDB
//
//  Created by 23 on 2017/7/17.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMMessageBody.h"

@interface CMTextMessageBody : CMMessageBody

/**文本内容*/
@property(nonatomic,copy) NSString *text;



#pragma mark - 接口

/**
 快速创建文本消息体

 @param text 文本消息内容
 @return 文本消息体
 */
- (instancetype)initWithText:(NSString *)text;

@end
