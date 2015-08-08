//
//  RQDataFrame.h
//  RQTextCode
//
//  Created by qiupeng on 15/8/7.
//  Copyright (c) 2015年 Roc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class RQData;
@interface RQDataFrame : NSObject
/**
 *  正文的frame
 */
@property (nonatomic, assign) CGRect introF;

/**
 *  行高
 */
@property (nonatomic, assign) CGFloat cellHeight;


@property (nonatomic, strong) RQData *data;

@end
