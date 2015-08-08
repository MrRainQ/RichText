//
//  NJWeibo.h
//  06-预习-微博(通过代码自定义cell)
//
//  Created by 李南江 on 14-4-21.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RQData : NSObject

@property (nonatomic, copy) NSString *text; // 内容
@property (nonatomic, copy) NSString *name; // 昵称
@property (nonatomic, copy) NSString *time; // 时间

@property (nonatomic, copy) NSAttributedString *attributedText;

- (id)initWithDict:(NSDictionary *)dict;
+ (id)weiboWithDict:(NSDictionary *)dict;
@end
