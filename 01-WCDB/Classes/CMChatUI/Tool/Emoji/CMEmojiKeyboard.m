//
//  CMEmojiKeyboard.m

//
//  Created by 陈华 on 2017/6/20.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMEmojiKeyboard.h"
#import "CMEmotionPageCell.h"
#import "CMTextAttachment.h"
#import "CMEmotionManager.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width

@interface CMEmojiKeyboard () <UICollectionViewDelegate,UICollectionViewDataSource>

/**collectionView*/
@property(nonatomic,weak) UICollectionView *collectionView;
/**pageControl*/
@property(nonatomic,weak) UIPageControl *pageControl;
/**scrollView*/
@property(nonatomic,weak) UIScrollView *categoryScrollView;
/**发送按钮*/
@property(nonatomic,weak) UIButton *sendButton;

#pragma mark - 其他属性
@property (weak, nonatomic) UITextView *cm_textView;


@end

@implementation CMEmojiKeyboard

static NSString * const ID = @"emotion";

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //设置UI
        [self setupUI:frame];
        
        //监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emojiKeyboardDidSelectedDeleteEmotion:) name:@"CMEmojiKeyboardSelectedDeleteEmotionNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emojiKeyboardDidSelectedEmotion:) name:@"CMEmojiKeyboardSelectedEmotionNotification" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 设置UI
/**设置UI*/
- (void)setupUI:(CGRect)frame
{
    //创建视图
    [self setupElement:frame];
    //设置约束
    [self setupConstraint];
}

/**创建视图*/
- (void)setupElement:(CGRect)frame
{
    //collection
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(ScreenW, frame.size.height - 50);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 50) collectionViewLayout:layout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[CMEmotionPageCell class] forCellWithReuseIdentifier:ID];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    //pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = [CMEmotionManager emotionPage];
    pageControl.userInteractionEnabled = NO;
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    //cateScrollView
    UIScrollView *categoryScrollView = [[UIScrollView alloc] init];
//    categoryScrollView.backgroundColor = [UIColor yellowColor];
    [self addSubview:categoryScrollView];
    self.categoryScrollView = categoryScrollView;

    //发送按钮
    UIButton *sendButton = [[UIButton alloc] init];
    [sendButton addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
    [self addSubview:sendButton];
    self.sendButton = sendButton;
    
}

/**设置约束*/
- (void)setupConstraint
{
    //发送按钮
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
    }];
    
    //catescrollView
    [self.categoryScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self.sendButton.mas_left);
        make.height.mas_equalTo(30);
    }];
    
    //pageControll
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.bottom.mas_equalTo(self.categoryScrollView.mas_top).offset(-3);
        make.height.mas_equalTo(7);
    }];
    
    //collection
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self.pageControl.mas_top).offset(-10);
    }];
}


#pragma mark - UICollectionViewDataSource
// 返回多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

// 返回每组多少行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [CMEmotionManager emotionPage];
}

// 返回cell外观
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CMEmotionPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.emotions = [CMEmotionManager emotionsOfPage:indexPath.row];
    
    return cell;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x / self.bounds.size.width;
    
    self.pageControl.currentPage = page;
}


#pragma mark - 事件监听
//表情键盘上的删除表情被点击
- (void)emojiKeyboardDidSelectedDeleteEmotion:(NSNotification *)notice
{
    if ([self.delegate respondsToSelector:@selector(emojiKeyboardDidDeleteEmotionClicked:)]) {
        [self.delegate emojiKeyboardDidDeleteEmotionClicked:self];
    }
}

//表情键盘上的普通表情被点击
- (void)emojiKeyboardDidSelectedEmotion:(NSNotification *)notice
{
    CMTextAttachment *attachment = notice.object;
    
    if ([self.delegate respondsToSelector:@selector(emojiKeyboard:didNormalEmotionSelected:)]) {
        [self.delegate emojiKeyboard:self didNormalEmotionSelected:attachment];
    }
    
}

//发送按钮被点击
- (void)sendBtnClick
{
    if ([self.delegate respondsToSelector:@selector(emojiKeyboardDidSendBtnClicked:)]) {
        [self.delegate emojiKeyboardDidSendBtnClicked:self];
    }
}




@end
