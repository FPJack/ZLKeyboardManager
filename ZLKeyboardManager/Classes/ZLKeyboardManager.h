//
//  ZLKeyboardManager.h
//  ZLKeyboardManager
//
//  Created by admin on 2025/10/17.
//

#import <Foundation/Foundation.h>
#import "UIView+keyboard.h"
#import "ZLToolBar.h"

NS_ASSUME_NONNULL_BEGIN
//IQKeyboardManager使用问题
/*
 1.有时键盘会闪跳，viewWillAppear设置弹出键盘会有问题
 2.第一响应者如果没有所属window或者所属控制器，则无法正确计算位置弹出键盘
 3.无法设置移动容器view，默认控制器的view
 4.无法设置键盘相对某个特定view底部的间距，默认是第一响应者底部
 5.无法精确到某个TextField设置是否启用键盘管理
 */
@interface ZLKeyboardManager : NSObject
+ (instancetype)share;
/// 启用/禁用键盘管理，defaults is YES
@property(nonatomic, assign, getter = isEnabled) BOOL enable;
/// 是否启用自动工具栏，defaults is YES
@property(nonatomic, assign, getter = isEnableAutoToolbar) BOOL enableAutoToolbar;
/// 点击背景是否收起键盘，defaults is YES
@property (nonatomic,assign)BOOL shouldResignOnTouchOutside;
/// 当前第一响应者
@property (nonatomic,weak,readonly) UIView *currentResponder;
/// 禁用键盘管理的输入视图类集合
@property(nonatomic, strong,readonly) NSMutableArray<Class> *disabledInputViewClasses;
/// 配置启用键盘管理的输入视图类集合
@property(nonatomic, copy) void (^toolBarConfigureBK)(ZLToolBar *toolBar);

@property (nonatomic, copy,readonly) void(^enableIQKeyboardManagerBK)(void);
@property (nonatomic, copy,readonly) void(^disableIQKeyboardManagerBK)(void);
/// 适配IQKeyboardManager的启用与禁用回调
- (void)adaptIQKeyboardManager:(void(^)(void))enableBK disable:(void(^)(void))disableBK;

///收起键盘
- (BOOL)resignFirstResponder;
/// 上一项
- (BOOL)goPrevious;
/// 下一项
- (BOOL)goNext;
@end
NS_ASSUME_NONNULL_END
