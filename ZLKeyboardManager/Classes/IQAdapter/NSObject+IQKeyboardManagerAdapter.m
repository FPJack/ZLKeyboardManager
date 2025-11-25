//
//  NSObject+IQKeyboardManagerAdapter.m
//  ZLKeyboardManager
//
//  Created by admin on 2025/11/25.
//

#import "NSObject+IQKeyboardManagerAdapter.h"
#import <objc/runtime.h>
#import "ZLKeyboardManager.h"
@implementation NSObject (IQKeyboardManagerAdapter)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSObject* manager = [NSClassFromString(@"IQKeyboardManager") performSelector:@selector(sharedManager)];
        if (manager) {
            [manager.class zl_swizzleClassMethod:@selector(keyboardWillShow:) with:@selector(hook_iqkeyboard_keyboardWillShow:)];
            [manager.class zl_swizzleClassMethod:@selector(keyboardDidShow:) with:@selector(hook_iqkeyboard_keyboardDidShow:)];
            [manager.class zl_swizzleClassMethod:@selector(keyboardWillHide:) with:@selector(hook_iqkeyboard_keyboardWillHide:)];
            [manager.class zl_swizzleClassMethod:@selector(keyboardDidHide:) with:@selector(hook_iqkeyboard_keyboardDidHide:)];
            [manager.class zl_swizzleClassMethod:@selector(textFieldViewDidBeginEditing:) with:@selector(hook_iqkeyboard_textFieldViewDidBeginEditing:)];
            [manager.class zl_swizzleClassMethod:@selector(textFieldViewDidEndEditing:) with:@selector(hook_iqkeyboard_textFieldViewDidEndEditing:)];
        }
    });
}
- (BOOL)disable_ieqkeyboard_manager{
    ZLKeyboardConfig *cfg = ZLKeyboardManager.share.currentResponder.keyboardCfg;
    if (cfg.enable && cfg.disableIQKeyboardManager) {
        return YES;
    }
    return NO;
}

-(void)hook_iqkeyboard_keyboardWillShow:(NSNotification*)aNotification{
    if (![self disable_ieqkeyboard_manager]){
        [self hook_iqkeyboard_keyboardWillShow:aNotification];
    }
}
- (void)hook_iqkeyboard_keyboardDidShow:(NSNotification*)aNotification {
    if (![self disable_ieqkeyboard_manager]) {
        [self hook_iqkeyboard_keyboardDidShow:aNotification];
    }

}
- (void)hook_iqkeyboard_keyboardWillHide:(NSNotification*)aNotification{
    if (![self disable_ieqkeyboard_manager]) {
        [self hook_iqkeyboard_keyboardWillHide:aNotification];
    }

}
- (void)hook_iqkeyboard_keyboardDidHide:(NSNotification*)aNotification{
    if (![self disable_ieqkeyboard_manager]) {
        [self hook_iqkeyboard_keyboardDidHide:aNotification];
    }

}
-(void)hook_iqkeyboard_textFieldViewDidBeginEditing:(NSNotification*)notification{
    if (![self disable_ieqkeyboard_manager]) {
        [self hook_iqkeyboard_textFieldViewDidBeginEditing:notification];
    }

}
-(void)hook_iqkeyboard_textFieldViewDidEndEditing:(NSNotification*)notification{
    if (![self disable_ieqkeyboard_manager]) {
        [self hook_iqkeyboard_textFieldViewDidEndEditing:notification];
    }
}
@end
