//
//  RQDataFrame.m
//  RQTextCode
//
//  Created by qiupeng on 15/8/7.
//  Copyright (c) 2015年 Roc. All rights reserved.
//

#import "RQDataFrame.h"
#import "RQData.h"

static int margin = 10;

@implementation RQDataFrame

- (void)setData:(RQData *)data
{
    _data = data;
    
    // 设置正文的frame
    CGFloat introLabelX = margin;
    CGFloat introLabelY = margin;

    CGFloat maxW = HMScreenW - 2 * margin;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [_data.attributedText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    CGFloat introLabelW = textSize.width;
    CGFloat introLabelH = textSize.height;
    
    self.introF = CGRectMake(introLabelX, introLabelY, introLabelW, introLabelH);

    self.cellHeight = CGRectGetMaxY(self.introF) + margin;
}


@end
