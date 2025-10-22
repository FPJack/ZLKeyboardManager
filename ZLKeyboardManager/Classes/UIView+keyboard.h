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
@property (nonatomic,assign)BOOL enableAutoToolbar;
@property(nonatomic, assign, getter = isEnabled) BOOL enable;
@property (nonatomic,weak)UIView *moveContainerView;
/// 点击背景是否收起键盘，defaults is YES
@property (nonatomic,assign)BOOL shouldResignOnTouchOutside;
@property (nonatomic,readonly) UIViewController *viewContainingController;
@property (nonatomic, strong) ZLToolBar *keyboardToolbar;
@end
@interface UIView (keyboard)
@property(nonatomic, strong) ZLKeyboardConfig *kfc_keyboardCfg;
@end

NS_ASSUME_NONNULL_END
