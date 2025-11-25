//
//  UIView+keyboard.m
//  ZLKeyboardManager
//
//  Created by admin on 2025/10/17.
//

#import "UIView+keyboard.h"
#import <objc/runtime.h>
#import "ZLKeyboardManager.h"

@interface ZLKeyboardConfig()
@property (nonatomic,weak)UIView *view;
@property (nonatomic,assign)CGRect convertFrame;
@property (nonatomic, copy,readwrite) void(^enableIQKeyboardManagerBK)(void);
@property (nonatomic, copy,readwrite) void(^disableIQKeyboardManagerBK)(void);
@end
@implementation ZLKeyboardConfig
@synthesize enableAutoToolbar = _enableAutoToolbar;
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shouldResignOnTouchOutside = YES;
        self.enableAutoToolbar = YES;
        self.enable = YES;
        self.keyboardTopMargin = 0;
    }
    return self;
}
- (UIView *)relativeToKeyboardTopView {
    if (!_relativeToKeyboardTopView) {
        return self.view;
    }
    return _relativeToKeyboardTopView;
}
-(UIViewController*)viewContainingController
{
    UIResponder *nextResponder =  self.view;
    do{
        nextResponder = [nextResponder nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
    } while (nextResponder);
    return nil;
}
- (UIView *)moveContainerView {
    UIView *view = _moveContainerView;
    view = view ?: self.viewContainingController.view;
    view = view ?: ZLKeyboardManager.share.currentResponder.window;
    if ([view isKindOfClass:UIScrollView.class]) return view.superview;
    return view;
}
- (BOOL)shouldResignOnTouchOutside {
    return _shouldResignOnTouchOutside && ZLKeyboardManager.share.shouldResignOnTouchOutside;
}
- (BOOL)enableAutoToolbar {
    return _enableAutoToolbar && ZLKeyboardManager.share.enableAutoToolbar;
}
- (BOOL)enable {
    return ZLKeyboardManager.share.enable && _enable;
}
- (void (^)(UIView<ZLKeyboardProtocol> * _Nonnull))willBecomeFirstResponder {
    return _willBecomeFirstResponder ?: ZLKeyboardManager.share.willBecomeFirstResponder;
}
- (void (^)(UIView<ZLKeyboardProtocol> * _Nonnull))didResignedFirstResponder {
    return _didResignedFirstResponder ?: ZLKeyboardManager.share.didResignedFirstResponder;
}
- (void)becomeFirstResponder {
    if (self.disableIQKeyboardManager && self.willBecomeFirstResponder) {
        self.willBecomeFirstResponder(self.view);
    }
}
- (void)resignFirstResponder {
    if (self.disableIQKeyboardManager && self.didResignedFirstResponder) {
        self.didResignedFirstResponder(self.view);
    }
}

@end
@interface UIView (keyboard)
@property(nonatomic, strong) ZLKeyboardConfig *keyboardCfg;
@end
@implementation UIView (keyboard)
- (ZLKeyboardConfig *)keyboardCfg {
    ZLKeyboardConfig *config = objc_getAssociatedObject(self, _cmd);
    if (!config) {
        if (@available(iOS 13.0, *)) {
            if ([self isKindOfClass:UISearchTextField.class]) {
                UIView *superView = self.superview;
                while (superView && ![superView isKindOfClass:UISearchBar.class]) {
                    superView = superView.superview;
                }
                if (superView && [superView isKindOfClass:UISearchBar.class]) {
                    config = superView.keyboardCfg;
                }
            }else{
                config = ZLKeyboardConfig.new;
                config.view = self;
            }
        } else {
            config = ZLKeyboardConfig.new;
            config.view = self;
        }
        self.keyboardCfg = config;
    }
    return config;
}
- (void)setKeyboardCfg:(ZLKeyboardConfig *)keyboardConfig {
    objc_setAssociatedObject(self, @selector(keyboardCfg), keyboardConfig, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
@implementation NSArray (keyboard)
- (NSArray<UIView*>*)zl_sortedArrayByTag
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        if ([view1 respondsToSelector:@selector(tag)] && [view2 respondsToSelector:@selector(tag)])
        {
            if ([view1 tag] < [view2 tag])    return NSOrderedAscending;
            
            else if ([view1 tag] > [view2 tag])    return NSOrderedDescending;
            
            else    return NSOrderedSame;
        }
        else
            return NSOrderedSame;
    }];
}

- (NSArray<UIView*>*)zl_sortedArrayByPosition
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        CGFloat x1 = CGRectGetMinX(view1.keyboardCfg.convertFrame);
        CGFloat y1 = CGRectGetMinY(view1.keyboardCfg.convertFrame);
        CGFloat x2 = CGRectGetMinX(view2.keyboardCfg.convertFrame);
        CGFloat y2 = CGRectGetMinY(view2.keyboardCfg.convertFrame);
        if (y1 < y2)  return NSOrderedAscending;
        else if (y1 > y2) return NSOrderedDescending;
        else if (x1 < x2)  return NSOrderedAscending;
        else if (x1 > x2) return NSOrderedDescending;
        else    return NSOrderedSame;
    }];
}
@end
