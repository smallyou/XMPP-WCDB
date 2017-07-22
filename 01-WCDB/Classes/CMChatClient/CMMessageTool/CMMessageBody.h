//
//  CMMessageBody.h
//  01-WCDB
//
//  Created by 23 on 2017/7/17.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMMessageHeader.h"
#import "WCDB.h"



@interface CMMessageBody : NSObject <WCTColumnCoding,NSCoding>

/**消息类型*/
@property(nonatomic,assign) CMMessageBodyType type;


@end
