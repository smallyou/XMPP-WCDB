//
//  CMEmojiKeyboard.h
//  GuaPi
//
//  Created by 陈华 on 2017/6/20.
//  Copyright © 2017年 Joanlove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMTextAttachment.h"

@class CMEmojiKeyboard;

@protocol CMEmojiKeyboardDelegate <NSObject>


/**
 表情键盘上普通表情被点击

 @param emojiKeyboard 表情键盘
 @param attachment 富文本
 */
- (void)emojiKeyboard:(CMEmojiKeyboard *)emojiKeyboard didNormalEmotionSelected:(CMTextAttachment *)attachment;


/**
 表情键盘上删除表情被点击

 @param emojiKeyboard 表情键盘
 */
- (void)emojiKeyboardDidDeleteEmotionClicked:(CMEmojiKeyboard *)emojiKeyboard;


/**
 表情键盘上发送按钮被点击

 @param emojiKeyboard 表情键盘
 */
- (void)emojiKeyboardDidSendBtnClicked:(CMEmojiKeyboard *)emojiKeyboard;

@end


@interface CMEmojiKeyboard : UIView

/**代理*/
@property(nonatomic,weak) id<CMEmojiKeyboardDelegate> delegate;

@end
