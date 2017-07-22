//
//  CMLocationMessageBody.m
//  01-WCDB
//
//  Created by 23 on 2017/7/18.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMLocationMessageBody.h"

@implementation CMLocationMessageBody

#pragma mark - NSCoding
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        self.longitude = [aDecoder decodeFloatForKey:@"locationBody_longitude"];
        self.latitude  = [aDecoder decodeFloatForKey:@"locationBody_latitude"];
        self.locationId = [aDecoder decodeObjectForKey:@"locationBody_locationId"];
        self.name = [aDecoder decodeObjectForKey:@"locationBody_name"];
        self.address = [aDecoder decodeObjectForKey:@"locationBody_address"];

        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeFloat:self.longitude forKey:@"locationBody_longitude"];
    [aCoder encodeFloat:self.latitude forKey:@"locationBody_latitude"];
    [aCoder encodeObject:self.locationId forKey:@"locationBody_locationId"];
    [aCoder encodeObject:self.name forKey:@"locationBody_name"];
    [aCoder encodeObject:self.address forKey:@"locationBody_address"];
    
}


@end
