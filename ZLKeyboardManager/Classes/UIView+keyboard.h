//
//  UIView+keyboard.h
//  ZLKeyboardManager
//
//  Created by admin on 2025/10/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface ZLKeyboardConfig : NSObject
@property(nonatomic, assign) CGFloat keyboardDistanceFromRelativeView; // default is 10.0
///相对view,默认是输入框
@property(nonatomic, weak) UIView *relativeView;
@property(nonatomic, assign) CGRect originBounds;
@property (nonatomic,assign)BOOL enableAutoToolbar;
@property (nonatomic,weak)UIView *moveContainerView;
@end
@interface UIView (keyboard)
@property(nonatomic, strong) ZLKeyboardConfig *kfc_keyboardCfg;
@end

NS_ASSUME_NONNULL_END
