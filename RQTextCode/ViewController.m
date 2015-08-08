//
//  ViewController.m
//  RQTextCode
//
//  Created by qiupeng on 15/8/7.
//  Copyright (c) 2015年 Roc. All rights reserved.
//

#import "ViewController.h"
#import "RQTableViewCell.h"
#import "RQData.h"
#import "RQDataFrame.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *statuses;

@end

@implementation ViewController

#pragma mark - 懒加载
- (NSArray *)statuses
{
    if (_statuses == nil) {
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"statuses.plist" ofType:nil];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:fullPath];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dictArray.count];
        for (NSDictionary *dict in dictArray) {
            RQData *data = [RQData weiboWithDict:dict];
            RQDataFrame *dataFrame = [[RQDataFrame alloc]init];
            dataFrame.data = data;
            [models addObject:dataFrame];
        }
        self.statuses = [models copy];
    }
    return _statuses;
}


- (void)viewDidLoad {
   
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    // 监听链接选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linkDidSelected:) name:HMLinkDidSelectedNotification object:nil];
}


- (void)linkDidSelected:(NSNotification *)note
{
    NSString *linkText = note.userInfo[HMLinkText];
    if ([linkText hasPrefix:@"http"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkText]];
        NSLog(@"%@",linkText);
    } else {
        // 跳转控制器
        HMLog(@"选中了非HTTP链接---%@", note.userInfo[HMLinkText]);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RQTableViewCell *cell = [RQTableViewCell cellWithTableView:tableView];
    cell.dataFrame = self.statuses[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出对应航的frame模型
    RQDataFrame *data = self.statuses[indexPath.row];
    return data.cellHeight;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
