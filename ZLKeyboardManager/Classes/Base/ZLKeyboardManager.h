//
//  ZLKeyboardManager.h
//  ZLKeyboardManager
//
//  Created by admin on 2025/10/17.
//

#import <Foundation/Foundation.h>
#import "UIView+keyboard.h"
#import "ZLToolBar.h"
#import "ZLTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (method_hook)
+ (BOOL)zl_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;
@end

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
/// 是否启用自动工具栏，defaults is NO
@property(nonatomic, assign, getter = isEnableAutoToolbar) BOOL enableAutoToolbar;
/// 点击背景是否收起键盘，defaults is YES
@property (nonatomic,assign)BOOL shouldResignOnTouchOutside;
/// 当前第一响应者
@property (nonatomic,weak,readonly) UIView<ZLKeyboardProtocol>* currentResponder;
/// 禁用键盘管理的输入视图类集合
@property(nonatomic, strong,readonly) NSMutableArray<Class> *disabledInputViewClasses;
/// 配置启用键盘管理的输入视图类集合
@property(nonatomic, copy) void (^configureToolBarBK)(ZLToolBar *toolBar);
///是否需要重写键盘外观
@property(nonatomic, assign) BOOL overrideKeyboardAppearance;
///overrideKeyboardAppearance为YES，则所有输入框的keyboardAppearance都使用此属性设置
@property(nonatomic, assign) UIKeyboardAppearance keyboardAppearance;

///当scrollview拖拽的时候子视图键盘是否要消失, defaults is YES
@property(nonatomic, assign) BOOL shouldDismissKeyboardOnScrollViewDrag;

///输入库失去第一响应者回调，可以手动适配IQKeyboardManager
@property (nonatomic, copy) void(^didResignedFirstResponder)(UIView<ZLKeyboardProtocol> *view);
/// 输入库将要成为第一响应者回调，可以手动适配IQKeyboardManager
@property (nonatomic, copy) void(^willBecomeFirstResponder)(UIView<ZLKeyboardProtocol> *view);

@property (nonatomic, readonly) BOOL canGoPrevious;

@property (nonatomic, readonly) BOOL canGoNext;

- (void)registerAllNotifications;

- (void)unregisterAllNotifications;
///收起键盘
- (BOOL)resignFirstResponder;
/// 上一项
- (BOOL)goPrevious;
/// 下一项
- (BOOL)goNext;
@end
NS_ASSUME_NONNULL_END
