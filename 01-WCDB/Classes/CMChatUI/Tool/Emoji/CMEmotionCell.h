//
//  CMEmotionCell.h
//
//  Created by 陈华 on 2017/6/20.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMEmotionCell : UICollectionViewCell

@property (weak, nonatomic) UIButton *emotionButton;

/**记录属性*/
@property(nonatomic,copy) NSString *imgName;

@end
