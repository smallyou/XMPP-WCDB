//
//  NSDateFormatter+Extension.h
//  GuaPi
//
//  Created by 陈华 on 2017/6/20.
//  Copyright © 2017年 Joanlove. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Extension)

+ (id)dateFormatter;

+ (id)dateFormatterWithFormat:(NSString *)dateFormat;

+ (id)defaultDateFormatter;/*yyyy-MM-dd HH:mm:ss*/

@end
