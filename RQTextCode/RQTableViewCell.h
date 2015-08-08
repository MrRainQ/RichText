//
//  RQTableViewCell.h
//  RQTextCode
//
//  Created by qiupeng on 15/8/7.
//  Copyright (c) 2015年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RQDataFrame;
@interface RQTableViewCell : UITableViewCell

@property (nonatomic, strong) RQDataFrame *dataFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
