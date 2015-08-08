
#import "RQData.h"
#import "RegexKitLite.h"
#import "RQRegexResult.h"
#import "HMEmotionAttachment.h"
#import "HMEmotionTool.h"

@implementation RQData

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (id)weiboWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (void)setTime:(NSString *)time
{
    _time = [time copy];
    [self createAttributedText];
}

- (void)setName:(NSString *)name
{
    _name = [name copy];
    [self createAttributedText];
}

- (void)setText:(NSString *)text
{
    _text = [text copy];
    [self createAttributedText];
}

- (void)createAttributedText
{
    if (self.text == nil || self.name == nil || self.time == nil) return;

    NSString *nick = [NSString stringWithFormat:@"%@：",self.name];
   
    // 1.用户名在前显示
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:nick];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, nick.length)];
    [string addAttribute:NSFontAttributeName value:RQTextFont range:NSMakeRange(0, nick.length)];
    
    // 2.正文
    NSAttributedString *attributedString = [self attributedStringWithText:self.text];
    [string appendAttributedString:attributedString];
    // 3.时间
    
    NSString *newTime = [NSString stringWithFormat:@" %@",self.time];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:newTime]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor cyanColor] range:NSMakeRange(string.length - self.time.length, self.time.length)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(string.length - self.time.length, self.time.length)];
    self.attributedText =  string;
    
}

- (NSAttributedString *)attributedStringWithText:(NSString *)text
{
    // 1.匹配字符串
    NSArray *regexResults = [self regexResultsWithText:text];
    
    // 2.根据匹配结果，拼接对应的图片表情和普通文
    NSMutableAttributedString  *attributedString = [[NSMutableAttributedString alloc]init];
    // 遍历
    [regexResults enumerateObjectsUsingBlock:^(RQRegexResult *result, NSUInteger idx, BOOL *stop) {
        
        if(result.isEmotion){ // 表情
            // 创建附件对象
            HMEmotionAttachment *attach= [[HMEmotionAttachment alloc]init];
            // 传递表情
            attach.emotion = [HMEmotionTool emotionWithDesc:result.string];
            attach.bounds = CGRectMake(0, -3, RQTextFont.lineHeight, RQTextFont.lineHeight);
            
            // 将附件包装成富文本
            NSAttributedString *subStr = [NSAttributedString attributedStringWithAttachment:attach];
            [attributedString appendAttributedString:subStr];
            
        }else{ // 非表情(直接拼接普通文本)
            NSMutableAttributedString *substr = [[NSMutableAttributedString alloc] initWithString:result.string];
            
            // 匹配#话题#
            NSString *trendRegex = @"#[a-zA-Z0-9\\u4e00-\\u9fa5]+#";
            [result.string enumerateStringsMatchedByRegex:trendRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [substr addAttribute:NSForegroundColorAttributeName value:HMStatusHighTextColor range:*capturedRanges];
                [substr addAttribute:HMLinkText value:*capturedStrings range:*capturedRanges];
            }];
            
            // 匹配@提到
            NSString *mentionRegex = @"@[a-zA-Z0-9\\u4e00-\\u9fa5\\-_]+";
            [result.string enumerateStringsMatchedByRegex:mentionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [substr addAttribute:NSForegroundColorAttributeName value:HMStatusHighTextColor range:*capturedRanges];
                [substr addAttribute:HMLinkText value:*capturedStrings range:*capturedRanges];
            }];
            
            // 匹配超链接
            NSString *httpRegex = @"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";
            [result.string enumerateStringsMatchedByRegex:httpRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
                [substr addAttribute:NSForegroundColorAttributeName value:HMStatusHighTextColor range:*capturedRanges];
                [substr addAttribute:HMLinkText value:*capturedStrings range:*capturedRanges];
            }];
            [attributedString appendAttributedString:substr];
        }
    }];
    
    [attributedString addAttribute:NSFontAttributeName value:RQStatusRichTextFont range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

/**
 *  根据字符串计算出所有的匹配结果（已经排好序）
 *
 *  @param text 字符串内容
 */
- (NSArray *)regexResultsWithText:(NSString *)text
{
    NSMutableArray *regexResults = [NSMutableArray array];
    // 匹配表情
    NSString *emotionRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    [text enumerateStringsMatchedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        RQRegexResult *result = [[RQRegexResult alloc]init];
        result.string = *capturedStrings;
        result.range = *capturedRanges;
        result.emotion = YES;
        [regexResults addObject:result];
    }];
    
    // 匹配非表情
    [text enumerateStringsSeparatedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        RQRegexResult *result = [[RQRegexResult alloc]init];
        result.string = *capturedStrings;
        result.range = *capturedRanges;
        result.emotion = NO;
        [regexResults addObject:result];
    }];
    
    // 排序
    [regexResults sortUsingComparator:^NSComparisonResult(RQRegexResult *rr1, RQRegexResult *rr2) {
        int loc1 = (int)rr1.range.location;
        int loc2 = (int)rr2.range.location;
        
        return [@(loc1) compare:@(loc2)];
        
    }];

    return regexResults;
}

@end
