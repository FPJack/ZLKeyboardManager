//
//  UIView+keyboard.m
//  ZLKeyboardManager
//
//  Created by admin on 2025/10/17.
//

#import "UIView+keyboard.h"
#import <objc/runtime.h>
@interface ZLKeyboardConfig()
@property (nonatomic,weak)UIView *view;
@end
@implementation ZLKeyboardConfig
- (UIView *)relativeView {
    if (!_relativeView) {
        return self.view;
    }
    return _relativeView;
}
- (void)setEnableAutoToolbar:(BOOL)enableAutoToolbar {
    if ([self.view isKindOfClass:UISearchBar.class]) {
        UISearchBar *searchBar = (UISearchBar *)self.view;
        if (@available(iOS 13.0, *)) {
            searchBar.searchTextField.kfc_keyboardCfg.enableAutoToolbar = enableAutoToolbar;
        } else {
            // Fallback on earlier versions
        }
    }else {
    }
    _enableAutoToolbar = enableAutoToolbar;
}
- (void)setKeyboardDistanceFromRelativeView:(CGFloat)keyboardDistanceFromRelativeView {
    if ([self.view isKindOfClass:UISearchBar.class]) {
        UISearchBar *searchBar = (UISearchBar *)self.view;
        if (@available(iOS 13.0, *)) {
            searchBar.searchTextField.kfc_keyboardCfg.keyboardDistanceFromRelativeView = keyboardDistanceFromRelativeView;
        } else {
            // Fallback on earlier versions
        }
    }else {
    }
    _keyboardDistanceFromRelativeView = keyboardDistanceFromRelativeView;
}
@end
@implementation UIView (keyboard)
- (ZLKeyboardConfig *)kfc_keyboardCfg {
    ZLKeyboardConfig *config = objc_getAssociatedObject(self, _cmd);
    if (!config) {
        config = ZLKeyboardConfig.new;
        config.view = self;
        self.kfc_keyboardCfg = config;
    }
    return config;
}
- (void)setKfc_keyboardCfg:(ZLKeyboardConfig *)keyboardConfig {
    objc_setAssociatedObject(self, @selector(kfc_keyboardCfg), keyboardConfig, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
