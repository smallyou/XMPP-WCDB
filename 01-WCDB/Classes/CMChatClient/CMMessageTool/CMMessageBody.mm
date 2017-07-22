//
//  CMMessageBody.m
//  01-WCDB
//
//  Created by 23 on 2017/7/17.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMMessageBody.h"

@implementation CMMessageBody

#pragma mark - WCTColumnCoding
+ (instancetype)unarchiveWithWCTValue:(WCTValue *)value
{
    //二进制
    if ([value isKindOfClass:NSData.class] && [(NSData *)value length]) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)value];
    }
    return nil;
}

- (id /* WCTValue* */)archivedWCTValue
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

+ (WCTColumnType)columnTypeForWCDB
{
    return WCTColumnTypeBinary;
}


#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.type = (CMMessageBodyType)[aDecoder decodeIntegerForKey:@"type"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.type forKey:@"type"];

}


@end
