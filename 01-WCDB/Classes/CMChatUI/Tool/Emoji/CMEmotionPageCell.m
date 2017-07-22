//
//  CMEmotionPageCell.m
//
//  Created by 陈华 on 2017/6/20.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMEmotionPageCell.h"
#import "CMEmotionManager.h"
#import "CMEmotionCell.h"
#import "CMTextAttachment.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width

@interface CMEmotionPageCell () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) UICollectionView *collectionView;

@end

@implementation CMEmotionPageCell

static NSString * const ID = @"emojicell";

- (UICollectionView *)collectionView{
    
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 计算间距
        CGFloat margin = (ScreenW - colsOfPage * emotionWH) / (colsOfPage + 1);
        layout.itemSize = CGSizeMake(emotionWH, emotionWH);
        layout.minimumInteritemSpacing = margin;
        layout.minimumLineSpacing = margin;
        layout.sectionInset = UIEdgeInsetsMake(margin, margin, 0, margin);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.scrollEnabled  = NO;
        [collectionView registerClass:[CMEmotionCell class] forCellWithReuseIdentifier:ID];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:collectionView];
        self.collectionView = collectionView;
    }
    
    return _collectionView;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    [self.collectionView reloadData];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _emotions.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CMEmotionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSString *imageName = @"Emotion.bundle/delete";
    
    if (indexPath.row < _emotions.count) {
        //取出表情字典
        NSDictionary *dict = self.emotions[indexPath.row];
        imageName = [NSString stringWithFormat:@"Emotion.bundle/%@",dict[@"img"]];
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    [cell.emotionButton setBackgroundImage:image forState:UIControlStateNormal];
    cell.imgName = imageName;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _emotions.count) {
        // 点击最后一个 删除
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CMEmojiKeyboardSelectedDeleteEmotionNotification" object:nil];
        return;
    }
    CMEmotionCell *cell = (CMEmotionCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    CMTextAttachment *attachment = [[CMTextAttachment alloc] init];
    attachment.image = [cell.emotionButton backgroundImageForState:UIControlStateNormal];
    //取出字典
    NSDictionary *dict = self.emotions[indexPath.row];
    //取出文本
    attachment.emotionStr = dict[@"name"];
    attachment.bounds = CGRectMake(0, -3, attachment.image.size.width, attachment.image.size.height);
    
    
    // 点击表情
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CMEmojiKeyboardSelectedEmotionNotification" object:attachment];
    
    
}


@end
