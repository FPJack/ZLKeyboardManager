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
@end
@implementation UIView (keyboard)
- (ZLKeyboardConfig *)keyboardConfig {
    ZLKeyboardConfig *config = objc_getAssociatedObject(self, _cmd);
    if (!config) {
        config = ZLKeyboardConfig.new;
        config.view = self;
        self.keyboardConfig = config;
    }
    return config;
}
- (void)setKeyboardConfig:(ZLKeyboardConfig *)keyboardConfig {
    objc_setAssociatedObject(self, @selector(keyboardConfig), keyboardConfig, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
