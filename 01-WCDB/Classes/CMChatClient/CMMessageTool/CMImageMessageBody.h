//
//  CMImageMessageBody.h
//  01-WCDB
//
//  Created by 23 on 2017/7/17.
//  Copyright © 2017年 smallyou. All rights reserved.
//

#import "CMMessageBody.h"
#import <UIKit/UIKit.h>

@interface CMImageMessageBody : CMMessageBody


/**缩略图的宽*/
@property(nonatomic,assign) CGFloat width;
/**缩略图的高度*/
@property(nonatomic,assign) CGFloat height;

/**缩略图显示名称*/
@property(nonatomic,copy) NSString *thumbnailDisplayName;
/**缩略图本地路径*/
@property(nonatomic,copy) NSString *thumbnailLocalPath;
/**缩略图在服务器上的路径*/
@property(nonatomic,copy) NSString *thumbnailRemotePath;
/**大图在本地的路径*/
@property(nonatomic,copy) NSString *bigLocalPath;
/**大图在服务器上的路径*/
@property(nonatomic,copy) NSString *bigRemotePath;

#pragma mark - 附件属性
/**图片数据*/
@property(nonatomic,strong) NSData *imgData;


/**
 快速构造图片消息体

 @param data 图片数据
 @param displayName 显示名称
 @return 结果
 */
- (instancetype)initWithImgData:(NSData *)data displayName:(NSString *)displayName;



@end
