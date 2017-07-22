//
//  CMEmotionManager.m
//
//  Created by 陈华 on 2017/6/20.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMEmotionManager.h"

#define EmotionPath [[NSBundle mainBundle] pathForResource:@"emotion.plist" ofType:nil]

@implementation CMEmotionManager

+ (NSArray *)emotions
{
    [self emotionToTextDict];
    return [NSArray arrayWithContentsOfFile:EmotionPath];
}

+ (NSDictionary *)emotionToTextDict
{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"emotionToText.plist" ofType:nil]];
    
    return dict;
}

// 总页数
+ (NSInteger)emotionPage
{
    
    NSInteger emojiCount = [self emotions].count;
    
    return (emojiCount - 1) / emojiCountOfPage + 1;
}

+ (NSArray *)emotionsOfPage:(NSInteger)page
{
    
    NSArray *values = [self emotions];
    
    // 角标
    NSInteger loc = page * emojiCountOfPage;
    
    // 长度
    NSInteger length = emojiCountOfPage;
    
    // 总页数
    NSInteger emojiPage = [self emotionPage];
    
    if (page < 0 || page == emojiPage) {
        NSLog(@"超出页码或者页码不对");
        return nil;
    }
    
    if (page == emojiPage - 1) {
        length = values.count % emojiCountOfPage;
    }
    
    NSIndexSet *indexSets = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(loc, length)];
    
    NSArray *emotions = [values objectsAtIndexes:indexSets];
    
    return emotions;
    
}


#pragma mark - 工具方法

/**根据表情文字获取对应的表情图片,并返回对应的属性字符串*/
+(NSAttributedString *)imageAttributeWithString:(NSString *)str font:(UIFont *)font
{
    //加载plist
    NSDictionary *dict = [self emotionToTextDict];
    
    //取出图片名称
    NSString *imageName = [dict valueForKeyPath:str];
    imageName = [NSString stringWithFormat:@"Emotion.bundle/%@",imageName];
    
    //加载图片
    UIImage *image = [UIImage imageNamed:imageName];
    
    //根据图片路径创建属性字符串
    NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, -4, font.lineHeight, font.lineHeight);
    NSAttributedString *attributeString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    
    return attributeString;
}

/**根据文本内容，匹配表情，返回属性字符串*/
+ (NSAttributedString *)textWithImageString:(NSString *)text font:(UIFont *)font
{
    
    //判断text是否为空
    if (text.length == 0) {
        return nil;
    }
    
    //创建匹配规则
    NSString *pattern = @"\\[.*?\\]";    //匹配表情
    
    //创建正则表达式对象
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    
    
    //开始匹配
    NSArray *results = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    //处理结果
    NSMutableAttributedString *attrMStr = [[NSMutableAttributedString alloc]initWithString:text];
    
    if (results.count == 0) {
        return attrMStr;
    }
    
    for (NSInteger i = results.count - 1; i >= 0; i--) {
        
        //--获取结果
        NSTextCheckingResult *result = results[i];
        
        //--获取表情文字
        NSString *chs = [text substringWithRange:result.range];
        
        //--根据表情文字获取表情图片对应的属性字符串
        NSAttributedString *imageAttr = [self imageAttributeWithString:chs font:font];
        
        //--将获取到的属性字符换替换原来的位置
        [attrMStr replaceCharactersInRange:result.range withAttributedString:imageAttr];
        
    }
    
    return attrMStr;
    
}




@end
