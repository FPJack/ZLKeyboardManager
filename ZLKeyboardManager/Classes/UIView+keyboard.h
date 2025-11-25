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
@property (nonnull, nonatomic, readonly, copy) NSArray<__kindof UIView*> * zl_sortedArrayByTag;
@property (nonnull, nonatomic, readonly, copy) NSArray<__kindof UIView*> * zl_sortedArrayByPosition;
@end

@interface ZLKeyboardConfig : NSObject
///相对键盘顶部的view,默认是输入框
@property(nonatomic,   weak) UIView *relativeToKeyboardTopView;
///键盘顶部的间距
@property(nonatomic, assign) CGFloat keyboardTopMargin;

@property(nonatomic, assign) CGRect originBounds;
/// default is YES
@property (nonatomic,assign) BOOL enableAutoToolbar;
/// default is YES
@property(nonatomic, assign) BOOL enable;
///自动处理键盘，优先级高与enable属性和ZLKeyboardManager.share.disabledInputViewClasses,前提ZLKeyboardManager.share.enable为YES
@property(nonatomic,   copy) BOOL (^shouldAutoHandleKeyboard)(UIView *view);

/// 需要移动的容器view,默认是第一响应者的所属控制器的view，如果没有控制器则是所属window
@property (nonatomic,weak)   UIView *moveContainerView;
/// 点击背景是否收起键盘，defaults is YES
@property (nonatomic,assign) BOOL shouldResignOnTouchOutside;

@property (nonatomic,readonly)UIViewController *viewContainingController;

@property (nonatomic, strong) ZLToolBar *keyboardToolbar;
///禁用IQKeyboardManager
@property (nonatomic, assign) BOOL disableIQKeyboardManager;

@property (nonatomic, copy,readonly) void(^enableIQKeyboardManagerBK)(void);
@property (nonatomic, copy,readonly) void(^disableIQKeyboardManagerBK)(void);
/// 适配IQKeyboardManager的启用与禁用回调
- (void)adaptIQKeyboardManager:(void(^)(void))enableBK disable:(void(^)(void))disableBK;

@end



@protocol ZLKeyboardProtocol <NSObject>
@property(nonatomic, strong) ZLKeyboardConfig *keyboardCfg;
@end
@interface UITextField (ZLkeyboard)<ZLKeyboardProtocol>
@end
@interface UITextView (ZLkeyboard)<ZLKeyboardProtocol>
@end
@interface UISearchBar (ZLkeyboard)<ZLKeyboardProtocol>
@end
NS_ASSUME_NONNULL_END
