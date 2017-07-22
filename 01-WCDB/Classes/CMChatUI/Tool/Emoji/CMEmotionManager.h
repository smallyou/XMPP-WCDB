//
//  CMEmotionManager.h
//
//  Created by 陈华 on 2017/6/20.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import <Foundation/Foundation.h>

// 一页多少个
static NSInteger const emojiCountOfPage = 20;

// 一页多少列
static NSInteger const colsOfPage = 7;

// 每个emotion尺寸
static NSInteger const emotionWH = 30;


@interface CMEmotionManager : NSObject

/** 所有表情 */
+ (NSArray *)emotions;

/** 表情转字符串字典 */
+ (NSDictionary *)emotionToTextDict;

/** 总页码 */
+ (NSInteger)emotionPage;

/**
 *  指定页码，返回当前页的表情
 *
 *  @param page 页码
 *
 *  @return 当前页的标签
 */
+ (NSArray *)emotionsOfPage:(NSInteger)page;


/**
 根据给定的字体和表情文字，返回表情图片对应的属性字符串
 
 @param str 表情文字
 @param font 字体
 @return 属性字符串
 */
+(NSAttributedString *)imageAttributeWithString:(NSString *)str font:(UIFont *)font;


/**
 根据文本内容，匹配表情，返回属性字符串
 
 @param text 文本内容
 @param font 字体
 @return 属性字符串
 */
+ (NSAttributedString *)textWithImageString:(NSString *)text font:(UIFont *)font;

@end
