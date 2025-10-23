//
//  UIView+keyboard.h
//  ZLKeyboardManager
//
//  Created by admin on 2025/10/17.
//

#import <UIKit/UIKit.h>
#import "ZLToolBar.h"

NS_ASSUME_NONNULL_BEGIN
@interface NSArray (keyboard)
@property (nonnull, nonatomic, readonly, copy) NSArray<__kindof UIView*> * kfc_sortedArrayByTag;
@property (nonnull, nonatomic, readonly, copy) NSArray<__kindof UIView*> * kfc_sortedArrayByPosition;
@end

@interface ZLKeyboardConfig : NSObject
@property(nonatomic, assign) CGFloat keyboardDistanceFromRelativeView; // default is 0.0
///相对view,默认是输入框
@property(nonatomic, weak) UIView *relativeView;
@property(nonatomic, assign) CGRect originBounds;
@property (nonatomic,assign)BOOL enableAutoToolbar;/// default is YES
@property(nonatomic, assign, getter = isEnabled) BOOL enable;/// default is YES
///自动处理键盘，优先级高与enable属性和ZLKeyboardManager.share.disabledInputViewClasses,前提ZLKeyboardManager.share.enable为YES
@property(nonatomic, copy)BOOL (^shouldAutoHandleKeyboard)(UIView *view);

/// 需要移动的容器view,默认是第一响应者的所属控制器的view，如果没有控制器则是所属window
@property (nonatomic,weak)UIView *moveContainerView;
/// 点击背景是否收起键盘，defaults is YES
@property (nonatomic,assign)BOOL shouldResignOnTouchOutside;
@property (nonatomic,readonly)UIViewController *viewContainingController;
@property (nonatomic, strong) ZLToolBar *keyboardToolbar;
///禁用IQKeyboardManager
@property (nonatomic, assign) BOOL disableIQKeyboardManager;
@property (nonatomic, copy,readonly) void(^enableIQKeyboardManagerBK)(void);
@property (nonatomic, copy,readonly) void(^disableIQKeyboardManagerBK)(void);
/// 适配IQKeyboardManager的启用与禁用回调
- (void)adaptIQKeyboardManager:(void(^)(void))enableBK disable:(void(^)(void))disableBK;
- (void)becomeFirstResponder;
- (void)resignFirstResponder;
@end
@interface UIView (keyboard)
@property(nonatomic, strong) ZLKeyboardConfig *kfc_keyboardCfg;
@end

NS_ASSUME_NONNULL_END
