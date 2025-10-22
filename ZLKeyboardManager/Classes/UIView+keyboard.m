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
        self.keyboardDistanceFromRelativeView = 0;
    }
    return self;
}
- (UIView *)relativeView {
    if (!_relativeView) {
        return self.view;
    }
    return _relativeView;
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
    if (_moveContainerView) return _moveContainerView;
    return self.viewContainingController.view;
}
- (BOOL)shouldResignOnTouchOutside {
    return _shouldResignOnTouchOutside && ZLKeyboardManager.share.shouldResignOnTouchOutside;
}
- (BOOL)enableAutoToolbar {
    return _enableAutoToolbar && ZLKeyboardManager.share.enableAutoToolbar;
}
- (BOOL)isEnabled {
    return ZLKeyboardManager.share.enable && _enable;
}
@end
@implementation UIView (keyboard)
- (ZLKeyboardConfig *)kfc_keyboardCfg {
    ZLKeyboardConfig *config = objc_getAssociatedObject(self, _cmd);
    if (!config) {
        if (@available(iOS 13.0, *)) {
            if ([self isKindOfClass:UISearchTextField.class]) {
                UIView *superView = self.superview;
                while (superView && ![superView isKindOfClass:UISearchBar.class]) {
                    superView = superView.superview;
                }
                if (superView && [superView isKindOfClass:UISearchBar.class]) {
                    config = superView.kfc_keyboardCfg;
                }
            }else{
                config = ZLKeyboardConfig.new;
                config.view = self;
            }
        } else {
            config = ZLKeyboardConfig.new;
            config.view = self;
        }
        self.kfc_keyboardCfg = config;
    }
    return config;
}
- (void)setKfc_keyboardCfg:(ZLKeyboardConfig *)keyboardConfig {
    objc_setAssociatedObject(self, @selector(kfc_keyboardCfg), keyboardConfig, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
@implementation NSArray (keyboard)
- (NSArray<UIView*>*)kfc_sortedArrayByTag
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

- (NSArray<UIView*>*)kfc_sortedArrayByPosition
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(UIView *view1, UIView *view2) {
        CGFloat x1 = CGRectGetMinX(view1.kfc_keyboardCfg.convertFrame);
        CGFloat y1 = CGRectGetMinY(view1.kfc_keyboardCfg.convertFrame);
        CGFloat x2 = CGRectGetMinX(view2.kfc_keyboardCfg.convertFrame);
        CGFloat y2 = CGRectGetMinY(view2.kfc_keyboardCfg.convertFrame);
        if (y1 < y2)  return NSOrderedAscending;
        else if (y1 > y2) return NSOrderedDescending;
        else if (x1 < x2)  return NSOrderedAscending;
        else if (x1 > x2) return NSOrderedDescending;
        else    return NSOrderedSame;
    }];
}
@end
