//
//  RQTableViewCell.m
//  RQTextCode
//
//  Created by qiupeng on 15/8/7.
//  Copyright (c) 2015年 Roc. All rights reserved.
//

#import "RQTableViewCell.h"
#import "RQData.h"
#import "RQDataFrame.h"
#import "RQRegexResult.h"
#import "RQStatusLabel.h"
@interface RQTableViewCell()

@property (nonatomic, weak) RQStatusLabel *contentLabel;

@end

@implementation RQTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        RQStatusLabel *contentLabel = [[RQStatusLabel alloc]init];
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"aaaaa";
    // 1.缓存中取
    RQTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[RQTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    return cell;
}

- (void)setDataFrame:(RQDataFrame *)dataFrame
{
    _dataFrame = dataFrame;
    
    RQData *data = _dataFrame.data;
    self.contentLabel.attributedText = data.attributedText;
    self.contentLabel.frame = _dataFrame.introF;
}
@end
