//
//  CMLocationMessageBody.h
//  01-WCDB
//
//  Created by 23 on 2017/7/18.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMMessageBody.h"

@interface CMLocationMessageBody : CMMessageBody

/**地理位置编号-预留(可以扩展)*/
@property(nonatomic,copy) NSString *locationId;
/**地理位置名称-预留(可以扩展)*/
@property(nonatomic,copy) NSString *name;
/**经度*/
@property(nonatomic,assign) CGFloat longitude;
/**纬度*/
@property(nonatomic,assign) CGFloat latitude;
/**地理位置*/
@property(nonatomic,copy) NSString *address;

@end
