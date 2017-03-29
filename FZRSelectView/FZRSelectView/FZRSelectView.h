//
//  SelectView.h
//  sender
//
//  Created by fuzhaurui on 2016/12/28.
//  Copyright © 2016年 IOS-开发机. All rights reserved.
//

#import <UIKit/UIKit.h>

///MARK: - 传值模块
typedef void(^FZRSelectBlock)(NSInteger integer);

@interface FZRSelectView : UIView

///MARK: - 初始化共享视图
+ (FZRSelectView *)sharedView;

/*
 * MARK: - 开始进行选择
 * title       : 选择标题
 * selectArray : 输入选择待选列表(NSString)
 * selectBlock : 模块传值(传回选择的顺序 从0开始)
 */

- (void)startChoiceTitle:(NSString *)title andSelect:(NSArray *)selectArray blockcompletion:(FZRSelectBlock)selectBlock;
@end
