//
//  CMEmotionCell.m
//
//  Created by 陈华 on 2017/6/20.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMEmotionCell.h"

@implementation CMEmotionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UIButton *emotionButton = [[UIButton alloc] init];
        [self.contentView addSubview:emotionButton];
        self.emotionButton = emotionButton;
        emotionButton.userInteractionEnabled = NO;
        
        [self.emotionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.mas_equalTo(self.contentView);
        }];
        
    }
    return self;
}


@end
